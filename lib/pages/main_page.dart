import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:study_planner/providers/user_provider.dart';
import 'package:study_planner/services/firebase_data_service.dart';
import 'package:study_planner/services/notifications_service.dart';
import 'package:study_planner/theme/app_theme.dart';

import 'activity_page.dart'; // importa sua ActivityPage
import 'notifications_page.dart';
import 'rooms_page.dart';
import 'settings_page.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _subjects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    // initialize notifications service
    NotificationsService.init();
  }

  Future<void> _loadSubjects() async {
    setState(() => _isLoading = true);

    final user = ref.read(userProvider);
    final email = user?.email;

    if (email != null) {
      final subjects = await FirebaseDataService.fetchUserSubjects(email);
      setState(() {
        _subjects = subjects;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // Páginas correspondentes às abas
  List<Widget> get _pages => [
    AgendaPage(
      subjects: _subjects,
      onRefresh: _loadSubjects,
      isLoading: _isLoading,
    ),
    const ActivityPage(),
    RoomsPage(
      subjects: _subjects,
      onRefresh: _loadSubjects,
      isLoading: _isLoading,
    ),
    NotificationsPage(subjects: _subjects),
    const SettingsPage(), // Configurações
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx).colorScheme;
    final loc = AppLocalizations.of(ctx)!;
    final tabTitles = [
      loc.mainTabAgenda,
      loc.mainTabActivities,
      loc.mainTabRooms,
      loc.mainTabNotifications,
      loc.mainTabSettings,
    ];
    final navItems = [
      BottomNavigationBarItem(
        icon: const Icon(Icons.calendar_today_rounded),
        label: loc.mainTabAgenda,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.check_circle_outline_rounded),
        label: loc.mainTabActivities,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.forum_outlined),
        label: loc.mainTabRooms,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.notifications_none_rounded),
        label: loc.mainTabNotifications,
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.settings),
        label: loc.mainTabSettings,
      ),
    ];

    return Scaffold(
      backgroundColor: theme.primaryBackground,
      appBar: AppBar(
        backgroundColor: theme.primaryBackground,
        elevation: 0,
        title: Text(
          tabTitles[_selectedIndex],
          style: GoogleFonts.poppins(
            color: theme.primaryText,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),

      // barra inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: theme.primary,
        unselectedItemColor: theme.secondaryText,
        backgroundColor: theme.secondaryBackground,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        items: navItems,
      ),

      // corpo alternável
      body: _pages[_selectedIndex],
    );
  }
}

// Agenda original virou uma subpágina separada
class AgendaPage extends StatefulWidget {
  final List<Map<String, dynamic>> subjects;
  final VoidCallback onRefresh;
  final bool isLoading;

  const AgendaPage({
    super.key,
    required this.subjects,
    required this.onRefresh,
    required this.isLoading,
  });

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  String? _selectedDay; // null = mostrar todos os dias
  late DateTime _currentMonth;
  late DateTime _selectedWeekStart;

