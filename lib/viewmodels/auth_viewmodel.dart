import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AuthViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService;
  
  bool _isLoading = false;
  bool _isInitialized = false;
  User? _user;
  String? _profileImage;

  AuthViewModel(this._supabaseService) {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // 1. Try to get user from Supabase (if initialized)
    _user = _supabaseService.currentUser;

    // 2. If no user and in Mock Mode, check SharedPreferences
    if (_user == null && AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
      final prefs = await SharedPreferences.getInstance();
      final wasLoggedIn = prefs.getBool(AppConstants.keyUserLoggedIn) ?? false;
      
      if (wasLoggedIn) {
        _user = User(
          id: 'test-user-id',
          appMetadata: {},
          userMetadata: {'full_name': 'Test User'},
          aud: 'authenticated',
          createdAt: DateTime.now().toIso8601String(),
        );
      }
    }

    // 3. Listen for auth state changes
    _supabaseService.authStateChanges.listen((data) {
      _user = data.session?.user;
      _updatePersistence(_user != null);
      notifyListeners();
    });

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _updatePersistence(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.keyUserLoggedIn, loggedIn);
  }

  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
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
        await _updatePersistence(true);
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
        await _updatePersistence(true);
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
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        _user = User(
          id: _user?.id ?? 'test-user-id',
          email: email,
          appMetadata: _user?.appMetadata ?? {},
          userMetadata: {'full_name': name},
          aud: _user?.aud ?? 'authenticated',
          createdAt: _user?.createdAt ?? DateTime.now().toIso8601String(),
        );
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Supabase user metadata update
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          email: email,
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
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        await Future.delayed(const Duration(seconds: 1));
        _isLoading = false;
        notifyListeners();
        return;
      }

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
    try {
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        _user = null;
        await _updatePersistence(false);
        notifyListeners();
        return;
      }
      await _supabaseService.signOut();
      _user = null;
      await _updatePersistence(false);
      notifyListeners();
    } catch (e) {
      debugPrint('Error logging out: $e');
      // Force logout on client side even if server request fails
      _user = null;
      await _updatePersistence(false);
      notifyListeners();
    }
  }
  Future<void> requestPasswordReset(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        await Future.delayed(const Duration(seconds: 1)); // Mock network delay
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyPasswordResetOtp(String email, String otp) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        await Future.delayed(const Duration(seconds: 1)); // Mock network delay
        _isLoading = false;
        notifyListeners();
        return;
      }
      
      await Supabase.instance.client.auth.verifyOTP(
        type: OtpType.recovery,
        token: otp,
        email: email,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> confirmPasswordReset(String email, String newPassword) async {
    _isLoading = true;
    notifyListeners();

    try {
      if (AppConstants.supabaseUrl == 'YOUR_SUPABASE_URL') {
        await Future.delayed(const Duration(seconds: 1)); // Mock network delay
        _isLoading = false;
        notifyListeners();
        return;
      }
      
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
}
