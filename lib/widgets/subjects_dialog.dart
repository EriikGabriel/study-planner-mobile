import 'package:flutter/material.dart';

/// Dialog widget to display fetched subjects from UFSCar API
class SubjectsDialog extends StatelessWidget {
  final List<Map<String, String>> subjects;

  const SubjectsDialog({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Matérias Carregadas ✓'),
      content: SizedBox(
        width: double.maxFinite,
        child: subjects.isEmpty
            ? const Center(child: Text('Nenhuma matéria encontrada.'))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: subjects.length,
                itemBuilder: (context, index) {
                  final subject = subjects[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            subject['nome'] ?? 'Sem nome',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Código: ${subject['codigo'] ?? 'N/A'}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (subject['creditos'] != null)
                            Text(
                              'Créditos: ${subject['creditos']}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
