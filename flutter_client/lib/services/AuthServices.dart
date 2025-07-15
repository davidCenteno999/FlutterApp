import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_client/models/dtos/TokenResponseDto.dart';
import 'package:flutter_client/models/dtos/LoginDto.dart';

import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

// DTOs (Data Transfer Objects)



class User {
  final String id;
  final String email;
  final String username;
  final String role;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });
}



class AuthService {
 

  // Singleton pattern to ensure a single instance of AuthService
  static final AuthService _instance = AuthService._internal();
  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

   final String baseUrl = 'https://localhost:7295/api/Auth';

   final _storage = FlutterSecureStorage();

   // Keys for secure storage
    static const _accessTokenKey = 'accessToken';
    static const _refreshTokenKey = 'refreshToken';
    static const _userId = 'userId';



  Future<http.Response> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    return response;
  }

  Future<bool> login(LoginDto loginDto) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': loginDto.email,
          'password': loginDto.password,
        }),
      );
      
      if (response.statusCode == 200) {
        final tokenResponse = TokenResponseDto.fromJson(jsonDecode(response.body));
        await storeTokens(tokenResponse);
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print('Login failed: $e');
        return false;
    }
  }

  Future<void> logout() async {

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userId);
  }

  // Auxiliary method to store tokens securely

  Future<void> storeTokens(TokenResponseDto tokenResponse) async {
    await _storage.write(key: _accessTokenKey, value: tokenResponse.accessToken);
    await _storage.write(key: _refreshTokenKey, value: tokenResponse.refreshToken);
    final decodedToken = JwtDecoder.decode(tokenResponse.accessToken);
    final userId = decodedToken['id'];
    await _storage.write(key: _userId, value: userId);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userId);
  }

  Future<String?> refreshAccessToken() async {
    final refreshToken = await getRefreshToken();
    final userId = await getUserId();
    if (refreshToken == null) {
      await logout();
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/refresh-token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'refreshToken': refreshToken, 'userId': userId}),
      );
      
      if (response.statusCode == 200) {
        final tokenResponse = TokenResponseDto.fromJson(jsonDecode(response.body));
        await storeTokens(tokenResponse);
        return tokenResponse.accessToken;
      } else {
        return null;
      }
    } catch (e) {
      print('Error refreshing access token: $e');
      await logout();
      return null;
    }
  }

  Future<User?> getCurrentUser() async {
    final userId = await getUserId();
    if (userId == null) {
      return null;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user?userId=$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ${await getAccessToken()}',
        },
       
      );

      if (response.statusCode == 200) {
        final userJson = jsonDecode(response.body);
        return User(
          id: userJson['id'],
          email: userJson['email'],
          username: userJson['username'],
          role: userJson['role'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print('Error fetching current user: $e');
      return null;
    }
  }

  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    if (accessToken == null) return false;

    if (JwtDecoder.isExpired(accessToken)) {
      // Token expirado → intentar refrescar
      final newToken = await refreshAccessToken();
      return newToken != null;
    }

    return true; // Token válido
  }


}




  