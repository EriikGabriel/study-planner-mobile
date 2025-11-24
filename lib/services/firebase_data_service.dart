import 'package:firebase_database/firebase_database.dart';

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
}
