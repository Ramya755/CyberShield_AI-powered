import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _loading = false;

  bool get loading => _loading;
  bool get isLoggedIn => _auth.currentUser != null;
  User? get user => _auth.currentUser;

  Future<bool> login(String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      debugPrint("Login failed: $e");
      return false;
    }
  }

  Future<bool> signup(String email, String password) async {
    try {
      _loading = true;
      notifyListeners();

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _loading = false;
      notifyListeners();
      debugPrint("Signup failed: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}
