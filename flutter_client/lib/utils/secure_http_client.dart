// lib/utils/secure_http_client.dart


import 'package:http/http.dart' as http;
import 'package:flutter_client/services/AuthServices.dart';

class SecureHttpClient {
  final AuthService _authService = AuthService();

  Future<http.Response> get(Uri url) async {
    final accessToken = await _authService.getAccessToken();

    if (accessToken == null) {
      throw Exception('Not authenticated. No access token found.');
    }

    var response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 401) {
      // Token is expired, try to refresh
      final newAccessToken = await _authService.refreshAccessToken();

      if (newAccessToken != null) {
        // Retry the original request with the new token
        response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $newAccessToken',
            'Content-Type': 'application/json',
          },
        );
      } else {
        // Refresh failed, token is invalid or expired.
        // User must log in again.
        throw Exception('Session expired. Please log in again.');
      }
    }
    return response;
  }

  // You can implement other methods (post, put, delete) in a similar way
  Future<http.Response> post(Uri url, {Object? body}) async {
    final accessToken = await _authService.getAccessToken();

    if (accessToken == null) {
      throw Exception('Not authenticated. No access token found.');
    }

    var response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 401) {
      final newAccessToken = await _authService.refreshAccessToken();
      if (newAccessToken != null) {
        response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $newAccessToken',
            'Content-Type': 'application/json',
          },
          body: body,
        );
      } else {
        throw Exception('Session expired. Please log in again.');
      }
    }
    return response;
  }
}