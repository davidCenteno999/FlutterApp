

import 'dart:convert';

import 'package:flutter_client/models/taskTypeDto/getTaskTypeDto.dart';
import 'package:flutter_client/services/AuthServices.dart';
import 'package:http/http.dart' as http;

class Taskservices {

  static final Taskservices _instance = Taskservices._internal();
  factory Taskservices() {
    return _instance;
  }
  Taskservices._internal();

  

  final String baseUrl = 'http://192.168.100.53:5289/api/TaskType';
  
  Future<Gettasktypedto> fetchTaskTypes() async {
    /*final userId  = await _authService.getUserId();
    if (userId == null) {
      throw Exception('User not logged in');
    }*/

    try {
      final response = await http.get(
        Uri.parse(baseUrl)
      );
      print(response);
      if (response.statusCode == 200) {
        final data = Gettasktypedto.fromJson(jsonDecode(response.body));
        return data;
      } else {
        print("Failed to load task types: ${response.statusCode}");
        throw Exception('Failed to load task types: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load task types: $e');
    }

    
  }
}
