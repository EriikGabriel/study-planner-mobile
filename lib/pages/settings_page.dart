import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_planner/pages/login_page.dart';
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
  String? _languagePref;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    final email = user?.email;
    if (email != null) {
      FirebaseDataService.getUserLanguageSetting(email).then((lang) {
        if (mounted) setState(() => _languagePref = lang);
      });
    } else {
      _languagePref = 'pt';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final currentTheme = ref.watch(themeProvider);
    final isDarkMode = currentTheme.brightness == Brightness.dark;
    final user = ref.watch(userProvider);

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
              _buildSectionTitle(context, colors, 'Aparência'),
              const SizedBox(height: 12),
              _buildThemeToggle(context, colors, isDarkMode),
              const SizedBox(height: 32),
              _buildSectionTitle(context, colors, 'Conta'),
              const SizedBox(height: 12),
              _buildAccountOptions(context, colors, user),
              const SizedBox(height: 16),
              _buildLanguageSetting(context, colors, user),
              const SizedBox(height: 32),
              _buildSectionTitle(context, colors, 'Sobre'),
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

  Widget _buildUserHeader(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.primary.withOpacity(0.18)),
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
                  user?.displayName ?? 'Usuário',
                  style: GoogleFonts.poppins(
                    color: colors.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'email@exemplo.com',
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
  ) {
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
          'Modo Escuro',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: colors.primaryText,
          ),
        ),
        subtitle: Text(
          isDarkMode ? 'Ativado' : 'Desativado',
          style: GoogleFonts.poppins(color: colors.secondaryText, fontSize: 13),
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
          activeColor: colors.primary,
        ),
      ),
    );
  }

  Widget _buildAccountOptions(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
    return Column(
      children: [
        _buildSettingItem(
          context,
          colors,
          icon: Icons.person_outline,
          title: 'Editar Perfil',
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento'))),
        ),
        const SizedBox(height: 8),
        _buildAttendanceSetting(context, colors, user),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.lock_outline,
          title: 'Alterar Senha',
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento'))),
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.notifications_outlined,
          title: 'Notificações',
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento'))),
        ),
      ],
    );
  }

  Widget _buildLanguageSetting(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
    final email = user?.email;
    final value = _languagePref ?? 'pt';
    final display =
        {
          'pt': 'Português',
          'en': 'English',
          'es': 'Español',
          'fr': 'Français',
          'zh': '中文',
        }[value] ??
        'Português';

    return Container(
      decoration: BoxDecoration(
        color: colors.secondaryBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(Icons.language, color: colors.primary),
        title: Text(
          'Idioma',
          style: GoogleFonts.poppins(
            color: colors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          display,
          style: GoogleFonts.poppins(color: colors.secondaryText, fontSize: 13),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () async {
          String current = value;
          final selected = await showDialog<String>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                'Escolha o idioma',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              content: StatefulBuilder(
                builder: (ctx2, setState2) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        value: 'pt',
                        groupValue: current,
                        title: const Text('Português'),
                        onChanged: (v) =>
                            setState2(() => current = v as String),
                      ),
                      RadioListTile(
                        value: 'en',
                        groupValue: current,
                        title: const Text('English'),
                        onChanged: (v) =>
                            setState2(() => current = v as String),
                      ),
                      RadioListTile(
                        value: 'es',
                        groupValue: current,
                        title: const Text('Español'),
                        onChanged: (v) =>
                            setState2(() => current = v as String),
                      ),
                      RadioListTile(
                        value: 'fr',
                        groupValue: current,
                        title: const Text('Français'),
                        onChanged: (v) =>
                            setState2(() => current = v as String),
                      ),
                      RadioListTile(
                        value: 'zh',
                        groupValue: current,
                        title: const Text('中文'),
                        onChanged: (v) =>
                            setState2(() => current = v as String),
                      ),
                    ],
                  );
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, null),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx, current),
                  child: const Text('Salvar'),
                ),
              ],
            ),
          );

          if (selected != null) {
            if (email == null) {
              if (context.mounted)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Usuário não autenticado')),
                );
              return;
            }

            final ok = await FirebaseDataService.setUserLanguageSetting(
              email,
              selected,
            );
            if (!ok && context.mounted)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Erro ao salvar idioma')),
              );
            if (mounted) setState(() => _languagePref = selected);
          }
        },
      ),
    );
  }

  Widget _buildAboutOptions(BuildContext context, ColorScheme colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingItem(
          context,
          colors,
          icon: Icons.info_outline,
          title: 'Sobre o App',
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  'Study Planner',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Versão 1.0.0', style: GoogleFonts.poppins()),
                    const SizedBox(height: 8),
                    Text(
                      'Um aplicativo para gerenciar suas matérias e atividades acadêmicas.',
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Feito por: Erik Gabriel e Thiago Kraide',
                      style: GoogleFonts.poppins(fontSize: 13),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Fechar'),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.privacy_tip_outlined,
          title: 'Política de Privacidade',
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento'))),
        ),
        const SizedBox(height: 8),
        _buildSettingItem(
          context,
          colors,
          icon: Icons.help_outline,
          title: 'Ajuda',
          onTap: () => ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento'))),
        ),
      ],
    );
  }

  Widget _buildAttendanceSetting(
    BuildContext context,
    ColorScheme colors,
    User? user,
  ) {
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
              'Presença automática',
              style: GoogleFonts.poppins(
                color: colors.primaryText,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              'Marcar presença automaticamente em novas disciplinas',
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
                if (!ok && context.mounted)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Erro ao salvar configuração'),
                    ),
                  );
                if (context.mounted) (context as Element).markNeedsBuild();
              },
              activeColor: colors.primary,
            ),
          ),
        );
      },
    );
  }

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
            color: colors.primaryText,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, ColorScheme colors) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Sair da Conta',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
              ),
              content: Text(
                'Tem certeza que deseja sair?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Sair'),
                ),
              ],
            ),
          );

          if (confirm == true && context.mounted) {
            await FirebaseAuth.instance.signOut();
            ref.read(userProvider.notifier).signOut();
            if (context.mounted)
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (r) => false,
              );
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
          'Sair da Conta',
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

