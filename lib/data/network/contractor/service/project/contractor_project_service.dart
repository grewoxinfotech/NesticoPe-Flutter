import 'dart:convert';
import 'dart:developer';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import 'package:http/http.dart' as http;
import 'package:housing_flutter_app/app/constants/api_constants.dart';

class ContractorProjectService {
  ContractorProjectService._();

  static ContractorProjectService contractorProjectService =
      ContractorProjectService._();
  final _baseUrl = ApiConstants.contractorProject;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ContractorProjectItem>> getContractorProjectData({
    int page = 1,
    Map<String, String>? filter,
    required String contractorId,
  }) async {
    try {
      final query = <String, String>{
        'page': page.toString(), // Convert int to String
        if (filter != null) ...filter,
        'created_by': contractorId,
      };
      final uri = Uri.parse(_baseUrl).replace(queryParameters: query);
      log('Contractor Project Url $uri');
      final response = await http.get(uri, headers: await header());
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaginationResponse<ContractorProjectItem>.fromJson(
          data,
          (json) =>
              ContractorProjectItem.fromJson(json as Map<String, dynamic>),
        );
      } else {
        print("Failed to load Project: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load project");
      }
    } catch (e) {
      print("Exception in project: $e");
      rethrow;
    }
  }

  Future<bool> updateStatus(Map<String, dynamic> status, String id) async {
    try {
      log("shgdsgasdsidsdwddhjuwd $status");
      final response = await http.put(
        Uri.parse('${ApiConstants.contractorProject}/$id'),
        headers: await header(),
        body: jsonEncode(status),
      );
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Data of Json ${data}");
        return data['success'];
      } else {
        print("Failed to load Update Project: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Update Project");
      }

      //2025-12-13T18:30:00.000Z
    } catch (e) {
      print("Exception in Update Project: $e");
      return false;
    }
  }
  Future<bool> updateProject(Map<String, dynamic> status, String id) async {
    try {
      log("shgdsgasdsidsdwddhjuwd $status");
      final response = await http.put(
        Uri.parse('${ApiConstants.contractorProject}/$id'),
        headers: await header(),
        body: jsonEncode(status),
      );
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Data of Json ${data}");
        return data['success'];
      } else {
        print("Failed to load Update Project: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Update Project");
      }

      //2025-12-13T18:30:00.000Z
    } catch (e) {
      print("Exception in Update Project: $e");
      return false;
    }
  }

  Future<bool> deletedProject(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.contractorProject}/$id'),
        headers: await header(),
      );
      print("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Data of Json ${data}");
        return data['success'];
      } else {
        print("Failed to load Delete Project: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Delete Project");
      }
    } catch (e) {
      print("Exception in Delete Project: $e");
      return false;
    }
  }
}
