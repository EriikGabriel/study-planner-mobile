import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to interact with UFSCar SIGA API
/// Handles login and fetching user subjects (matérias)
class UFSCarAPIService {
  static const String _baseUrl = 'https://sistemas.ufscar.br/sagui-api/siga';

  static const bool _useMockData = false;

  static Future<Map<String, dynamic>?> loginAndFetchSubjects({
    required String email,
    required String password,
  }) async {
    // Mock mode
    if (_useMockData) {
      if (kDebugMode) print('🧪 [UFSCar API] Usando dados mock');
      await Future.delayed(const Duration(seconds: 1));
      return _getMockData();
    }

    try {
      final url = Uri.parse('$_baseUrl/deferimento');

      // BASIC AUTH (igual ao Next.js)
      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$email:$password'))}';

      if (kDebugMode) {
        print('🔵 [UFSCar API] GET $url');
        print('🔐 Auth: $basicAuth');
      }

      final response = await http
          .get(
            url,
            headers: {
              'Authorization': basicAuth,
              'Accept': 'application/json',
              'Origin': 'https://sistemas.ufscar.br',
              'Referer': 'https://sistemas.ufscar.br',
            },
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw Exception('Timeout de 30s ao conectar à API');
            },
          );

      // Debug
      if (kDebugMode) {
        print('📡 [UFSCar API] Status: ${response.statusCode}');
        print(
          '📥 Body: ${response.body.substring(0, math.min(500, response.body.length))}',
        );
      }

      // Sucesso
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      // Unauthorized
      if (response.statusCode == 401 || response.statusCode == 403) {
        if (kDebugMode) print('❌ Credenciais inválidas');
        return null;
      }

      // Outros erros
      throw Exception(
        'Erro HTTP ${response.statusCode}: '
        '${response.body.substring(0, math.min(200, response.body.length))}',
      );
    } catch (e) {
      if (kDebugMode) print('❌ [UFSCar API] Erro: $e');
      throw Exception('Erro inesperado: $e');
    }
  }

  /// Mock data
  static Map<String, dynamic> _getMockData() {
    return {
      'success': true,
      'user': 'Aluno Teste',
      'disciplinas': [
        {
          'codigo': 'DM001',
          'nome': 'Cálculo I',
          'creditos': '4',
          'professor': 'Prof. João',
          'turma': 'A',
        },
        {
          'codigo': 'DM002',
          'nome': 'Álgebra Linear',
          'creditos': '3',
          'professor': 'Prof. Maria',
          'turma': 'B',
        },
        {
          'codigo': 'DC003',
          'nome': 'Programação',
          'creditos': '4',
          'professor': 'Prof. Pedro',
          'turma': 'A',
        },
      ],
    };
  }

  /// Parse subjects from API response
  static List<Map<String, String>> parseSubjects(
    Map<String, dynamic> apiResponse,
  ) {
    final List<Map<String, String>> subjects = [];

    if (apiResponse.containsKey('data')) {
      final disciplinas = apiResponse['data'] as List;
      for (final disc in disciplinas) {
        subjects.add({
          'codigo': disc['codigo']?.toString() ?? 'N/A',
          'nome': disc['nome']?.toString() ?? 'Sem nome',
          'creditos': disc['creditos']?.toString() ?? '0',
        });
      }
    } else {
      subjects.add({
        'info': 'Resposta completa',
        'dados': jsonEncode(apiResponse),
      });
    }

    return subjects;
  }
}