  @override
  void initState() {
    super.initState();
    // Inicializa com a segunda-feira da semana atual
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    final weekDay = now.weekday;
    _selectedWeekStart = now.subtract(Duration(days: weekDay - 1));
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
      // Atualiza a semana para a primeira segunda-feira do mês anterior
      final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final weekDay = firstDay.weekday;
      _selectedWeekStart = weekDay == 1
          ? firstDay
          : firstDay.add(Duration(days: 8 - weekDay));
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
      // Atualiza a semana para a primeira segunda-feira do mês seguinte
      final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
      final weekDay = firstDay.weekday;
      _selectedWeekStart = weekDay == 1
          ? firstDay
          : firstDay.add(Duration(days: 8 - weekDay));
    });
  }

  String _getMonthName(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final formatted = DateFormat.MMMM(
      locale.toLanguageTag(),
    ).format(_currentMonth);
    final sentenceCase = toBeginningOfSentenceCase(formatted);
    return sentenceCase;
  }

  bool _isCurrentWeek() {
    final now = DateTime.now();
    final weekDay = now.weekday;
    final currentMonday = now.subtract(Duration(days: weekDay - 1));

    // Compara apenas ano, mês e dia (ignora hora/minuto/segundo)
    return _selectedWeekStart.year == currentMonday.year &&
        _selectedWeekStart.month == currentMonday.month &&
        _selectedWeekStart.day == currentMonday.day;
  }

  List<Map<String, dynamic>> _getWeekDays(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final abbreviator = DateFormat('EEE', locale.toLanguageTag());
    const dayValues = [
      'SEGUNDA',
      'TERCA',
      'QUARTA',
      'QUINTA',
      'SEXTA',
      'SABADO',
      'DOMINGO',
    ];

    return List.generate(7, (index) {
      final day = _selectedWeekStart.add(Duration(days: index));
      final labelRaw = abbreviator.format(day);
      final sentenceCase = toBeginningOfSentenceCase(labelRaw);
      final label = sentenceCase;

      return {
        'day': day.day.toString(),
        'label': label,
        'value': dayValues[index],
        'date': day,
      };
    });
  }

  @override
  Widget build(BuildContext ctx) {
    final theme = Theme.of(ctx).colorScheme;
    final loc = AppLocalizations.of(ctx)!;
    final weekDays = _getWeekDays(ctx);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Navegação do mês
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: theme.secondaryText,
                ),
                onPressed: _previousMonth,
              ),
              Expanded(
                child: Text(
                  "${_getMonthName(ctx)} ${_currentMonth.year}",
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  textAlign: TextAlign.center,
                ),
              ),
              Wrap(
                spacing: 0,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: theme.secondaryText,
                    ),
                    onPressed: _nextMonth,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 24,
                      color: theme.secondaryText,
                    ),
                    onPressed: widget.onRefresh,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Dias da semana com navegação
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: theme.secondaryText),
                onPressed: () {
                  setState(() {
                    _selectedWeekStart = _selectedWeekStart.subtract(
                      const Duration(days: 7),
                    );
                    // Atualiza o mês exibido se necessário
                    _currentMonth = DateTime(
                      _selectedWeekStart.year,
                      _selectedWeekStart.month,
                      1,
                    );
                  });
                },
              ),
              Expanded(
                child: SizedBox(
                  height: 80,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _buildDayCard(
                        loc.agendaFilterAll,
                        '',
                        _selectedDay == null,
                        null,
                      ),
                      ...weekDays.map(
                        (day) => _buildDayCard(
                          day['day']!,
                          day['label']!,
                          _selectedDay == day['value'],
                          day['value']!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: theme.secondaryText),
                onPressed: () {
                  setState(() {
                    _selectedWeekStart = _selectedWeekStart.add(
                      const Duration(days: 7),
                    );
                    // Atualiza o mês exibido se necessário
                    _currentMonth = DateTime(
                      _selectedWeekStart.year,
                      _selectedWeekStart.month,
                      1,
                    );
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedDay == null
                      ? loc.agendaDefaultSectionTitle
                      : _getDayDisplayName(
                          _selectedDay!,
                          loc,
                        ).replaceAll("📅 ", ''),
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryText,
                  ),
                ),
              ),
              if (_selectedDay != null)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedDay = null;
                    });
                  },
                  child: Text(loc.agendaClearFilter),
                ),
              if (!_isCurrentWeek())
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      final now = DateTime.now();
                      final weekDay = now.weekday;
                      _selectedWeekStart = now.subtract(
                        Duration(days: weekDay - 1),
                      );
                      _currentMonth = DateTime(now.year, now.month, 1);
                    });
                  },
                  icon: const Icon(Icons.today, size: 16),
                  label: Text(loc.agendaGoToToday),
                ),
            ],
          ),

          const SizedBox(height: 12),

          Expanded(
            child: widget.isLoading
                ? const Center(child: CircularProgressIndicator())
                : widget.subjects.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.agendaEmptyTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: widget.onRefresh,
                          icon: const Icon(Icons.refresh),
                          label: Text(loc.agendaEmptyAction),
                        ),
                      ],
                    ),
                  )
                : _buildGroupedSubjectsList(theme, loc),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupedSubjectsList(ColorScheme theme, AppLocalizations loc) {
    // Agrupa matérias por dia da semana
    final Map<String, List<Map<String, dynamic>>> groupedByDay = {};

    for (var subject in widget.subjects) {
      final horarios = subject['horarios'] as List<dynamic>? ?? [];
      if (horarios.isNotEmpty) {
        final dia = horarios[0]['dia']?.toString() ?? loc.agendaNoDayDefined;
        if (!groupedByDay.containsKey(dia)) {
          groupedByDay[dia] = [];
        }
        groupedByDay[dia]!.add(subject);
      }
    }

    // Filtra por dia selecionado (se houver)
    Map<String, List<Map<String, dynamic>>> filteredByDay = groupedByDay;
    if (_selectedDay != null) {
      filteredByDay = {
        for (var entry in groupedByDay.entries)
          if (_normalizeDayName(entry.key) == _selectedDay)
            entry.key: entry.value,
      };
    }

    // Ordena as chaves (dias) na ordem correta
    final sortedDays = filteredByDay.keys.toList()
      ..sort((a, b) => _getDayOrder(a).compareTo(_getDayOrder(b)));

    // Se não há matérias no dia selecionado
    if (sortedDays.isEmpty && _selectedDay != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              loc.agendaEmptyDayTitle,
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  _selectedDay = null;
                });
              },
              child: Text(loc.agendaEmptyDayAction),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: sortedDays.length,
      itemBuilder: (context, dayIndex) {
        final dia = sortedDays[dayIndex];
        final materiasNoDia = filteredByDay[dia]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do dia
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _getDayDisplayName(dia, loc),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: theme.primaryText,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    loc.agendaSubjectsCount(materiasNoDia.length),
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: theme.secondaryText,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de matérias do dia
            ...materiasNoDia.asMap().entries.map((entry) {
              final index = entry.key;
              final subject = entry.value;
              final horarios = subject['horarios'] as List<dynamic>? ?? [];

              String timeDisplay = loc.agendaNoSchedule;
              if (horarios.isNotEmpty) {
                final horario = horarios[0];
                final inicio =
                    horario['inicio']?.toString().substring(0, 5) ?? '';
                final fim = horario['fim']?.toString().substring(0, 5) ?? '';
                final sala = horario['sala'] ?? '';
                timeDisplay =
                    "$inicio - $fim${sala.isNotEmpty ? ' • $sala' : ''}";
              }

              final turma = subject['turma']?.toString() ?? '-';
              final ano = subject['ano']?.toString() ?? '-';
              final periodo = subject['periodo']?.toString() ?? '-';

              return TaskCard(
                title: subject['nome']?.toString() ?? loc.agendaNoName,
                subtitle: loc.agendaClassLabel(turma, ano, periodo),
                time: timeDisplay,
                color: _getColorForIndex(dayIndex * 10 + index),
                avatars: const [],
                subjectId: subject['id']?.toString(),
              );
            }),
          ],
        );
      },
    );
  }

  int _getDayOrder(String dia) {
    final diaUpper = dia.toUpperCase();
    switch (diaUpper) {
      case 'SEGUNDA':
      case 'SEGUNDA-FEIRA':
        return 1;
      case 'TERCA':
      case 'TERÇA':
      case 'TERÇA-FEIRA':
      case 'TERCA-FEIRA':
        return 2;
      case 'QUARTA':
      case 'QUARTA-FEIRA':
        return 3;
      case 'QUINTA':
      case 'QUINTA-FEIRA':
        return 4;
      case 'SEXTA':
      case 'SEXTA-FEIRA':
        return 5;
      case 'SABADO':
      case 'SÁBADO':
        return 6;
      case 'DOMINGO':
        return 7;
      default:
        return 999;
    }
  }

  String _getDayDisplayName(String dia, AppLocalizations loc) {
    final diaUpper = dia.toUpperCase();
    switch (diaUpper) {
      case 'SEGUNDA':
      case 'SEGUNDA-FEIRA':
        return '📅 ${loc.agendaDayMonday}';
      case 'TERCA':
      case 'TERÇA':
      case 'TERÇA-FEIRA':
      case 'TERCA-FEIRA':
        return '📅 ${loc.agendaDayTuesday}';
      case 'QUARTA':
      case 'QUARTA-FEIRA':
        return '📅 ${loc.agendaDayWednesday}';
      case 'QUINTA':
      case 'QUINTA-FEIRA':
        return '📅 ${loc.agendaDayThursday}';
      case 'SEXTA':
      case 'SEXTA-FEIRA':
        return '📅 ${loc.agendaDayFriday}';
      case 'SABADO':
      case 'SÁBADO':
        return '📅 ${loc.agendaDaySaturday}';
      case 'DOMINGO':
        return '📅 ${loc.agendaDaySunday}';
      default:
        return '📅 $dia';
    }
  }

  String _normalizeDayName(String dia) {
    final diaUpper = dia.toUpperCase();
    switch (diaUpper) {
      case 'SEGUNDA':
      case 'SEGUNDA-FEIRA':
        return 'SEGUNDA';
      case 'TERCA':
      case 'TERÇA':
      case 'TERÇA-FEIRA':
      case 'TERCA-FEIRA':
        return 'TERCA';
      case 'QUARTA':
      case 'QUARTA-FEIRA':
        return 'QUARTA';
      case 'QUINTA':
      case 'QUINTA-FEIRA':
        return 'QUINTA';
      case 'SEXTA':
      case 'SEXTA-FEIRA':
        return 'SEXTA';
      case 'SABADO':
      case 'SÁBADO':
        return 'SABADO';
      case 'DOMINGO':
        return 'DOMINGO';
      default:
        return diaUpper;
    }
  }

  Color _getColorForIndex(int index) {
    final colors = [
      const Color(0xFFFFB84D), // Orange
      const Color(0xFF4CD7A5), // Green
      const Color(0xFFB894F6), // Purple
      const Color(0xFF5DADE2), // Blue
      const Color(0xFFFF6B6B), // Red
      const Color(0xFFFECA57), // Yellow
    ];
    return colors[index % colors.length];
  }

  Widget _buildDayCard(
    String day,
    String label,
    bool selected,
    String? dayValue,
  ) {
    final bool isTodosButton = dayValue == null;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = dayValue;
        });
      },
      child: Container(
        width: isTodosButton ? 70 : 60,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF2FD1C5)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? const Color(0xFF2FD1C5)
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: GoogleFonts.poppins(
                fontSize: isTodosButton ? 14 : 20,
                fontWeight: FontWeight.bold,
                color: selected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            if (!isTodosButton) ...[
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: selected
                      ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.9)
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// TaskCard permanece igual
class TaskCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String time;
  final Color color;
  final List<String> avatars;
  final String? subjectId;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.color,
    required this.avatars,
    this.subjectId,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  int _attended = 0;
  int _missed = 0;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  Future<void> _loadAttendance() async {
    if (widget.subjectId == null) return;
    setState(() => _loading = true);
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) {
      setState(() => _loading = false);
      return;
    }
    final data = await FirebaseDataService.fetchAttendance(
      email: email,
      subjectId: widget.subjectId!,
    );
    if (data == null) {
      final auto = await FirebaseDataService.getUserAutoPresenceSetting(email);
      if (auto) {
        // create default attendance starting from zero (user preference)
        _attended = 0;
        _missed = 0;
        await FirebaseDataService.saveAttendance(
          email: email,
          subjectId: widget.subjectId!,
          attendance: {
            'attended': _attended,
            'missed': _missed,
            'updatedAt': DateTime.now().toIso8601String(),
          },
        );
      }
    } else {
      _attended = (data['attended'] is int)
          ? data['attended']
          : int.tryParse(data['attended']?.toString() ?? '') ?? 0;
      _missed = (data['missed'] is int)
          ? data['missed']
          : int.tryParse(data['missed']?.toString() ?? '') ?? 0;
    }
    if (mounted) setState(() => _loading = false);
  }

  double get _percentage {
    // _attended represents total classes held so far; _missed is absences.
    // Presence percentage = (held - missed) / held
    final held = _attended;
    final missed = _missed;
    if (held <= 0) return 0.0;
    final present = (held - missed).clamp(0, held);
    return present / held;
  }

  Future<void> _changeAttendance({
    int attendedDelta = 0,
    int missedDelta = 0,
  }) async {
    if (widget.subjectId == null) return;
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    setState(() => _loading = true);
    final ok = await FirebaseDataService.incrementAttendance(
      email: email,
      subjectId: widget.subjectId!,
      attendedDelta: attendedDelta,
      missedDelta: missedDelta,
    );
    if (ok) {
      _attended = (_attended + attendedDelta).clamp(0, 99999);
      _missed = (_missed + missedDelta).clamp(0, 99999);
    }
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _editCounts() async {
    final attendedCtrl = TextEditingController(text: _attended.toString());
    final missedCtrl = TextEditingController(text: _missed.toString());
    final loc = AppLocalizations.of(context)!;
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.attendanceDialogTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: attendedCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.attendanceDialogAttendedLabel,
              ),
            ),
            TextField(
              controller: missedCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: loc.attendanceDialogMissedLabel,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.attendanceDialogCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.attendanceDialogSave),
          ),
        ],
      ),
    );
    if (res != true) return;
    final newAtt = int.tryParse(attendedCtrl.text) ?? 0;
    final newMiss = int.tryParse(missedCtrl.text) ?? 0;
    if (widget.subjectId == null) return;
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;
    setState(() => _loading = true);
    final ok = await FirebaseDataService.saveAttendance(
      email: email,
      subjectId: widget.subjectId!,
      attendance: {
        'attended': newAtt,
        'missed': newMiss,
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
    if (ok) {
      _attended = newAtt;
      _missed = newMiss;
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final pctValue = (_percentage * 100).round();
    final presenceLabel = loc.attendancePresence(pctValue);
    final attendedLabel = loc.attendanceAttendedLabel(_attended);
    final missedLabel = loc.attendanceMissedLabel(_missed);
    // number of additional classes needed to reach 75% is computed where needed
    final cs = Theme.of(context).colorScheme;
    // Force white titles on subject cards for consistent contrast
    final titleColor = Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            // Header (always visible)
            Material(
              color: widget.color,
              child: InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              // show the full discipline title (allow wrapping)
                              style: GoogleFonts.poppins(
                                color: titleColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                color: titleColor.withOpacity(0.95),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Force time on the first line and location (sala) on a second line
                          Builder(
                            builder: (ctx) {
                              final parts = widget.time.split('•');
                              final timeOnly = parts.isNotEmpty
                                  ? parts[0].trim()
                                  : widget.time;
                              final location = parts.length > 1
                                  ? parts.sublist(1).join('•').trim()
                                  : '';
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    timeOnly,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.poppins(
                                      color: titleColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (location.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      location,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                      style: GoogleFonts.poppins(
                                        color: titleColor.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          AnimatedRotation(
                            turns: _expanded ? 0.5 : 0.0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: titleColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Expandable content
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: ConstrainedBox(
                constraints: _expanded
                    ? const BoxConstraints()
                    : const BoxConstraints(maxHeight: 0),
                child: Container(
                  width: double.infinity,
                  color: cs.surface,
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _loading
                          ? const Center(child: CircularProgressIndicator())
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final narrow = constraints.maxWidth < 420;
                                if (!narrow) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              presenceLabel,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700,
                                                color: cs.onSurface,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              attendedLabel,
                                              style: GoogleFonts.poppins(
                                                color: cs.onSurface.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              missedLabel,
                                              style: GoogleFonts.poppins(
                                                color: cs.onSurface.withOpacity(
                                                  0.9,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () => _changeAttendance(
                                              attendedDelta: 1,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: cs.primary,
                                              foregroundColor: cs.onPrimary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                              elevation: 2,
                                            ),
                                            child: Text(
                                              loc.attendanceAddClass,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          ElevatedButton(
                                            onPressed: () => _changeAttendance(
                                              missedDelta: 1,
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: cs.error,
                                              foregroundColor: cs.onError,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 10,
                                                  ),
                                              elevation: 2,
                                            ),
                                            child: Text(
                                              loc.attendanceMarkAbsence,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }

                                // stacked layout for narrow/mobile screens
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      presenceLabel,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: cs.onSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      attendedLabel,
                                      style: GoogleFonts.poppins(
                                        color: cs.onSurface.withOpacity(0.9),
                                      ),
                                    ),
                                    Text(
                                      missedLabel,
                                      style: GoogleFonts.poppins(
                                        color: cs.onSurface.withOpacity(0.9),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _changeAttendance(attendedDelta: 1),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: cs.primary,
                                        foregroundColor: cs.onPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        elevation: 2,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            loc.attendanceAddClass,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _changeAttendance(missedDelta: 1),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: cs.error,
                                        foregroundColor: cs.onError,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 12,
                                        ),
                                        elevation: 2,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Center(
                                          child: Text(
                                            loc.attendanceMarkAbsence,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: _editCounts,
                            child: Text(
                              loc.attendanceEditCounts,
                              style: GoogleFonts.poppins(color: cs.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
