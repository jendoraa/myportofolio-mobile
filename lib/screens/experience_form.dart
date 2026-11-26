import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';
import 'package:myportofolio_mobile/screens/experience_list.dart';
import 'package:myportofolio_mobile/services/auth_state.dart';
import 'package:myportofolio_mobile/services/api_client.dart';
import 'package:myportofolio_mobile/widgets/auth_guard.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';
import 'package:provider/provider.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _title = "";
  String _description = "";
  String _position = "";
  String _thumbnail = ""; // default
  DateTime? _startedAt;
  DateTime? _endedAt;
  bool _isOngoing = false;
  bool _isSubmitting = false;

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '${date.year}/$m/$d';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final current = isStart ? _startedAt : _endedAt;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(2000),
      lastDate: isStart ? now : DateTime(now.year + 10),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startedAt = picked;
      } else {
        _endedAt = picked;
      }
    });
  }

  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }

  void _snack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!await ensureLoggedIn(context)) return;
    if (!mounted) return;

    final auth = context.read<AuthState>();
    final api = context.read<ApiClient>();
    final token = auth.token!;

    setState(() {
      _isSubmitting = true;
    });

    final newExperience = Experience(
      title: _title.trim(),
      description: _description.trim(),
      position: _position.trim(),
      thumbnail: _thumbnail.trim(),
      startedAt: _formatDate(_startedAt!),
      endedAt: _isOngoing ? null : _formatDate(_endedAt!),
    );

    try {
      await api.createExperience(newExperience, token: token);
      if (!mounted) return;

      final goToList = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Pengalaman berhasil ditambahkan!'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Judul: ${newExperience.title}'),
                Text('Posisi: ${newExperience.position}'),
                Text('Mulai: ${newExperience.startedAt}'),
                Text(
                  'Selesai: ${newExperience.isOngoing ? 'Sekarang' : newExperience.endedAt}',
                ),
                Text('Deskripsi: ${newExperience.description}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Tambah Lagi'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Lihat Daftar'),
            ),
          ],
        ),
      );

      if (!mounted) return;
      if (goToList == true) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, true);
        } else {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ExperienceListScreen()),
          );
        }
        return;
      }

      _formKey.currentState!.reset();
      setState(() {
        _title = "";
        _position = "";
        _description = "";
        _thumbnail = "";
        _startedAt = null;
        _endedAt = null;
        _isOngoing = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.statusCode == 401) {
        await auth.logout();
        if (!mounted) return;
        _snack('Sesi habis (401). Silakan login ulang.');
        await ensureLoggedIn(context);
      } else {
        _snack('Gagal menyimpan pengalaman (${e.statusCode}).');
      }
    } catch (_) {
      if (!mounted) return;
      _snack('Tidak dapat terhubung ke server.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  InputDecoration _decoration(String hint, String label) => InputDecoration(
    hintText: hint,
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Experience Form')),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // === Title ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    'Contoh: BEM Fasilkom UI',
                    'Judul Pengalaman',
                  ),
                  onChanged: (String? value) => _title = value ?? "",
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Judul Pengalaman tidak boleh kosong!";
                    }
                    if (value.trim().length > 60) {
                      return "Judul maksimal 60 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Position ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    "Contoh: Frontend Dev",
                    "Posisi / Jabatan",
                  ),
                  onChanged: (String? value) => _position = value ?? "",
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Posisi / jabatan tidak boleh kosong!";
                    }
                    if (value.trim().length > 20) {
                      return "Posisi maksimal 20 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Start Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  initialValue: _startedAt,
                  validator: (_) {
                    if (_startedAt == null) {
                      return 'Tanggal mulai tidak boleh kosong';
                    }
                    return null;
                  },
                  builder: (state) => InkWell(
                    onTap: () async {
                      await _pickDate(isStart: true);
                      state.didChange(_startedAt);
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Tanggal Mulai',
                        suffixIcon: const Icon(Icons.calendar_today),
                        errorText: state.errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        _startedAt == null
                            ? 'Pilih tanggal mulai'
                            : _formatDate(_startedAt!),
                      ),
                    ),
                  ),
                ),
              ),

              // === Is Ongoing ===
              SwitchListTile(
                title: const Text("Masih aktif"),
                value: _isOngoing,
                activeThumbColor: Colors.indigo,
                onChanged: (bool value) {
                  setState(() {
                    _isOngoing = value;
                    if (value) {
                      _endedAt = null;
                    }
                  });
                },
              ),

              // === End Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  validator: (_) {
                    if (_isOngoing) return null;
                    if (_endedAt == null) {
                      return "Tanggal selesai tidak boleh kosong!";
                    }
                    if (_startedAt != null && _endedAt!.isBefore(_startedAt!)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                  builder: (state) => InkWell(
                    onTap: _isOngoing
                        ? null
                        : () async {
                            await _pickDate(isStart: false);
                            state.didChange(_endedAt); // hapus pesan error lama
                          },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Tanggal Selesai",
                        enabled: !_isOngoing,
                        suffixIcon: const Icon(Icons.calendar_today),
                        errorText: _isOngoing ? null : state.errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        _isOngoing
                            ? "Sekarang"
                            : (_endedAt == null
                                  ? "Pilih tanggal selesai"
                                  : _formatDate(_endedAt!)),
                      ),
                    ),
                  ),
                ),
              ),

              // === Description ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLines: 5,
                  decoration: _decoration(
                    "Deskripsi Pengalaman",
                    "Deskripsi Pengalaman",
                  ),
                  onChanged: (String? value) => _description = value ?? "",
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Deskripsi tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
              ),

              // === Thumbnail URL (Optional) ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _decoration(
                    'https://... (opsional)',
                    'Thumbnail URL (Opsional)',
                  ),
                  onChanged: (String? value) => _thumbnail = value ?? "",
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!_isValidUrl(value)) {
                      return 'URL tidak valid (pakai http/https)';
                    }
                    return null;
                  },
                ),
              ),

              // === Tombol Simpan ===
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.indigo),
                    ),
                    onPressed: _isSubmitting ? null : _submit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
