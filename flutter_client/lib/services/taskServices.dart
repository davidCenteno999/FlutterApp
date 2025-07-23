

import 'dart:convert';

import 'package:flutter_client/models/taskDto/createTaskDto.dart';
import 'package:flutter_client/models/taskDto/getTaskDto.dart';
import 'package:flutter_client/models/taskTypeDto/getTaskTypeDto.dart';
import 'package:flutter_client/services/AuthServices.dart';
import 'package:http/http.dart' as http;

class Taskservices {

  static final Taskservices _instance = Taskservices._internal();
  factory Taskservices() {
    return _instance;
  }
  Taskservices._internal();

  
  final AuthService _authService = AuthService();

  final String baseUrl = 'https://localhost:7295/api/TaskType';
  final String taskUrl = 'https://localhost:7295/api/TaskInformation';
  
  Future<Gettasktypedto> fetchTaskTypes() async {
    /*
    if (userId == null) {
      throw Exception('User not logged in');
    }*/

    try {
      final response = await http.get(
        Uri.parse(baseUrl)
      );
      print(response.body);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = Gettasktypedto.fromJson(decoded);
        print(data);
        return data;

      } else {
        print("Failed to load task types: ${response.statusCode}");
        throw Exception('Failed to load task types: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to load task types: $e');
    }

    
  }

  Future<bool> createTask(Createtaskdto task) async {
    final accessToken = await _authService.getAccessToken();
    if (accessToken == null) {
      throw Exception('User not logged in');
    }
    print(accessToken);
    try {
      final response = await http.post(
        Uri.parse(taskUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(task.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print("Failed to create task: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  Future<GetTask> fetchTaskById(String taskId) async {
   

    try {
      final response = await http.get(
        Uri.parse('$taskUrl/$taskId'),
        
      );
      print(response.body);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return GetTask.fromJson(decoded);
      } else {
        print("Failed to fetch task: ${response.statusCode}");
        throw Exception('Failed to fetch task: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch task: $e');
    }
  }
}