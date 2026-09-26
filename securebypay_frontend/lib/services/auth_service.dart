import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiConfig {

  static const String _override = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_override.isNotEmpty) return _override;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:4000';
    }
    return 'http://localhost:4000';
  }
}

class AuthResult {
  final bool success;
  final String message;
  final AppUser? user;
  final String? token;
  final String? resetToken;
  final Map<String, String>? fieldErrors;

  AuthResult({
    required this.success,
    required this.message,
    this.user,
    this.token,
    this.resetToken,
    this.fieldErrors,
  });
}

class AuthService {
  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}/api/auth$path');


  AuthResult _connectionFailure(Object e) {
    final base = 'Could not reach the server at ${ApiConfig.baseUrl}. '
        'Is the backend running and reachable from this device?';
    return AuthResult(
      success: false,
      message: kDebugMode ? '$base\n($e)' : base,
    );
  }

  Future<AuthResult> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      final res = await http.post(
        _url('/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );
      return _parseAuthResponse(res);
    } catch (e) {
      return _connectionFailure(e);
    }
  }

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        _url('/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      return _parseAuthResponse(res);
    } catch (e) {
      return _connectionFailure(e);
    }
  }

  Future<AuthResult> forgotPassword({required String email}) async {
    try {
      final res = await http.post(
        _url('/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );
      return _parseAuthResponse(res);
    } catch (e) {
      return _connectionFailure(e);
    }
  }

  Future<AuthResult> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    try {
      final res = await http.post(
        _url('/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'token': token,
          'password': newPassword,
        }),
      );
      return _parseAuthResponse(res);
    } catch (e) {
      return _connectionFailure(e);
    }
  }

  /// Uploads (or replaces) the current user's profile picture.
  /// [imageDataUri] must be a base64 data URI, e.g.
  /// "data:image/jpeg;base64,....." — see AuthState.uploadAvatar for how
  /// the Flutter side builds one from a picked file.
  Future<AuthResult> uploadAvatar({
    required String token,
    required String imageDataUri,
  }) async {
    try {
      final res = await http.post(
        _url('/me/avatar'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'image': imageDataUri}),
      );
      return _parseAuthResponse(res);
    } catch (e) {
      return _connectionFailure(e);
    }
  }

  Future<AppUser?> fetchMe(String token) async {
    try {
      final res = await http.get(
        _url('/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body) as Map<String, dynamic>;
        return AppUser.fromJson(body['data']['user'] as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  AuthResult _parseAuthResponse(http.Response res) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(res.body) as Map<String, dynamic>;
    } catch (_) {
      return AuthResult(success: false, message: 'Unexpected server response');
    }

    final bool success = body['success'] == true;
    final String message = body['message']?.toString() ?? '';

    if (!success) {
      Map<String, String>? fieldErrors;
      if (body['errors'] is List) {
        fieldErrors = {};
        for (final e in (body['errors'] as List)) {
          final field = e['field']?.toString();
          final msg = e['message']?.toString();
          if (field != null && msg != null) fieldErrors[field] = msg;
        }
      }
      return AuthResult(
        success: false,
        message: message.isNotEmpty ? message : 'Something went wrong',
        fieldErrors: fieldErrors,
      );
    }

    final data = body['data'] as Map<String, dynamic>?;
    final user = data?['user'] != null
        ? AppUser.fromJson(data!['user'] as Map<String, dynamic>)
        : null;
    final token = data?['token']?.toString();
    final resetToken = data?['resetToken']?.toString();

    return AuthResult(
      success: true,
      message: message,
      user: user,
      token: token,
      resetToken: resetToken,
    );
  }
}