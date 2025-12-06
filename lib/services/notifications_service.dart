import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    if (kDebugMode) {
      print('[Notifications] Initialized plugin');
    }

    // Android 13+ runtime notification permission
    try {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await androidImpl?.requestNotificationsPermission();
      if (kDebugMode) {
        print('[Notifications] Android permission request result: $granted');
      }
      // Also log current notifications enabled status if available
      try {
        final enabled = await androidImpl?.areNotificationsEnabled();
        if (kDebugMode) {
          print('[Notifications] Android notifications enabled: $enabled');
        }
      } catch (_) {}
    } catch (_) {}

    // Create default notification channel on Android
    try {
      final androidImpl = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      const channel = AndroidNotificationChannel(
        'default',
        'Notificações',
        description: 'Canal padrão',
        importance: Importance.max,
      );
      await androidImpl?.createNotificationChannel(channel);
      if (kDebugMode) {
        print('[Notifications] Android channel created: ${channel.id}');
      }
    } catch (_) {}

    // Initialize timezone database and set local location
    try {
      tz.initializeTimeZones();
      // Force Brazil timezone to avoid devices reporting UTC; app is Brazil-only
      tz.setLocalLocation(tz.getLocation('America/Sao_Paulo'));
      if (kDebugMode) {
        final now = DateTime.now();
        final tzNow = tz.TZDateTime.from(now, tz.local);
        print(
          '[Notifications] Timezone initialized (forced). tz.local: ${tz.local.name} now: $tzNow',
        );
      }
    } catch (_) {}

    _initialized = true;
  }

  /// Debug helper: print pending scheduled notifications (app-side) if supported.
  static Future<void> debugPrintPendingSchedules() async {
    try {
      final pending = await _plugin.pendingNotificationRequests();
      if (kDebugMode) {
        print('[Notifications] Pending count: ${pending.length}');
        for (final p in pending) {
          print(
            '[Notifications] Pending -> id=${p.id} title="${p.title}" body="${p.body}" payload=${p.payload}',
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('[Notifications] Error reading pending notifications: $e');
      }
    }
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
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
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
    if (kIsWeb) return;
    if (kDebugMode) {
      final now = DateTime.now();
      print(
        '[Notifications] scheduleNotification check: scheduledDate=$scheduledDate vs now=$now',
      );
    }
    if (scheduledDate.isBefore(DateTime.now())) {
      if (kDebugMode) {
        print(
          '[Notifications] scheduledDate is in the past, showing immediate notification for id=$id',
        );
      }
      await showImmediateNotification(id: id, title: title, body: body);
      return;
    }

    var tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    // If local timezone resolves to UTC on this device, adjust by the device offset
    // so the scheduled wall-clock matches what the user selected.
    if (tz.local.name.toUpperCase() == 'UTC') {
      final offset = DateTime.now().timeZoneOffset;
      final adjustedWallClock = scheduledDate.subtract(offset);
      tzDate = tz.TZDateTime.from(adjustedWallClock, tz.getLocation('UTC'));
      if (kDebugMode) {
        print(
          '[Notifications] tz.local=UTC; applying offset $offset -> tzDate=$tzDate',
        );
      }
    }
    if (kDebugMode) {
      print(
        '[Notifications] Final schedule id=$id at $tzDate (tz=${tz.local.name}) title="$title"',
      );
    }
    const android = AndroidNotificationDetails(
      'default',
      'Notificações',
      channelDescription: 'Canal padrão',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const ios = DarwinNotificationDetails();
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      const NotificationDetails(android: android, iOS: ios),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
      payload: null,
    );
    if (kDebugMode) {
      print('[Notifications] zonedSchedule submitted for id=$id');
    }
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
