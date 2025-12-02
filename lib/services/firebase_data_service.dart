import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class FirebaseDataService {
  static Future<bool> saveUserProfileAndDisciplines({
    required String email,
    required String displayName,
    required Map<String, dynamic> apiResponse,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();

      final safeEmail = email.replaceAll(".", "_");

      await db.child("users").child(safeEmail).set({
        "displayName": displayName,
        "subjects": apiResponse["data"], // salva direto o JSON
        "createdAt": DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print("Erro ao salvar no Firebase: $e");
      return false;
    }
  }

  /// Salva uma atividade para o usuário no Realtime Database.
  static Future<bool> saveUserActivity({
    required String email,
    required Map<String, dynamic> activity,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      await db
          .child('users')
          .child(safeEmail)
          .child('activities')
          .push()
          .set(activity);
      return true;
    } catch (e) {
      print('Erro ao salvar atividade no Firebase: $e');
      return false;
    }
  }

  /// Busca as atividades do usuário (snapshot único). Retorna lista de maps.
  static Future<List<Map<String, dynamic>>> fetchUserActivities(
    String email,
  ) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      final snapshot = await db
          .child('users')
          .child(safeEmail)
          .child('activities')
          .get();
      if (!snapshot.exists || snapshot.value == null) return [];

      final Map data = snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> activities = [];
      data.forEach((key, value) {
        if (value is Map) {
          final item = Map<String, dynamic>.from(value);
          item['id'] = key;
          activities.add(item);
        }
      });

      return activities;
    } catch (e) {
      print('Erro ao buscar atividades: $e');
      return [];
    }
  }

  /// Atualiza uma atividade existente (substitui os campos) pelo id.
  static Future<bool> updateUserActivity({
    required String email,
    required String id,
    required Map<String, dynamic> activity,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      await db
          .child('users')
          .child(safeEmail)
          .child('activities')
          .child(id)
          .set(activity);
      return true;
    } catch (e) {
      print('Erro ao atualizar atividade: $e');
      return false;
    }
  }

  /// Remove uma atividade pelo id.
  static Future<bool> deleteUserActivity({
    required String email,
    required String id,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      await db
          .child('users')
          .child(safeEmail)
          .child('activities')
          .child(id)
          .remove();
      return true;
    } catch (e) {
      print('Erro ao deletar atividade: $e');
      return false;
    }
  }

  /// Busca as matérias do usuário no Realtime Database
  static Future<List<Map<String, dynamic>>> fetchUserSubjects(
    String email,
  ) async {
    try {
      if (kDebugMode)
        print('🔍 [Firebase] Buscando matérias do usuário: $email');

      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll(".", "_");

      final snapshot = await db
          .child('users')
          .child(safeEmail)
          .child('subjects')
          .get();

      if (!snapshot.exists) {
        if (kDebugMode) print('⚠️ [Firebase] Nenhuma matéria encontrada');
        return [];
      }

      final List<dynamic> data = snapshot.value as List<dynamic>;
      final List<Map<String, dynamic>> subjects = [];

      for (var subject in data) {
        if (subject != null && subject is Map) {
          subjects.add({
            'id': subject['id'],
            'nome': subject['atividade'] ?? 'Sem nome',
            'turma': subject['turma'] ?? 'N/A',
            'periodo': subject['periodo'],
            'ano': subject['ano'],
            'horarios': subject['horarios'] ?? [],
          });
        }
      }

      // Ordena por dia da semana e depois por horário
      subjects.sort((a, b) {
        final horariosA = a['horarios'] as List<dynamic>? ?? [];
        final horariosB = b['horarios'] as List<dynamic>? ?? [];

        // Se não tem horário, vai pro final
        if (horariosA.isEmpty) return 1;
        if (horariosB.isEmpty) return -1;

        // Pega o primeiro horário de cada matéria
        final horarioA = horariosA[0];
        final horarioB = horariosB[0];

        // Mapeia dias da semana para números (para ordenação)
        final diaA = _getDayOrder(horarioA['dia']?.toString() ?? '');
        final diaB = _getDayOrder(horarioB['dia']?.toString() ?? '');

        // Primeiro compara os dias
        if (diaA != diaB) {
          return diaA.compareTo(diaB);
        }

        // Se for o mesmo dia, compara os horários
        final inicioA = horarioA['inicio']?.toString() ?? '00:00:00';
        final inicioB = horarioB['inicio']?.toString() ?? '00:00:00';
        return inicioA.compareTo(inicioB);
      });

      if (kDebugMode)
        print(
          '✅ [Firebase] ${subjects.length} matérias encontradas e ordenadas',
        );
      return subjects;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao buscar matérias: $e');
      return [];
    }
  }

  /// Busca posts de uma sala (por id da matéria)
  static Future<List<Map<String, dynamic>>> fetchRoomPosts(
    String subjectId,
  ) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final snapshot = await db
          .child('rooms')
          .child(subjectId)
          .child('posts')
          .get();
      if (!snapshot.exists || snapshot.value == null) return [];

      final Map data = snapshot.value as Map<dynamic, dynamic>;
      final List<Map<String, dynamic>> posts = [];
      data.forEach((key, value) {
        if (value is Map) {
          final item = Map<String, dynamic>.from(value);
          item['id'] = key;
          posts.add(item);
        }
      });
      // order by createdAt desc if present
      posts.sort((a, b) {
        final aTs =
            DateTime.tryParse(a['createdAt']?.toString() ?? '') ??
            DateTime(1970);
        final bTs =
            DateTime.tryParse(b['createdAt']?.toString() ?? '') ??
            DateTime(1970);
        return bTs.compareTo(aTs);
      });
      return posts;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao buscar posts da sala: $e');
      return [];
    }
  }

  /// Salva um post em uma sala (push)
  static Future<bool> saveRoomPost({
    required String subjectId,
    required Map<String, dynamic> post,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      await db.child('rooms').child(subjectId).child('posts').push().set(post);
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao salvar post da sala: $e');
      return false;
    }
  }

  /// Remove um post de uma sala pelo id
  static Future<bool> deleteRoomPost({
    required String subjectId,
    required String postId,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      await db
          .child('rooms')
          .child(subjectId)
          .child('posts')
          .child(postId)
          .remove();
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao deletar post da sala: $e');
      return false;
    }
  }

  /// Salva uma resposta dentro de um post da sala
  static Future<bool> saveRoomReply({
    required String subjectId,
    required String postId,
    required Map<String, dynamic> reply,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      await db
          .child('rooms')
          .child(subjectId)
          .child('posts')
          .child(postId)
          .child('replies')
          .push()
          .set(reply);
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao salvar resposta: $e');
      return false;
    }
  }

  /// Deleta uma resposta específica de um post
  static Future<bool> deleteRoomReply({
    required String subjectId,
    required String postId,
    required String replyId,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      await db
          .child('rooms')
          .child(subjectId)
          .child('posts')
          .child(postId)
          .child('replies')
          .child(replyId)
          .remove();
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao deletar resposta: $e');
      return false;
    }
  }

  /// Uploads an attachment (PDF or image) for a room and saves it to Realtime Database as base64
  /// Returns the attachment ID that can be used to retrieve the file
  static Future<String?> uploadRoomAttachment({
    required String subjectId,
    required String filename,
    required Uint8List data,
    void Function(double progress)? onProgress,
  }) async {
    try {
      if (kDebugMode) {
        print('📤 [Firebase] Iniciando upload para Database: $filename (${data.length} bytes)');
      }
      
      // Verificar tamanho máximo (10MB)
      const maxSize = 10 * 1024 * 1024;
      if (data.length > maxSize) {
        if (kDebugMode) print('❌ [Firebase] Arquivo muito grande: ${data.length} bytes');
        return null;
      }
      
      // Detectar tipo de arquivo pela extensão
      final extension = filename.toLowerCase().split('.').last;
      String contentType;
      if (extension == 'pdf') {
        contentType = 'application/pdf';
      } else if (extension == 'jpg' || extension == 'jpeg') {
        contentType = 'image/jpeg';
      } else if (extension == 'png') {
        contentType = 'image/png';
      } else if (extension == 'gif') {
        contentType = 'image/gif';
      } else if (extension == 'webp') {
        contentType = 'image/webp';
      } else {
        contentType = 'application/octet-stream';
      }
      
      if (kDebugMode) print('📄 [Firebase] Tipo detectado: $contentType');
      
      // Converter para base64
      if (kDebugMode) print('🔄 [Firebase] Convertendo para base64...');
      if (onProgress != null) onProgress(0.3);
      
      final base64Data = base64Encode(data);
      
      if (kDebugMode) print('✅ [Firebase] Base64 gerado: ${base64Data.length} caracteres');
      if (onProgress != null) onProgress(0.5);
      
      // Gerar ID único para o attachment (remover caracteres inválidos do Firebase: . # $ [ ])
      final sanitizedFilename = filename.replaceAll(RegExp(r'[.\#\$\[\]]'), '_');
      final attachmentId = '${DateTime.now().millisecondsSinceEpoch}_$sanitizedFilename';
      
      // Salvar no Realtime Database
      final db = FirebaseDatabase.instance.ref();
      final attachmentData = {
        'filename': filename,
        'data': base64Data,
        'size': data.length,
        'contentType': contentType,
        'uploadedAt': DateTime.now().toIso8601String(),
      };
      
      if (kDebugMode) print('💾 [Firebase] Salvando no Database...');
      if (onProgress != null) onProgress(0.7);
      
      await db
          .child('rooms')
          .child(subjectId)
          .child('attachments')
          .child(attachmentId)
          .set(attachmentData);
      
      if (kDebugMode) print('✅ [Firebase] Attachment salvo com ID: $attachmentId');
      if (onProgress != null) onProgress(1.0);
      
      // Retornar o ID do attachment como "URL"
      return attachmentId;
    } catch (e, stack) {
      if (kDebugMode) {
        print('❌ [Firebase] Erro ao fazer upload do anexo: $e');
        print('Stack trace: $stack');
      }
      return null;
    }
  }

  /// Downloads an attachment from Realtime Database and returns the PDF bytes
  static Future<Uint8List?> downloadRoomAttachment({
    required String subjectId,
    required String attachmentId,
  }) async {
    try {
      if (kDebugMode) {
        print('📥 [Firebase] Baixando attachment: $attachmentId');
      }
      
      final db = FirebaseDatabase.instance.ref();
      final snapshot = await db
          .child('rooms')
          .child(subjectId)
          .child('attachments')
          .child(attachmentId)
          .get();
      
      if (!snapshot.exists || snapshot.value == null) {
        if (kDebugMode) print('❌ [Firebase] Attachment não encontrado');
        return null;
      }
      
      final data = snapshot.value as Map<dynamic, dynamic>;
      final base64Data = data['data']?.toString();
      
      if (base64Data == null) {
        if (kDebugMode) print('❌ [Firebase] Dados do attachment vazios');
        return null;
      }
      
      if (kDebugMode) print('🔄 [Firebase] Decodificando base64...');
      final bytes = base64Decode(base64Data);
      
      if (kDebugMode) print('✅ [Firebase] Attachment baixado: ${bytes.length} bytes');
      return bytes;
    } catch (e, stack) {
      if (kDebugMode) {
        print('❌ [Firebase] Erro ao baixar attachment: $e');
        print('Stack trace: $stack');
      }
      return null;
    }
  }

  /// Mapeia o dia da semana para um número (para ordenação)
  static int _getDayOrder(String dia) {
    final diaUpper = dia.toUpperCase();
    switch (diaUpper) {
      case 'SEGUNDA':
      case 'SEGUNDA-FEIRA':
        return 1;
      case 'TERCA':
      case 'TERÇA':
      case 'TERÇA-FEIRA':
      case 'TERCA-FEIRA':
        return 2;
      case 'QUARTA':
      case 'QUARTA-FEIRA':
        return 3;
      case 'QUINTA':
      case 'QUINTA-FEIRA':
        return 4;
      case 'SEXTA':
      case 'SEXTA-FEIRA':
        return 5;
      case 'SABADO':
      case 'SÁBADO':
        return 6;
      case 'DOMINGO':
        return 7;
      default:
        return 999; // Dias não reconhecidos vão pro final
    }
  }

  /// Fetches attendance record for a user and subject (returns null if none)
  static Future<Map<String, dynamic>?> fetchAttendance({
    required String email,
    required String subjectId,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      final snapshot = await db
          .child('users')
          .child(safeEmail)
          .child('attendance')
          .child(subjectId)
          .get();
      if (!snapshot.exists || snapshot.value == null) return null;
      final Map data = snapshot.value as Map<dynamic, dynamic>;
      return Map<String, dynamic>.from(data);
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao buscar presença: $e');
      return null;
    }
  }

  /// Saves attendance record for a user and subject (overwrites)
  static Future<bool> saveAttendance({
    required String email,
    required String subjectId,
    required Map<String, dynamic> attendance,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      await db
          .child('users')
          .child(safeEmail)
          .child('attendance')
          .child(subjectId)
          .set(attendance);
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao salvar presença: $e');
      return false;
    }
  }

  /// Increment attendance counters atomically (attended/missed)
  static Future<bool> incrementAttendance({
    required String email,
    required String subjectId,
    int attendedDelta = 0,
    int missedDelta = 0,
  }) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      final ref = db
          .child('users')
          .child(safeEmail)
          .child('attendance')
          .child(subjectId);

      final snapshot = await ref.get();
      Map<String, dynamic> value;
      if (!snapshot.exists || snapshot.value == null) {
        value = {
          'attended': attendedDelta > 0 ? attendedDelta : 0,
          'missed': missedDelta > 0 ? missedDelta : 0,
          'updatedAt': DateTime.now().toIso8601String(),
        };
      } else {
        final map = Map<String, dynamic>.from(snapshot.value as Map);
        final int attended = (map['attended'] is int)
            ? map['attended']
            : int.tryParse(map['attended']?.toString() ?? '') ?? 0;
        final int missed = (map['missed'] is int)
            ? map['missed']
            : int.tryParse(map['missed']?.toString() ?? '') ?? 0;
        value = {
          ...map,
          'attended': attended + attendedDelta,
          'missed': missed + missedDelta,
          'updatedAt': DateTime.now().toIso8601String(),
        };
      }
      await ref.set(value);

      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao incrementar presença: $e');
      return false;
    }
  }

  /// Get or set user setting: automatic presence when adding subject
  static Future<bool> getUserAutoPresenceSetting(String email) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      final snapshot = await db
          .child('users')
          .child(safeEmail)
          .child('settings')
          .child('autoPresence')
          .get();
      if (!snapshot.exists || snapshot.value == null)
        return true; // default true
      return snapshot.value == true || snapshot.value?.toString() == 'true';
    } catch (e) {
      if (kDebugMode)
        print('❌ [Firebase] Erro ao ler setting autoPresence: $e');
      return true;
    }
  }

  static Future<bool> setUserAutoPresenceSetting(
    String email,
    bool value,
  ) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      await db
          .child('users')
          .child(safeEmail)
          .child('settings')
          .child('autoPresence')
          .set(value);
      return true;
    } catch (e) {
      if (kDebugMode)
        print('❌ [Firebase] Erro ao salvar setting autoPresence: $e');
      return false;
    }
  }

  /// Get user's preferred language (returns language code). Defaults to 'pt' (Português)
  static Future<String> getUserLanguageSetting(String email) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      final snapshot = await db
          .child('users')
          .child(safeEmail)
          .child('settings')
          .child('language')
          .get();
      if (!snapshot.exists || snapshot.value == null) return 'pt';
      return snapshot.value.toString();
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao ler setting language: $e');
      return 'pt';
    }
  }

  /// Set user's preferred language (language code: 'pt','en','es','fr','zh')
  static Future<bool> setUserLanguageSetting(String email, String lang) async {
    try {
      final db = FirebaseDatabase.instance.ref();
      final safeEmail = email.replaceAll('.', '_');
      await db
          .child('users')
          .child(safeEmail)
          .child('settings')
          .child('language')
          .set(lang);
      return true;
    } catch (e) {
      if (kDebugMode) print('❌ [Firebase] Erro ao salvar setting language: $e');
      return false;
    }
  }
}
