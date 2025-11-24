import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:study_planner/pages/login_page.dart';

/// Wrapper para exibir LoginPage no Widgetbook sem erros de inicialização
class LoginPagePreview extends StatelessWidget {
  const LoginPagePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProviderScope(
          child: Localization(
            child: Builder(builder: (context) => const LoginPage()),
          ),
        ),
      ),
    );
  }
}

/// Wrapper simples para LocalizationProvider
class Localization extends StatelessWidget {
  final Widget child;

  const Localization({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: child,
    );
  }
}
