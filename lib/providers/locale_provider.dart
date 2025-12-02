import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/services/firebase_data_service.dart';

/// Notifier que gerencia o idioma/locale da aplicação
class LocaleNotifier extends Notifier<String> {
  @override
  String build() => 'pt';

  /// Inicializa o idioma do usuário a partir do Firebase
  Future<void> initialize(String? userEmail) async {
    if (userEmail == null) {
      state = 'pt';
      return;
    }

    try {
      final langCode = await FirebaseDataService.getUserLanguageSetting(userEmail);
      state = langCode;
    } catch (e) {
      state = 'pt';
    }
  }

  /// Altera o idioma da aplicação
  Future<void> changeLanguage(String langCode, String? userEmail) async {
    // Salva no Firebase se usuário estiver logado
    if (userEmail != null) {
      await FirebaseDataService.setUserLanguageSetting(userEmail, langCode);
    }

    // Atualiza o estado
    state = langCode;
  }

  /// Converte código de idioma para string de locale
  String toLocaleCode(String langCode) {
    // Mapeamento: pt -> pt (arquivo pt.json), não pt_br
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
