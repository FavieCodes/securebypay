import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';


class AuthState extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? user;
  String? token;
  bool isLoading = false;
  String? errorMessage;
  Map<String, String>? fieldErrors;

  bool get isLoggedIn => token != null && user != null;

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedToken = prefs.getString('auth_token');
    if (savedToken == null) return;

    final fetchedUser = await _authService.fetchMe(savedToken);
    if (fetchedUser != null) {
      token = savedToken;
      user = fetchedUser;
      notifyListeners();
    } else {
      await prefs.remove('auth_token');
    }
  }

  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    _setLoading(true);
    final result = await _authService.signup(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
    );
    // Deliberately NOT routed through _handleResult: signing up should not
    // also log the user in. _Root watches this state and swaps straight to
    // the dashboard the moment token/user are set, so storing them here
    // would skip the login screen entirely regardless of where
    // SignupScreen tries to navigate afterwards.
    isLoading = false;
    if (result.success) {
      errorMessage = null;
      fieldErrors = null;
      notifyListeners();
      return true;
    }
    errorMessage = result.message;
    fieldErrors = result.fieldErrors;
    notifyListeners();
    return false;
  }

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    final result = await _authService.login(email: email, password: password);
    return _handleResult(result);
  }

  Future<AuthResult> forgotPassword({required String email}) async {
    _setLoading(true);
    final result = await _authService.forgotPassword(email: email);
    isLoading = false;
    if (!result.success) {
      errorMessage = result.message;
      fieldErrors = result.fieldErrors;
    } else {
      errorMessage = null;
      fieldErrors = null;
    }
    notifyListeners();
    return result;
  }

  Future<AuthResult> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    _setLoading(true);
    final result = await _authService.resetPassword(
      email: email,
      token: token,
      newPassword: newPassword,
    );
    isLoading = false;
    if (!result.success) {
      errorMessage = result.message;
      fieldErrors = result.fieldErrors;
    } else {
      errorMessage = null;
      fieldErrors = null;
    }
    notifyListeners();
    return result;
  }


  /// Uploads a new profile picture and swaps [user] in place on success,
  /// so every widget watching AuthState (the sidebar avatar included)
  /// picks up the new photo immediately.
  Future<bool> uploadAvatar(String imageDataUri) async {
    if (token == null) return false;
    final result = await _authService.uploadAvatar(
      token: token!,
      imageDataUri: imageDataUri,
    );
    if (result.success && result.user != null) {
      user = result.user;
      errorMessage = null;
      notifyListeners();
      return true;
    }
    errorMessage = result.message;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    user = null;
    token = null;
    notifyListeners();
  }

  Future<bool> _handleResult(AuthResult result) async {
    isLoading = false;
    if (result.success && result.user != null && result.token != null) {
      user = result.user;
      token = result.token;
      errorMessage = null;
      fieldErrors = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', result.token!);
      notifyListeners();
      return true;
    } else {
      errorMessage = result.message;
      fieldErrors = result.fieldErrors;
      notifyListeners();
      return false;
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}