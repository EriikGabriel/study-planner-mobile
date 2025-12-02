import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:study_planner/pages/login_page.dart';

/// Wrapper para exibir LoginPage no Widgetbook sem erros de inicialização
class LoginPagePreview extends StatelessWidget {
  const LoginPagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Scaffold(
          body: LoginPage(),
        ),
      ),
    );
  }
}
