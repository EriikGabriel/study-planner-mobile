import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:study_planner/pages/login_page.dart';
import 'package:study_planner/providers/locale_provider.dart';
import 'package:study_planner/providers/theme_provider.dart';
import 'package:study_planner/providers/user_provider.dart';
import 'package:study_planner/services/firebase_data_service.dart';
import 'package:study_planner/theme/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  Widget _buildSettingItem(
    BuildContext context,
    ColorScheme colors, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: colors.primary),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.primaryText,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildAccountOptions(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      children: [
        _buildSettingItem(
          context,
          colors,
          icon: Icons.person_outline,
          title: loc.settingsEditProfile,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.settingsComingSoon))),
        ),
        const SizedBox(height: 8),
        _buildAttendanceSetting(context, colors, user),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.lock_outline,
          title: loc.settingsChangePassword,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.settingsComingSoon))),
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.notifications_outlined,
          title: loc.settingsNotifications,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.settingsComingSoon))),
        ),
      ],
    );
  }

  Widget _buildAttendanceSetting(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
    final loc = AppLocalizations.of(context)!;
    final email = user?.email;
    return FutureBuilder<bool>(
      future: email != null
          ? FirebaseDataService.getUserAutoPresenceSetting(email)
          : Future.value(true),
      builder: (context, snap) {
        final value = snap.data ?? true;
        return Container(
          decoration: BoxDecoration(
            color: colors.secondaryBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Icon(
              Icons.event_available_outlined,
              color: colors.primary,
            ),
            title: Text(
              loc.settingsAutoPresenceTitle,
              style: GoogleFonts.poppins(
                color: colors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              loc.settingsAutoPresenceSubtitle,
              style: GoogleFonts.poppins(
                color: colors.secondaryText,
                fontSize: 13,
              ),
            ),
            trailing: Switch(
              value: value,
              onChanged: (v) async {
                if (email == null) return;
                final ok = await FirebaseDataService.setUserAutoPresenceSetting(
                  email,
                  v,
                );
                if (!ok && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(loc.settingsAutoPresenceSaveError)),
                  );
                }
                if (context.mounted) (context as Element).markNeedsBuild();
              },
              activeThumbColor: colors.primary,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final user = this.ref.watch(userProvider);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.primaryBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUserHeader(context, colors, user),
              const SizedBox(height: 32),
              _buildSectionTitle(
                context,
                colors,
                loc.settingsAppearanceSection,
              ),
              const SizedBox(height: 12),
              _buildThemeToggle(
                context,
                colors,
                (Theme.of(context).brightness == Brightness.dark),
                this.ref,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle(context, colors, loc.settingsAccountSection),
              const SizedBox(height: 12),
              _buildAccountOptions(context, colors, user),
              const SizedBox(height: 16),
              _buildLanguageSetting(context, colors, user, this.ref),
              const SizedBox(height: 32),
              _buildSectionTitle(context, colors, loc.settingsAboutSection),
              const SizedBox(height: 12),
              _buildAboutOptions(context, colors),
              const SizedBox(height: 32),
              _buildLogoutButton(context, colors),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSetting(
    BuildContext context,
    ColorScheme colors,
    User? user,
    WidgetRef ref,
  ) {
    final currentLang = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);
    final loc = AppLocalizations.of(context)!;

    final languages = {
      'pt': loc.languagePortuguese,
      'en': loc.languageEnglish,
      'es': loc.languageSpanish,
      'fr': loc.languageFrench,
      'zh': loc.languageChinese,
    };

    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.language, color: colors.primary),
        title: Text(
          loc.settingsLanguageTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.primaryText,
          ),
        ),
        subtitle: Text(
          languages[currentLang] ?? 'Português',
          style: GoogleFonts.poppins(color: colors.secondaryText, fontSize: 13),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: colors.secondaryText,
        ),
        onTap: () async {
          final selected = await showDialog<String>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                loc.settingsLanguageDialogTitle,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: languages.entries.map((entry) {
                  final isSelected = entry.key == currentLang;
                  return ListTile(
                    title: Text(
                      entry.value,
                      style: GoogleFonts.poppins(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: colors.primary)
                        : null,
                    onTap: () => Navigator.pop(context, entry.key),
                  );
                }).toList(),
              ),
            ),
          );

          if (selected != null && selected != currentLang && context.mounted) {
            await localeNotifier.changeLanguage(selected, user?.email);

            if (!context.mounted) return;
          }
        },
      ),
    );
  }

  Widget _buildUserHeader(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primary.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: colors.primary,
            child: Text(
              user?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? loc.username,
                  style: GoogleFonts.poppins(
                    color: colors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'user@example.com',
                  style: GoogleFonts.poppins(
                    color: colors.secondaryText,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    ColorScheme colors,
    String title,
  ) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        color: colors.secondaryText,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildThemeToggle(
    BuildContext context,
    ColorScheme colors,
    bool isDarkMode,
    WidgetRef ref,
  ) {
    final loc = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: colors.primary,
        ),
        title: Text(
          loc.settingsThemeTitle,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.primaryText,
          ),
        ),
        subtitle: Text(
          isDarkMode ? loc.settingsThemeEnabled : loc.settingsThemeDisabled,
          style: GoogleFonts.poppins(color: colors.secondaryText, fontSize: 13),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
          activeThumbColor: colors.primary,
        ),
      ),
    );
  }

  Widget _buildAboutOptions(BuildContext context, ColorScheme colors) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingItem(
          context,
          colors,
          icon: Icons.info_outline,
          title: loc.settingsAboutApp,
          onTap: () async {
            const version = '1.0.0';
            if (!context.mounted) return;
            showDialog(
              context: context,
              builder: (ctx) {
                return AlertDialog(
                  title: Text(
                    loc.settingsAboutApp,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aplicativo de planejamento de estudos para organizar matérias, horários e presença.',
                        style: GoogleFonts.poppins(),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Versão: $version',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Desenvolvido por Erik Gabriel e Thiago Kraide',
                        style: GoogleFonts.poppins(),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Fechar'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.privacy_tip_outlined,
          title: loc.settingsPrivacyPolicy,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.settingsComingSoon))),
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.description_outlined,
          title: loc.settingsTermsOfUse,
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(loc.settingsComingSoon))),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colors) {
    final loc = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                loc.settingsLogoutTitle,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              content: Text(
                loc.settingsLogoutMessage,
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(loc.settingsLogoutCancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(loc.settingsLogoutConfirm),
                ),
              ],
            ),
          );

          if (confirm == true && context.mounted) {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (r) => false,
              );
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          loc.settingsLogoutButton,
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
