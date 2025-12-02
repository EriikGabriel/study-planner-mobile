// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/helpers/toast_helper.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:study_planner/models/auth_model.dart';
import 'package:study_planner/pages/signup_form.dart';
import 'package:study_planner/providers/locale_provider.dart';
import 'package:study_planner/theme/app_theme.dart';
import 'package:study_planner/types/login.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _passwordVisibility = false;
  LoginMode _mode = LoginMode.signIn;
  bool _languageChanged = false;

  static const List<String> _languageCodes = ['pt', 'en', 'es', 'fr', 'zh'];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final loc = AppLocalizations.of(context)!;

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty) {
        showErrorToast(
          context: context,
          title: loc.error,
          content: loc.loginEmailRequired,
        );
        return;
      }

      if (password.isEmpty) {
        showErrorToast(
          context: context,
          title: loc.error,
          content: loc.loginPasswordRequired,
        );
        return;
      }

      final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
      if (!emailRegex.hasMatch(email)) {
        showErrorToast(
          context: context,
          title: loc.error,
          content: loc.loginInvalidEmail,
        );
        return;
      }

      final user = await AuthModel().sign(
        email: email,
        password: password,
        mode: _mode,
        ref: ref,
      );

      if (user != null) {
        if (_languageChanged) {
          final selectedLang = ref.read(localeProvider);
          final userEmail = user.email ?? email;
          await ref
              .read(localeProvider.notifier)
              .changeLanguage(selectedLang, userEmail);
          if (mounted) {
            setState(() => _languageChanged = false);
          } else {
            _languageChanged = false;
          }
        }

        if (!mounted) return;

        showSuccessToast(
          context: context,
          title: loc.success,
          content: loc.loginSuccess,
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/main');
        }
      } else {
        if (!mounted) return;
        showErrorToast(
          context: context,
          title: loc.error,
          content: loc.loginInvalidCredentials,
        );
      }
    } on FirebaseAuthException catch (authError) {
      var errorMessage = loc.loginGenericError;

      if (authError.code == 'user-not-found') {
        errorMessage = loc.loginUserNotFound;
      } else if (authError.code == 'wrong-password') {
        errorMessage = loc.loginWrongPassword;
      } else if (authError.code == 'invalid-email') {
        errorMessage = loc.loginInvalidEmail;
      } else if (authError.code == 'user-disabled') {
        errorMessage = loc.loginUserDisabled;
      } else if (authError.code == 'too-many-requests') {
        errorMessage = loc.loginTooManyRequests;
      }

      if (mounted) {
        showErrorToast(
          context: context,
          title: loc.error,
          content: errorMessage,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during authentication: $e');
      }

      if (mounted) {
        showErrorToast(
          context: context,
          title: loc.error,
          content: loc.loginGenericError,
        );
      }
    }
  }

  void _showLanguageSelector(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final localeNotifier = ref.read(localeProvider.notifier);
    final currentLang = ref.read(localeProvider);

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  loc.settingsLanguageDialogTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              for (final code in _languageCodes)
                ListTile(
                  leading: Icon(
                    code == currentLang
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                  ),
                  title: Text(_localizedLanguageName(loc, code)),
                  onTap: () async {
                    final previousLang = ref.read(localeProvider);
                    if (code == previousLang) {
                      Navigator.of(ctx).pop();
                      return;
                    }
                    await localeNotifier.changeLanguage(code, null);
                    if (mounted) {
                      setState(() => _languageChanged = true);
                    } else {
                      _languageChanged = true;
                    }
                    Navigator.of(ctx).pop();
                  },
                ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  String _localizedLanguageName(AppLocalizations loc, String code) {
    switch (code) {
      case 'en':
        return loc.languageEnglish;
      case 'es':
        return loc.languageSpanish;
      case 'fr':
        return loc.languageFrench;
      case 'zh':
        return loc.languageChinese;
      case 'pt':
      default:
        return loc.languagePortuguese;
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final theme = Theme.of(context).colorScheme;
    final primaryColor = theme.primary;
    final alternateColor = theme.alternate;
    final primaryText = theme.primaryText;
    final secondaryText = theme.secondaryText;
    final secondaryBackground = theme.secondaryBackground;
    final errorColor = theme.error;

    final localeNotifier = ref.read(localeProvider.notifier);
    final currentLang = ref.watch(localeProvider);

    final mainContent = Padding(
      padding: const EdgeInsets.only(top: 100),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            spacing: 32,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 113,
                height: 113,
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: secondaryBackground,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color.fromARGB(33, 0, 0, 0),
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                width: 250,
                child: Column(
                  spacing: 12,
                  children: [
                    Text(
                      loc.appTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: primaryText,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      loc.appTagline,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16,
                            color: secondaryText,
                          ),
                    ),
                  ],
                ),
              ),
              Container(
                width: width,
                height: height,
                padding: const EdgeInsets.all(34),
                decoration: BoxDecoration(
                  color: secondaryBackground,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      color: Color.fromARGB(33, 0, 0, 0),
                      offset: Offset(0, 2),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(32),
                  border: BoxBorder.all(color: alternateColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 30,
                  children: [
                    Text(
                      _mode == LoginMode.signIn
                          ? loc.loginSigninTitle
                          : loc.loginSignupTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: primaryText,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (_mode == LoginMode.signIn)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: width,
                              child: TextFormField(
                                controller: _emailController,
                                focusNode: _emailFocusNode,
                                style: TextStyle(color: primaryText),
                                cursorColor: primaryText,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: loc.loginEmail,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: secondaryText),
                                  filled: true,
                                  fillColor: secondaryBackground,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: alternateColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: alternateColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: errorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: Icon(
                                    Icons.email,
                                    color: secondaryText,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return loc.loginEmailRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: SizedBox(
                              width: width,
                              child: TextFormField(
                                controller: _passwordController,
                                focusNode: _passwordFocusNode,
                                obscureText: !_passwordVisibility,
                                style: TextStyle(color: primaryText),
                                cursorColor: primaryText,
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: loc.loginPassword,
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: secondaryText),
                                  filled: true,
                                  fillColor: secondaryBackground,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: alternateColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: alternateColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: errorColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisibility = !_passwordVisibility;
                                      });
                                    },
                                    icon: Icon(
                                      _passwordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: secondaryText,
                                      size: 22,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return loc.loginPasswordRequired;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      const SignUpForm(),
                    if (_mode == LoginMode.signIn)
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 64,
                            child: OutlinedButton(
                              onPressed: handleLogin,
                              style: OutlinedButton.styleFrom(
                                backgroundColor: primaryColor,
                                side: const BorderSide(
                                  color: Color(0xFF2FD1C5),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 12,
                                children: [
                                  Text(
                                    loc.loginButton,
                                    style: TextStyle(
                                      color: secondaryBackground,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _mode = _mode == LoginMode.signIn
                                ? LoginMode.signUp
                                : LoginMode.signIn;
                          });
                        },
                        child: Text(
                          _mode == LoginMode.signIn
                              ? loc.loginToggleSignup
                              : loc.loginToggleSignin,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final languageSelectorButton = SafeArea(
      child: Align(
        alignment: Alignment.topRight,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, right: 16),
          child: OutlinedButton.icon(
            onPressed: () => _showLanguageSelector(context),
            icon: const Icon(Icons.language, size: 18),
            label: Text(localeNotifier.getLanguageDisplayName(currentLang)),
            style: OutlinedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondaryBackground,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          mainContent,
          languageSelectorButton,
        ],
      ),
    );
  }
}
