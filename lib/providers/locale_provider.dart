import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/services/firebase_data_service.dart';

class LocaleNotifier extends Notifier<String> {
  @override
  String build() => 'pt';

  Future<void> initialize(String? userEmail) async {
    if (userEmail == null) {
      state = 'pt';
      return;
    }

    try {
      final langCode = await FirebaseDataService.getUserLanguageSetting(
        userEmail,
      );
      state = langCode;
    } catch (e) {
      state = 'pt';
    }
  }

  Future<void> changeLanguage(String langCode, String? userEmail) async {
    if (userEmail != null) {
      await FirebaseDataService.setUserLanguageSetting(userEmail, langCode);
    }

    state = langCode;
  }

  String toLocaleCode(String langCode) {
    switch (langCode) {
      case 'en':
        return 'en';
      case 'es':
        return 'es';
      case 'fr':
        return 'fr';
      case 'zh':
        return 'zh';
      case 'pt':
      default:
        return 'pt';
    }
  }

  /// Obtém o nome do idioma para exibição
  String getLanguageDisplayName(String langCode) {
    switch (langCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'zh':
        return '中文';
      case 'pt':
      default:
        return 'Português';
    }
  }
}

/// Provider global para o idioma
final localeProvider = NotifierProvider<LocaleNotifier, String>(
  LocaleNotifier.new,
);
