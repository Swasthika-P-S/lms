import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _user; // email or dummy id

  bool get isLoading => _isLoading;
  String? get user => _user;

  void login(String email) {
    _isLoading = true;
    notifyListeners();

    _user = email; // dummy login
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