Widget _buildSectionTitle(
  BuildContext context,
  ColorScheme theme,
  String title,
) {
  return Text(
    title,
    style: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: theme.secondaryText,
      letterSpacing: 0.5,
    ),
  );
}

Widget _buildThemeToggle(
  BuildContext context,
  ColorScheme theme,
  WidgetRef ref,
  bool isDarkMode,
) {
  return Container(
    decoration: BoxDecoration(
      color: theme.secondaryBackground,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          isDarkMode ? Icons.dark_mode : Icons.light_mode,
          color: theme.primary,
        ),
      ),
      title: Text(
        'Modo Escuro',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: theme.primaryText,
        ),
      ),
      subtitle: Text(
        isDarkMode ? 'Ativado' : 'Desativado',
        style: GoogleFonts.poppins(fontSize: 13, color: theme.secondaryText),
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          ref.read(themeProvider.notifier).toggleTheme();
        },
        activeThumbColor: theme.primary,
      ),
    ),
  );
}

Widget _buildAccountOptions(
  BuildContext context,
  ColorScheme theme,
  User? user,
) {
  return Column(
    children: [
      _buildSettingItem(
        context,
        theme,
        icon: Icons.person_outline,
        title: 'Editar Perfil',
        onTap: () {
          // TODO: Implementar edição de perfil
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
        },
      ),
      const SizedBox(height: 8),
      _buildAttendanceSetting(context, theme, user),
      const SizedBox(height: 8),
      _buildSettingItem(
        context,
        theme,
        icon: Icons.lock_outline,
        title: 'Alterar Senha',
        onTap: () {
          // TODO: Implementar alteração de senha
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
        },
      ),
      const SizedBox(height: 8),
      _buildSettingItem(
        context,
        theme,
        icon: Icons.notifications_outlined,
        title: 'Notificações',
        onTap: () {
          // TODO: Implementar configurações de notificações
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
        },
      ),
    ],
  );
}

