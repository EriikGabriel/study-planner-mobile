/// Classe mock para simular usuário Firebase durante testes no Widgetbook
class MockFirebaseUser {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;

  MockFirebaseUser({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
  });

  static MockFirebaseUser create({
    String uid = '123456789',
    String? email = 'usuario@example.com',
    String? displayName = 'Usuário Teste',
    String? photoURL,
  }) {
    return MockFirebaseUser(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
    );
  }
}

/// Dados mock para atividades
class MockActivityData {
  static const List<Map<String, dynamic>> activities = [
    {
      'title': 'Matemática',
      'description':
          'Crie uma história emocional que descreva melhor que palavras.',
      'time': '10:30 - 11:30',
      'color': 0xFFFFB5B5,
      'icon': 'calculate_rounded',
      'date': 'Hoje, segunda-feira 17',
    },
    {
      'title': 'Geometria',
      'description':
          'Crie uma história emocional que descreva melhor que palavras.',
      'time': '11:30 - 12:30',
      'color': 0xFFA8E6CF,
      'icon': 'square_foot_rounded',
      'date': 'Quinta-feira 18',
    },
    {
      'title': 'História',
      'description':
          'Crie uma história emocional que descreva melhor que palavras.',
      'time': '13:00 - 14:00',
      'color': 0xFFD1C4E9,
      'icon': 'menu_book_rounded',
      'date': 'Quinta-feira 18',
    },
  ];
}

/// Dados mock para tarefas na agenda
class MockTaskData {
  static const List<Map<String, dynamic>> tasks = [
    {
      'title': 'Laboratório de Redes',
      'subtitle': 'Fábio Luciano Verdi',
      'time': '9:00 - 10:00',
      'color': 0xFFFFB84D,
    },
    {
      'title': 'Desenvolvimento Web',
      'subtitle': 'Luciana Zaina',
      'time': '11:00 - 12:00',
      'color': 0xFF4CD7A5,
    },
    {
      'title': 'Desenvolvimento p/ Dispositivos Móveis',
      'subtitle': 'José de Oliveira Guimarães',
      'time': '13:00 - 14:00',
      'color': 0xFFB894F6,
    },
  ];
}
