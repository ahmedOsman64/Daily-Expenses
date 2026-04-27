import 'package:flutter/material.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _userName;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    if (email.isNotEmpty && password.length >= 6) {
      _isLoggedIn = true;
      _userName = 'Ahmed';
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Invalid credentials');
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Mock API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoggedIn = true;
    _userName = name;
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null;
    notifyListeners();
  }
}
