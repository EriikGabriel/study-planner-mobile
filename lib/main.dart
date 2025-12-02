import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/components/protected_route.dart';
import 'package:study_planner/pages/activity_page.dart';
import 'package:study_planner/pages/login_page.dart';
import 'package:study_planner/pages/main_page.dart';
import 'package:study_planner/providers/locale_provider.dart';
import 'package:study_planner/providers/theme_provider.dart';
import 'package:study_planner/providers/user_provider.dart';

import 'firebase/firebase_options.dart';

final GlobalKey<_MainAppState> mainAppKey = GlobalKey<_MainAppState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Erro ao inicializar o Firebase: $e');
  }

  runApp(ProviderScope(child: MainApp(key: mainAppKey)));
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  Locale _locale = const Locale('pt');

  void forceRebuild() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Garante que o idioma inicial seja aplicado após o primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyLocale(ref.read(localeProvider));
      _ensureLocaleInitialized(ref.read(userProvider));
    });
  }

  String? _lastInitializedEmail;
  bool _initializedAnonymous = false;

  void _ensureLocaleInitialized(User? user) {
    final email = user?.email;
    final shouldInitialize = email == null
        ? !_initializedAnonymous
        : _lastInitializedEmail != email;

    if (!shouldInitialize) {
      return;
    }

    if (email == null) {
      _initializedAnonymous = true;
      _lastInitializedEmail = null;
    } else {
      _lastInitializedEmail = email;
      _initializedAnonymous = false;
    }

    Future.microtask(() {
      ref.read(localeProvider.notifier).initialize(email).then((_) {
        if (!mounted) return;
        _applyLocale(ref.read(localeProvider));
      });
    });
  }

  void _applyLocale(String langCode) {
    if (!mounted) return;
    final localeCode = ref.read(localeProvider.notifier).toLocaleCode(langCode);
    final newLocale = Locale(localeCode);
    if (_locale == newLocale) {
      return;
    }
    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = ref.watch(themeProvider);
    final user = ref.watch(userProvider);
    final themeNotifier = ref.read(themeProvider.notifier);
    final initFuture = themeNotifier.initialized;

    // Reage a mudanças do idioma sempre que o provider for atualizado
    ref.listen<String>(localeProvider, (previous, next) {
      _applyLocale(next);
    });

    // Garante que o tema seja sincronizado assim que o usuário autenticar
    ref.listen<User?>(userProvider, (previous, next) {
      final prevUid = previous?.uid;
      final nextUid = next?.uid;
      if (nextUid != null && prevUid != nextUid) {
        themeNotifier.refreshForUser(next);
      }
      _ensureLocaleInitialized(next);
    });

    return FutureBuilder<void>(
      future: initFuture,
      builder: (context, snapshot) {
        Widget buildAppHome(Widget home) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: _locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            routes: {
              '/login': (ctx) => const LoginPage(),
              '/main': (ctx) => const ProtectedRoute(child: MainPage()),
              '/activity': (ctx) => const ProtectedRoute(child: ActivityPage()),
            },
            theme: themeData,
            home: home,
          );
        }

        if (snapshot.connectionState != ConnectionState.done) {
          return buildAppHome(
            Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          );
        }

        final home = user != null ? const MainPage() : const LoginPage();
        return buildAppHome(home);
      },
    );
  }
}
