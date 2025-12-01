import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_planner/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  final List<Map<String, dynamic>> subjects;
  const NotificationsPage({super.key, required this.subjects});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _loading = true);
    try {
      // If user is logged in, load from DB. Here we try to infer email from subjects payload if possible.
      // This page expects that notifications are written under users/<safeEmail>/notifications
      // For demo we will fetch from a few likely paths if available in subjects.
      // Better approach: pass user email or use a provider; due to scope we attempt a best-effort.

      final db = FirebaseDatabase.instance.ref();
      final email = FirebaseAuth.instance.currentUser?.email;
      DatabaseEvent snapshotEvent;
      if (email != null) {
        final safeEmail = email.replaceAll('.', '_');
        snapshotEvent = await db
            .child('users')
            .child(safeEmail)
            .child('notifications')
            .once();
      } else {
        snapshotEvent = await db.child('notifications').once();
      }
      final snapshot = snapshotEvent.snapshot;
      final List<Map<String, dynamic>> items = [];
      if (snapshot.exists && snapshot.value != null) {
        final Map data = snapshot.value as Map<dynamic, dynamic>;
        data.forEach((k, v) {
          if (v is Map) {
            final item = Map<String, dynamic>.from(v);
            item['id'] = k;
            items.add(item);
          }
        });
      }

      setState(() {
        _notifications = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryBackground,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _notifications.isEmpty
            ? Center(
                child: Text(
                  'Nenhuma notificação',
                  style: GoogleFonts.poppins(
                    color: Theme.of(context).colorScheme.secondaryText,
                  ),
                ),
              )
            : ListView.separated(
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, idx) {
                  final n = _notifications[idx];
                  final title = n['title']?.toString() ?? 'Notificação';
                  final body = n['body']?.toString() ?? '';
                  final when =
                      n['scheduledAt']?.toString() ??
                      n['createdAt']?.toString() ??
                      '';
                  final status = n['status']?.toString() ?? 'scheduled';
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
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
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                body,
                                style: GoogleFonts.poppins(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                when,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondaryText,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(label: Text(status)),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
