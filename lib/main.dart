import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:study_planner/pages/activity_page.dart';
import 'package:study_planner/pages/login_page.dart';
import 'package:study_planner/pages/main_page.dart';
import 'package:study_planner/providers/theme_provider.dart';

import 'firebase/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Erro ao inicializar o Firebase: $e');
  }

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'pt_br',
    supportedLocales: ['en', 'pt_br'],
  );

  runApp(LocalizedApp(delegate, ProviderScope(child: MainApp())));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = ref.watch(themeProvider);

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/login',
        routes: {
          '/login': (ctx) => const LoginPage(),
          '/main': (ctx) => const MainPage(),
          '/activity': (ctx) => const ActivityPage(),
        },
        theme: themeData,
      ),
    );
  }
}
