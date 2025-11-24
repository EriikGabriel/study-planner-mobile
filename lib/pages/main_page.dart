import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_planner/theme/app_theme.dart';

import 'activity_page.dart'; // importa sua ActivityPage

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Páginas correspondentes às abas
  final List<Widget> _pages = const [
    AgendaPage(),
    ActivityPage(),
    Placeholder(), // Notificações
    Placeholder(), // Configurações
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx).colorScheme;

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(ctx),
        ),
        title: Text(
          _selectedIndex == 0
              ? "Agenda"
              : _selectedIndex == 1
              ? "Atividades"
              : _selectedIndex == 2
              ? "Notificações"
              : "Configurações",
          style: GoogleFonts.poppins(
            color: theme.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.menu_rounded, color: Colors.black87),
          ),
        ],
      ),

      // barra inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.primary,
        unselectedItemColor: theme.secondaryText,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_rounded),
            label: 'Agenda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_rounded),
            label: 'Atividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            label: 'Notificações',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),

      // corpo alternável
      body: _pages[_selectedIndex],
    );
  }
}

// Agenda original virou uma subpágina separada
class AgendaPage extends StatelessWidget {
  const AgendaPage({super.key});

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navegação do mês
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: theme.secondaryText,
              ),
              Text(
                "Novembro",
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryText,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 20,
                color: theme.secondaryText,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dias da semana
          SizedBox(
            height: 80,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildDayCard("4", "Sáb", false),
                _buildDayCard("5", "Dom", true),
                _buildDayCard("6", "Seg", false),
                _buildDayCard("7", "Ter", false),
                _buildDayCard("8", "Qua", false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Em andamento",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: theme.primaryText,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              children: const [
                TaskCard(
                  title: "Laboratório de Redes",
                  subtitle: "Fábio Luciano Verdi",
                  time: "9:00 - 10:00",
                  color: Color(0xFFFFB84D),
                  avatars: [
                    "https://randomuser.me/api/portraits/men/32.jpg",
                    "https://randomuser.me/api/portraits/women/12.jpg",
                  ],
                ),
                TaskCard(
                  title: "Desenvolvimento Web",
                  subtitle: "Luciana Zaina",
                  time: "11:00 - 12:00",
                  color: Color(0xFF4CD7A5),
                  avatars: [
                    "https://randomuser.me/api/portraits/men/22.jpg",
                    "https://randomuser.me/api/portraits/women/47.jpg",
                  ],
                ),
                TaskCard(
                  title: "Desenvolvimento p/ Dispositivos Móveis",
                  subtitle: "José de Oliveira Guimarães",
                  time: "13:00 - 14:00",
                  color: Color(0xFFB894F6),
                  avatars: [
                    "https://randomuser.me/api/portraits/men/11.jpg",
                    "https://randomuser.me/api/portraits/women/33.jpg",
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(String day, String label, bool selected) {
    return Container(
      width: 60,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF2FD1C5) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? const Color(0xFF2FD1C5) : const Color(0xFFE0E0E0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: selected ? Colors.white70 : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

// TaskCard permanece igual
class TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final List<String> avatars;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.avatars,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: avatars.map((url) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
