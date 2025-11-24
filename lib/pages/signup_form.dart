// Signup form component used by LoginPage when switching to sign-up mode
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:study_planner/helpers/toast_helper.dart';
import 'package:study_planner/models/auth_model.dart';
import 'package:study_planner/services/ufscar_api_service.dart';
import 'package:study_planner/theme/app_theme.dart';
import 'package:study_planner/types/login.dart';
import 'package:study_planner/widgets/subjects_dialog.dart';

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
    return (value == null || value.isEmpty)
        ? translate('mandatory-field')
        : null;
  }

  Future<void> _handleSignUp() async {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate all fields as mandatory
    if (username.isEmpty) {
      showErrorToast(
        context: context,
        title: translate('error'),
        content: 'Nome de usuário é obrigatório',
      );
      return;
    }

    if (email.isEmpty) {
      showErrorToast(
        context: context,
        title: translate('error'),
        content: 'Email é obrigatório',
      );
      return;
    }

    if (password.isEmpty) {
      showErrorToast(
        context: context,
        title: translate('error'),
        content: 'Senha é obrigatória',
      );
      return;
    }

    // Show loading state
    setState(() => _isLoading = true);

    try {
      // Call UFSCar API to login and fetch subjects
      final apiResponse = await UFSCarAPIService.loginAndFetchSubjects(
        email: email,
        password: password,
      );

      if (!mounted) return;

      if (apiResponse == null) {
        showErrorToast(
          context: context,
          title: translate('error'),
          content: 'Email ou senha inválidos. Verifique seus dados.',
        );
        setState(() => _isLoading = false);
        return;
      }

      // Parse subjects from response
      final subjects = UFSCarAPIService.parseSubjects(apiResponse);

      // Show subjects in dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => SubjectsDialog(subjects: subjects),
        );
      }

      try {
        final user = await AuthModel().sign(
          email: email,
          password: password,
          mode: LoginMode.signUp,
          ref: ref,
        );

        if (user != null) {
          if (username.isNotEmpty) user.updateDisplayName(username);

          showSuccessToast(
            context: context,
            title: translate('success'),
            content: translate('user-created'),
          );

          // Navigate to main after a short delay to allow dialog viewing
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/main');
          }
        }
      } catch (authError) {
        if (mounted) {
          showErrorToast(
            context: context,
            title: translate('error'),
            content: 'Erro ao registrar no aplicativo: $authError',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorToast(
          context: context,
          title: translate('error'),
          content: e.toString().contains('Erro')
              ? e.toString()
              : 'Erro ao conectar com a API: ${e.toString()}',
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
                hintText: translate('username'),
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
                hintText: 'Email',
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
                hintText: translate('password'),
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
                    'Cadastrar',
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
