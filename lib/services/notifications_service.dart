import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    if (kIsWeb) {
      _initialized = true;
      return;
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      // onDidReceiveNotificationResponse can be added if needed
    );

    _initialized = true;
  }

  static Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    if (kIsWeb) return;
    const android = AndroidNotificationDetails(
      'default',
      'Notificações',
      channelDescription: 'Canal padrão',
      importance: Importance.max,
    );
    const ios = DarwinNotificationDetails();
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: android, iOS: ios),
    );
  }

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    // Scheduling via zonedSchedule requires timezone setup (package:timezone).
    // For now we provide a simple wrapper that shows an immediate notification
    // (or could be extended to schedule with tz).
    if (kIsWeb) return;
    await showImmediateNotification(id: id, title: title, body: body);
  }

  /// Schedule notifications for upcoming class times for a list of subjects.
  /// For each horario, schedule a notification X minutes before the class start
  /// and write a record into Realtime Database under users/<safeEmail>/notifications.
  static Future<void> scheduleClassNotificationsForSubjects(
    List<Map<String, dynamic>> subjects,
    String email, {
    int minutesBefore = 10,
  }) async {
    if (kIsWeb) return;
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');

      for (final subject in subjects) {
        final subjectId = subject['id']?.toString() ?? '';
        final horarios = subject['horarios'] as List<dynamic>? ?? [];
        for (final h in horarios) {
          final dia = h['dia']?.toString() ?? '';
          final inicio =
              h['inicio']?.toString() ?? ''; // expecting HH:mm:ss or HH:mm
          if (dia.isEmpty || inicio.isEmpty) continue;

          // compute next occurrence of this weekday/time
          final next = _nextDateForDayAndTime(dia, inicio);
          if (next == null) continue;

          final scheduled = next.subtract(Duration(minutes: minutesBefore));
          if (scheduled.isBefore(DateTime.now())) continue;

          final id = scheduled.millisecondsSinceEpoch.remainder(1000000);
          final title = 'Aula próxima: ${subject['nome'] ?? 'Disciplina'}';
          final body =
              'Aula começa em $minutesBefore minutos. Presença automática ativada.';

          // schedule local notification
          try {
            await showImmediateNotification(id: id, title: title, body: body);
            // Note: using showImmediateNotification here to deliver immediate demo notifications;
            // ideally we'd schedule at `scheduled` with zonedSchedule, but that requires tz setup.
          } catch (e) {
            if (kDebugMode) print('Erro ao agendar notificação local: $e');
          }

          // write a notification record in DB with status scheduled
          final notif = {
            'type': 'class',
            'subjectId': subjectId,
            'title': title,
            'body': body,
            'scheduledAt': scheduled.toIso8601String(),
            'createdAt': DateTime.now().toIso8601String(),
            'status': 'scheduled',
          };

          await db
              .child('users')
              .child(safeEmail)
              .child('notifications')
              .push()
              .set(notif);
        }
      }
    } catch (e) {
      if (kDebugMode) print('Erro ao agendar notificações de sala: $e');
    }
  }

  static DateTime? _nextDateForDayAndTime(String dia, String timeStr) {
    try {
      final dayMap = {
        'SEGUNDA': 1,
        'TERCA': 2,
        'QUARTA': 3,
        'QUINTA': 4,
        'SEXTA': 5,
        'SABADO': 6,
        'DOMINGO': 7,
      };
      final diaNorm = dia.toUpperCase();
      final targetWeekday = dayMap[diaNorm] ?? int.tryParse(diaNorm) ?? 1;

      final parts = timeStr.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

      DateTime now = DateTime.now();
      DateTime candidate = DateTime(now.year, now.month, now.day, hour, minute);
      // advance day until weekday matches and candidate is in future
      int attempts = 0;
      while ((candidate.weekday != targetWeekday || candidate.isBefore(now)) &&
          attempts < 14) {
        candidate = candidate.add(Duration(days: 1));
        attempts++;
      }
      if (candidate.isBefore(now)) return null;
      return candidate;
    } catch (e) {
      return null;
    }
  }
}
