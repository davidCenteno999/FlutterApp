// lib/screens/protected_data_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_client/utils/secure_http_client.dart';


class ProtectedDataScreen extends StatefulWidget {
  const ProtectedDataScreen({super.key});

  @override
  _ProtectedDataScreenState createState() => _ProtectedDataScreenState();
}

class _ProtectedDataScreenState extends State<ProtectedDataScreen> {
  final SecureHttpClient _httpClient = SecureHttpClient();
  String _data = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchProtectedData();
  }

  Future<void> _fetchProtectedData() async {
    try {
      final response = await _httpClient.get(
        Uri.parse('https://localhost:7295/api/Auth/admin'),
      );
      
      if (response.statusCode == 200) {
        setState(() {
          _data = response.body;
        });
      } else {
        setState(() {
          _data = 'Failed to fetch data: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _data = 'Error: $e';
      });
      // Handle session expiration here, e.g., redirect to login screen
      if (e.toString().contains('Session expired')) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Protected Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(_data),
        ),
      ),
    );
  }
}