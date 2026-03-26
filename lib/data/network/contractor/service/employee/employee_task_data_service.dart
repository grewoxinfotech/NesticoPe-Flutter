import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/network/contractor/model/employee/employee_task_model.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

class EmployeeTaskDataService {
  EmployeeTaskDataService._();
  static final instance = EmployeeTaskDataService._();
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }
  Future<PaginationResponse<EmployeeTaskItem>> fetchTasks({
    required String employeeId,
    int page = 1,
    int limit = 10,
  }) async {
    final uri = Uri.parse(ApiConstants.employeeTask).replace(queryParameters: {
      'page': page.toString(),
      'limit': limit.toString(),
      'employeeId': employeeId,
    });
  
    // Defensive header format: ensure "Bearer <token>"
    // if (headers['Authorization'] != null &&
    //     !headers['Authorization']!.startsWith('Bearer ')) {
    //   headers['Authorization'] = 'Bearer ${headers['Authorization']}';
    // }
    final res = await http.get(uri, headers: await headers());
    debugPrint('EmployeeTaskDataService GET $uri => ${res.statusCode}');
    debugPrint(res.body);
    if (res.statusCode == 200) {
      debugPrint("Employee task response: ${res.body}");
      final jsonMap = json.decode(res.body);
      return PaginationResponse<EmployeeTaskItem>.fromJson(
        jsonMap,
        (m) => EmployeeTaskItem.fromJson(m),
      );
    }
    throw Exception(
        'Employee tasks fetch failed: ${res.statusCode} ${res.reasonPhrase}');
  }
}
