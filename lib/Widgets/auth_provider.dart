import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProviderFunction with ChangeNotifier {
  String? _email;

  String? get email => _email;

  void setEmail(String email) {
    _email = email;
    notifyListeners(); // Notify all listeners when email updates
  }

  void logout() {
    _email = null;
    notifyListeners();
  }
}
