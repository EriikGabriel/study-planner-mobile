// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_planner/theme/app_theme.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Tabs roláveis horizontalmente
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  _buildTab("A Fazer", 0),
                  _buildTab("Concluído", 1),
                  _buildTab("Atrasado", 2),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Filtro e botão "Nova Atividade"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_list_rounded,
                    color: theme.secondaryText,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.add_circle_outline_rounded,
                    color: Color(0xFF2FD1C5),
                  ),
                  label: Text(
                    "Nova atividade",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF2FD1C5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                children: const [
                  SectionHeader(date: "Hoje, segunda-feira 17"),
                  ActivityCard(
                    title: "Matemática",
                    description:
                        "Crie uma história emocional que descreva melhor que palavras.",
                    time: "10:30 - 11:30",
                    color: Color(0xFFFFB5B5),
                    icon: Icons.calculate_rounded,
                  ),
                  SectionHeader(date: "Quinta-feira 18"),
                  ActivityCard(
                    title: "Geometria",
                    description:
                        "Crie uma história emocional que descreva melhor que palavras.",
                    time: "11:30 - 12:30",
                    color: Color(0xFFA8E6CF),
                    icon: Icons.square_foot_rounded,
                  ),
                  ActivityCard(
                    title: "História",
                    description:
                        "Crie uma história emocional que descreva melhor que palavras.",
                    time: "13:00 - 14:00",
                    color: Color(0xFFD1C4E9),
                    icon: Icons.menu_book_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final bool isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2FD1C5) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF2FD1C5) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// =============================
// 🔹 WIDGETS AUXILIARES
// =============================

class SectionHeader extends StatelessWidget {
  final String date;

  const SectionHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        "Prazo: $date",
        style: GoogleFonts.poppins(
          color: theme.secondaryText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Color color;
  final IconData icon;

  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    color: theme.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: theme.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFFFF8A80),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.edit_document, color: Color(0xFF2FD1C5)),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
