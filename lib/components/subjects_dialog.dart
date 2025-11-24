import 'package:flutter/material.dart';

class SubjectsDialog extends StatelessWidget {
  final List<Map<String, dynamic>> subjects;

  const SubjectsDialog({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Disciplinas encontradas"),
      content: SizedBox(
        width: 400,
        height: 500,
        child: ListView.builder(
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final s = subjects[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      s["atividade"],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("Turma: ${s["turma"]}"),
                    Text("Ano: ${s["ano"]}"),
                    Text("Período: ${s["periodo"]}"),
                    const SizedBox(height: 8),
                    const Text(
                      "Horários:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...List.generate((s["horarios"] as List).length, (i) {
                      final h = s["horarios"][i];
                      return Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "${h['dia']} - ${h['inicio']} às ${h['fim']} (${h['sala']})",
                        ),
                      );
                    }),
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
          child: const Text("Fechar"),
        ),
      ],
    );
  }
}
