import 'package:material_ui/material_ui.dart';
import 'package:myportofolio_mobile/models/experience.dart';

class ExperienceDetailScreen extends StatefulWidget {
  const ExperienceDetailScreen({required this.experience, super.key});

  final Experience experience;

  @override
  State<ExperienceDetailScreen> createState() => _ExperienceDetailScreenState();
}

class _ExperienceDetailScreenState extends State<ExperienceDetailScreen> {
  late Experience _experience;
  
  @override
  void initState() {
    super.initState();
    _experience = widget.experience;
  }

  @override
  Widget build(BuildContext context) {
    final endLabel = _experience.isOngoing ? 'Sekarang' : _experience.endedAt!;

    return Scaffold(
      appBar: AppBar(
        title: Text(_experience.title),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_experience.thumbnail.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _experience.thumbnail,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Text(
              _experience.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Posisi: ${_experience.position}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('Periode: ${_experience.startedAt} - $endLabel'),
            const SizedBox(height: 8),
            Text(
              'Status: ${_experience.isOngoing ? 'Masih aktif' : 'Selesai'}',
            ),
            const SizedBox(height: 12),
            const Text(
              'Deskripsi',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(_experience.description),
            if (_experience.thumbnail.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Thumbnail URL: ${_experience.thumbnail}'),
            ],
            const SizedBox(height: 12),
            if (_experience.id != null) ...[
              const SizedBox(height: 12),
              Text(
                'ID: ${_experience.id}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
