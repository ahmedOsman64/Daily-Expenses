import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/constants.dart';
class AuthViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService;
  
  bool _isLoading = false;
  User? _user;
  String? _profileImage;

  AuthViewModel(this._supabaseService) {
    _user = _supabaseService.currentUser;
    _supabaseService.authStateChanges.listen((data) {
      _user = data.session?.user;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  String? get userId => _user?.id;
  String? get userName => _user?.userMetadata?['full_name'] ?? _user?.email?.split('@')[0];
  String get email => _user?.email ?? '';
  String? get profileImage => _profileImage;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        // Mock login for testing
        await Future.delayed(const Duration(seconds: 1));
        _user = User(
          id: 'test-user-id',
          appMetadata: {},
          userMetadata: {'full_name': 'Test User'},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        );
        _isLoading = false;
        notifyListeners();
        return;
      }
      await _supabaseService.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        // Mock register for testing
        await Future.delayed(const Duration(seconds: 1));
        _user = User(
          id: 'test-user-id',
          appMetadata: {},
          userMetadata: {'full_name': name},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        );
        _isLoading = false;
        notifyListeners();
        return;
      }
      await _supabaseService.signUp(
        email: email,
        password: password,
        fullName: name,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfile(String name, String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Supabase user metadata update
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {'full_name': name},
        ),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updatePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateProfileImage(String imageUrl) async {
    _isLoading = true;
    notifyListeners();

    // In a real app, you'd upload to Supabase Storage first
    _profileImage = imageUrl;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _supabaseService.signOut();
    notifyListeners();
  }
}
