import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/widgets/left_drawer.dart';

class ExperienceFormPage extends StatefulWidget {
  const ExperienceFormPage({super.key});

  @override
  State<ExperienceFormPage> createState() => _ExperienceFormPageState();
}

class _ExperienceFormPageState extends State<ExperienceFormPage> {
  final _formKey = GlobalKey<FormState>();

  String _position = "";
  String _organization = "";
  String _type = "Organisasi"; // default
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isActive = false;
  String _description = "";

  final List<String> _types = ['Organisasi', 'Kepanitiaan', 'Asisten Dosen'];

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d/$m/${date.year}';
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final current = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(2000),
      lastDate: isStart ? now : DateTime(now.year + 10),
    );
    if (picked == null || !mounted) return;
    setState(() {
      if (isStart) {
        _startDate = picked;
      } else {
        _endDate = picked;
      }
    });
  }

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
              // === Position ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: Frontend Developer",
                    labelText: "Posisi / Jabatan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _position = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Posisi tidak boleh kosong!";
                    }
                    if (value.trim().length > 60) {
                      return "Posisi maksimal 60 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Organization ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Contoh: BEM Fasilkom",
                    labelText: "Organisasi / Perusahaan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _organization = value!;
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama organisasi tidak boleh kosong!";
                    }
                    if (value.trim().length > 80) {
                      return "Nama organisasi maksimal 80 karakter!";
                    }
                    return null;
                  },
                ),
              ),

              // === Type ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Tipe Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialValue: _type,
                  items: _types
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _type = newValue!;
                    });
                  },
                ),
              ),

              // === Start Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  validator: (_) {
                    if (_startDate == null) {
                      return "Tanggal mulai tidak boleh kosong!";
                    }
                    return null;
                  },
                  builder: (state) => InkWell(
                    onTap: () async {
                      await _pickDate(isStart: true);
                      state.didChange(_startDate); // hapus pesan error lama
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Tanggal Mulai",
                        suffixIcon: const Icon(Icons.calendar_today),
                        errorText: state.errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        _startDate == null
                            ? "Pilih tanggal mulai"
                            : _formatDate(_startDate!),
                      ),
                    ),
                  ),
                ),
              ),

              // === Is Active ===
              SwitchListTile(
                title: const Text("Masih aktif"),
                value: _isActive,
                activeThumbColor: Colors.indigo,
                onChanged: (bool value) {
                  setState(() {
                    _isActive = value;
                    if (value) {
                      _endDate = null;
                    }
                  });
                },
              ),

              // === End Date ===
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FormField<DateTime>(
                  validator: (_) {
                    if (_isActive) return null;
                    if (_endDate == null) {
                      return "Tanggal selesai tidak boleh kosong!";
                    }
                    if (_startDate != null && _endDate!.isBefore(_startDate!)) {
                      return "Tanggal selesai tidak boleh sebelum tanggal mulai!";
                    }
                    return null;
                  },
                  builder: (state) => InkWell(
                    onTap: _isActive
                        ? null
                        : () async {
                            await _pickDate(isStart: false);
                            state.didChange(_endDate); // hapus pesan error lama
                          },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: "Tanggal Selesai",
                        enabled: !_isActive,
                        suffixIcon: const Icon(Icons.calendar_today),
                        errorText: _isActive ? null : state.errorText,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Text(
                        _isActive
                            ? "Sekarang"
                            : (_endDate == null
                                  ? "Pilih tanggal selesai"
                                  : _formatDate(_endDate!)),
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
                  decoration: InputDecoration(
                    hintText: "Deskripsi Pengalaman",
                    labelText: "Deskripsi Pengalaman",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (String? value) {
                    setState(() {
                      _description = value!;
                    });
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Pengalaman berhasil ditambahkan!',
                              ),
                              content: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Posisi: ${_position.trim()}'),
                                    Text('Organisasi: ${_organization.trim()}'),
                                    Text('Tipe: $_type'),
                                    Text('Mulai: ${_formatDate(_startDate!)}'),
                                    Text(
                                      'Selesai: ${_isActive ? "Sekarang" : _formatDate(_endDate!)}',
                                    ),
                                    Text('Deskripsi: ${_description.trim()}'),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _formKey.currentState!.reset();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: const Text(
                      "Save",
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
