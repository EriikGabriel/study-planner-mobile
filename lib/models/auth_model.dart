import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_planner/providers/user_provider.dart';
import 'package:study_planner/types/login.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> sign({
    required String email,
    required LoginMode mode,
    required String password,
    required WidgetRef ref, // Pegamos o ref para atualizar o estado
  }) async {
    try {
      UserCredential result;
      if (mode == LoginMode.signIn) {
        result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else if (mode == LoginMode.signUp) {
        result = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        throw Exception('Invalid mode: $mode');
      }

      final user = result.user;

      print("User login: $user");

      if (user != null) {
        ref.read(userProvider.notifier).setUser(user); // Atualiza o provider
      }
      return user;
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      return null;
    }
  }
}
