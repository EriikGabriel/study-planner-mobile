// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/components/subjects_dialog.dart';
import 'package:study_planner/helpers/toast_helper.dart';
import 'package:study_planner/l10n/app_localizations.dart';
import 'package:study_planner/models/auth_model.dart';
import 'package:study_planner/providers/locale_provider.dart';
import 'package:study_planner/services/firebase_data_service.dart';
import 'package:study_planner/services/ufscar_api_service.dart';
import 'package:study_planner/theme/app_theme.dart';
import 'package:study_planner/types/login.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  bool _passwordVisibility = false;
  bool _isLoading = false;

  AppLocalizations get _loc => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  String? _validateNotEmpty(String? value) {
    return (value == null || value.isEmpty) ? _loc.mandatoryField : null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return _loc.mandatoryField;
    }
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!emailRegex.hasMatch(value)) {
      return _loc.loginInvalidEmail;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return _loc.mandatoryField;
    }
    if (value.length < 6) {
      return _loc.signupPasswordTooShort;
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    final loc = _loc;
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty) {
      showErrorToast(
        context: context,
        title: loc.error,
        content: loc.signupUsernameRequired,
      );
      return;
    }

    if (email.isEmpty) {
      showErrorToast(
        context: context,
        title: loc.error,
        content: loc.loginEmailRequired,
      );
      return;
    }

    if (_validateEmail(email) != null) {
      showErrorToast(
        context: context,
        title: loc.error,
        content: loc.loginInvalidEmail,
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

    if (_validatePassword(password) != null) {
      showErrorToast(
        context: context,
        title: loc.error,
        content: loc.signupPasswordTooShort,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      try {
        final user = await AuthModel().sign(
          email: email,
          password: password,
          mode: LoginMode.signUp,
          ref: ref,
        );

        if (user == null) {
          if (!mounted) return;
          showErrorToast(
            context: context,
            title: loc.error,
            content: loc.signupAccountCreationError,
          );
          setState(() => _isLoading = false);
          return;
        }

        final selectedLang = ref.read(localeProvider);
        await ref
            .read(localeProvider.notifier)
            .changeLanguage(selectedLang, user.email ?? email);

        if (username.isNotEmpty) {
          await user.updateDisplayName(username);
        }

        if (!mounted) return;

        final apiResponse = await UFSCarAPIService.loginAndFetchSubjects(
          email: email,
          password: password,
        );

        if (!mounted) return;

        if (apiResponse == null) {
          showErrorToast(
            context: context,
            title: loc.error,
            content: loc.signupUfscarInvalidCredentials,
          );
          setState(() => _isLoading = false);
          return;
        }

        final subjects = UFSCarAPIService.parseSubjects(apiResponse);

        final dataSaved =
            await FirebaseDataService.saveUserProfileAndDisciplines(
              email: email,
              displayName: username,
              apiResponse: apiResponse,
            );

        if (!dataSaved) {
          if (mounted) {
            showErrorToast(
              context: context,
              title: loc.error,
              content: loc.signupSaveDataError,
            );
          }
          setState(() => _isLoading = false);
          return;
        }

        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => SubjectsDialog(subjects: subjects),
          );
        }

        showSuccessToast(
          context: context,
          title: loc.success,
          content: loc.userCreated,
        );

        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      } on FirebaseAuthException catch (authError) {
        if (!mounted) return;

        String errorMessage = loc.signupGenericError;

        if (authError.code == 'email-already-in-use') {
          errorMessage = loc.signupEmailAlreadyExists;
        } else if (authError.code == 'invalid-email') {
          errorMessage = loc.loginInvalidEmail;
        } else if (authError.code == 'weak-password') {
          errorMessage = loc.signupWeakPassword;
        } else if (authError.code == 'operation-not-allowed') {
          errorMessage = loc.signupOperationNotAllowed;
        } else {
          errorMessage = loc.signupGenericError;
        }

        showErrorToast(
          context: context,
          title: loc.error,
          content: errorMessage,
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context: context,
          title: loc.error,
          content: '${loc.signupApiConnectionError}: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryText = Theme.of(context).colorScheme.primaryText;
    final secondaryText = Theme.of(context).colorScheme.secondaryText;
    final alternateColor = Theme.of(context).colorScheme.alternate;
    final primaryBackground = Theme.of(context).colorScheme.primaryBackground;
    final errorColor = Theme.of(context).colorScheme.error;

    final width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: SizedBox(
            width: width,
            child: TextFormField(
              controller: _usernameController,
              focusNode: _usernameFocusNode,
              style: TextStyle(color: primaryText),
              cursorColor: primaryText,
              decoration: InputDecoration(
                isDense: true,
                hintText: _loc.username,
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: secondaryText),
                filled: true,
                fillColor: primaryBackground,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: alternateColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: alternateColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(Icons.person, color: secondaryText),
              ),
              validator: _validateNotEmpty,
            ),
          ),
        ),
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
                hintText: _loc.loginEmail,
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: secondaryText),
                filled: true,
                fillColor: primaryBackground,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: alternateColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: alternateColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: Icon(Icons.email, color: secondaryText),
              ),
              validator: _validateNotEmpty,
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
                hintText: _loc.loginPassword,
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(color: secondaryText),
                filled: true,
                fillColor: primaryBackground,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: alternateColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: alternateColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: errorColor, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: IconButton(
                  onPressed: () => setState(
                    () => _passwordVisibility = !_passwordVisibility,
                  ),
                  icon: Icon(
                    _passwordVisibility
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: secondaryText,
                    size: 22,
                  ),
                ),
              ),
              validator: _validateNotEmpty,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSignUp,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primaryBackground,
                      ),
                    ),
                  )
                : Text(
                    _loc.loginButtonSignup,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.primaryBackground,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
