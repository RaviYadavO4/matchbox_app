import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  Future<void> fetchUser() async {
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  void reloadUser() async {
    await FirebaseAuth.instance.currentUser?.reload();
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}

