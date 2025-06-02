import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProviders with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  User? get user => _user;

  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      _user = _auth.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      throw Exception("Registration failed: $e");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  // You can implement user profile fetching (if needed)
  Future<void> getUserProfile() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Fetch user details from Firestore, etc.
    }
  }
}