Widget _buildLanguageSetting(
  BuildContext context,
  ColorScheme theme,
  User? user,
) {
  final email = user?.email;
  return FutureBuilder<String>(
    future: email != null
        ? FirebaseDataService.getUserLanguageSetting(email)
        : Future.value('pt'),
    builder: (context, snap) {
      final value = snap.data ?? 'pt';
      final display =
          {
            'pt': 'Português',
            'en': 'English',
            'es': 'Español',
            'fr': 'Français',
            'zh': '中文',
          }[value] ??
          'Português';

      return Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.language, color: theme.primary),
          ),
          title: Text(
            'Idioma',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.primaryText,
            ),
          ),
          subtitle: Text(
            display,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: theme.secondaryText,
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: theme.secondaryText,
          ),
          onTap: () async {
            // open dialog to pick language
            final selected = await showDialog<String>(
              context: context,
              builder: (ctx) {
                String current = value;
                return AlertDialog(
                  title: Text(
                    'Escolha o idioma',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  content: StatefulBuilder(
                    builder: (ctx2, setState2) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          RadioListTile<String>(
                            value: 'pt',
                            groupValue: current,
                            title: Text('Português'),
                            onChanged: (v) =>
                                setState2(() => current = v ?? 'pt'),
                          ),
                          RadioListTile<String>(
                            value: 'en',
                            groupValue: current,
                            title: Text('English'),
                            onChanged: (v) =>
                                setState2(() => current = v ?? 'en'),
                          ),
                          RadioListTile<String>(
                            value: 'es',
                            groupValue: current,
                            title: Text('Español'),
                            onChanged: (v) =>
                                setState2(() => current = v ?? 'es'),
                          ),
                          RadioListTile<String>(
                            value: 'fr',
                            groupValue: current,
                            title: Text('Français'),
                            onChanged: (v) =>
                                setState2(() => current = v ?? 'fr'),
                          ),
                          RadioListTile<String>(
                            value: 'zh',
                            groupValue: current,
                            title: Text('中文'),
                            onChanged: (v) =>
                                setState2(() => current = v ?? 'zh'),
                          ),
                        ],
                      );
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, null),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, current),
                      child: const Text('Salvar'),
                    ),
                  ],
                );
              },
            );

            if (selected != null && email != null) {
              final ok = await FirebaseDataService.setUserLanguageSetting(
                email,
                selected,
              );
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao salvar idioma')),
                );
              }
              // refresh view
              if (context.mounted) (context as Element).markNeedsBuild();
            }
          },
        ),
      );
    },
  );
}

Widget _buildAboutOptions(BuildContext context, ColorScheme theme) {
  return Column(
    children: [
      _buildSettingItem(
        context,
        theme,
        icon: Icons.info_outline,
        title: 'Sobre o App',
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Study Planner',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Text('Versão 1.0.0', style: GoogleFonts.poppins()),
                  Text(
                    'Um aplicativo para gerenciar suas matérias e atividades acadêmicas.',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Text(
                    'Feito por: Erik Gabriel e Thiago Kraide',
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Fechar'),
                ),
              ],
            ),
          );
        },
      ),
      const SizedBox(height: 8),
      _buildSettingItem(
        context,
        theme,
        icon: Icons.privacy_tip_outlined,
        title: 'Política de Privacidade',
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
        },
      ),
      const SizedBox(height: 8),
      _buildSettingItem(
        context,
        theme,
        icon: Icons.help_outline,
        title: 'Ajuda',
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Em desenvolvimento')));
        },
      ),
    ],
  );
}

Widget _buildAttendanceSetting(
  BuildContext context,
  ColorScheme theme,
  User? user,
) {
  final email = user?.email;
  return FutureBuilder<bool>(
    future: email != null
        ? FirebaseDataService.getUserAutoPresenceSetting(email)
        : Future.value(true),
    builder: (context, snap) {
      final value = snap.data ?? true;
      return Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.event_available_outlined, color: theme.primary),
          ),
          title: Text(
            'Presença automática',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: theme.primaryText,
            ),
          ),
          subtitle: Text(
            'Marcar presença automaticamente em novas disciplinas',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: theme.secondaryText,
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
                  const SnackBar(content: Text('Erro ao salvar configuração')),
                );
              }
              // Force rebuild to update futurebuilder by calling setState on ancestor
              if (context.mounted) (context as Element).markNeedsBuild();
            },
            activeThumbColor: theme.primary,
          ),
          onTap: () {},
        ),
      );
    },
  );
}

Widget _buildSettingItem(
  BuildContext context,
  ColorScheme theme, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Container(
    decoration: BoxDecoration(
      color: theme.secondaryBackground,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: theme.primary),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: theme.primaryText,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.secondaryText,
      ),
      onTap: onTap,
    ),
  );
}

Widget _buildLogoutButton(
  BuildContext context,
  ColorScheme theme,
  WidgetRef ref,
) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Sair da Conta',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Tem certeza que deseja sair?',
              style: GoogleFonts.poppins(),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Sair'),
              ),
            ],
          ),
        );

        if (confirm == true && context.mounted) {
          await FirebaseAuth.instance.signOut();
          ref.read(userProvider.notifier).signOut();

          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red[50],
        foregroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.logout, size: 20),
          const SizedBox(width: 8),
          Text(
            'Sair da Conta',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
