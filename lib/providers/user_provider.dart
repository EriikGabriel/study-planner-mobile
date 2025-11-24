import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserNotifier extends StateNotifier<User?> {
  UserNotifier() : super(FirebaseAuth.instance.currentUser) {
    _authListener();
  }

  void _authListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      state = user;
    });
  }

  void setUser(User? user) {
    state = user;
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    state = null;
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});
