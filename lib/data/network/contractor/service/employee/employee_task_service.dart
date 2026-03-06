import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
import 'package:http/http.dart' as http;

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../../contractor/model/employee/employee_task_model.dart';

class EmployeeTaskService {
  EmployeeTaskService._();
  static final EmployeeTaskService instance = EmployeeTaskService._();

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<bool> createTask(Map<String, dynamic> payload) async {
    final uri = Uri.parse('${ApiConstants.employeeTask}');
    final response = await http.post(
      uri,
      headers: await headers(),
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonData = json.decode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: jsonData['message'] ?? 'Task created',
        contentType: ContentType.success,
      );
      return jsonData['success'] == true;
    }
    final jsonData = json.decode(response.body);
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Error',
      message: jsonData['message'] ?? 'Failed to create task',
      contentType: ContentType.failure,
    );
    return false;
  }

  Future<bool> updateTask(String id, Map<String, dynamic> payload) async {
    final uri = Uri.parse('${ApiConstants.employeeTask}/$id');
    final response = await http.put(
      uri,
      headers: await headers(),
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: jsonData['message'] ?? 'Task updated',
        contentType: ContentType.success,
      );
      return jsonData['success'] == true;
    }
    final jsonData = json.decode(response.body);
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Error',
      message: jsonData['message'] ?? 'Failed to update task',
      contentType: ContentType.failure,
    );
    return false;
  }

  Future<PaginationResponse<EmployeeTaskItem>> fetchTasks({
    int page = 1,
    int limit = 10,
    required String projectId,
  }) async {
    final uri = Uri.parse(ApiConstants.employeeTask).replace(
      queryParameters: {
        'page': page.toString(),
        'limit': limit.toString(),
        'projectId': projectId,
      },
    );

    debugPrint("Employee task uri: $uri");
    final response = await http.get(uri, headers: await headers());
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      debugPrint("Employee task response: $jsonData");
      return PaginationResponse<EmployeeTaskItem>.fromJson(
        jsonData,
        (json) => EmployeeTaskItem.fromJson(json),
      );
    }
    throw Exception("Failed to load contractor employees");
  }
}
