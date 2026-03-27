import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

import '../../model/contractor_project_model/contractor_project_milestone_model.dart';

class ContractorProjectMilestoneService {
  ContractorProjectMilestoneService._();

  static ContractorProjectMilestoneService projectMilestoneService =
      ContractorProjectMilestoneService._();

  final _baseUrl = ApiConstants.contractorProjectMilestone;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  /// 🔹 Get Project Milestones (Paginated)
  Future<PaginationResponse<ProjectMilestone>> getProjectMilestones({
    int page = 1,
    bool fetchAll = false,
    Map<String, String>? filter,
    required String projectId,
  }) async {
    try {
      final fetchType = fetchAll ? 'limit' : 'page';
      final fetch = fetchAll ? 'all' : page.toString();
      final query = <String, String>{
        fetchType: fetch,
        if (filter != null) ...filter,
        'projectId': projectId,
      };

      final uri = Uri.parse(_baseUrl).replace(queryParameters: query);
      log('Project Milestone Url => $uri');

      final response = await http.get(uri, headers: await header());
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PaginationResponse<ProjectMilestone>.fromJson(
          data,
          (json) => ProjectMilestone.fromJson(json as Map<String, dynamic>),
        );
      } else {
        log("Failed to load Project Milestones: ${response.statusCode}");
        log("Response body: ${response.body}");
        throw Exception("Failed to load project milestones");
      }
    } catch (e) {
      log("Exception in getProjectMilestones: $e");
      rethrow;
    }
  }

  /// 🔹 Create Project Milestone
  Future<bool> createMilestone(ProjectMilestone payload) async {
    try {
      log("Create Milestone Payload => ${payload.toJson()}");

      final response = await http.post(
        Uri.parse('$_baseUrl'),
        headers: await header(),
        body: jsonEncode(payload.toJson()),
      );

      log("Response body: ${response.body}");
      log("Response body: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        log("Response body: ${response.body}");
        return false;
      }
    } catch (e) {
      log("Exception in createMilestone: $e");
      return false;
    }
  }

  /// 🔹 Update Milestone Status / Amount / Work Status
  Future<bool> updateMilestone(

    ProjectMilestone payload,
    String projectId,
    String milestoneId,
  ) async {
    try {
      log("Update Milestone Payload => ${payload.toJson()}");
      final uri = Uri.parse('$_baseUrl/$milestoneId');
      print('Update Milestone URL: $uri  --- $projectId');
      final response = await http.put(
        uri,
        headers: await header(),
        body: jsonEncode(payload.toJson()),
      );

      log("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Update Response => $data");
        return data['success'] ?? false;
      } else {
        log("Failed to update milestone: ${response.statusCode}");
        log("Response body: ${response.body}");
        throw Exception("Failed to update milestone");
      }
    } catch (e) {
      log("Exception in updateMilestone: $e");
      return false;
    }
  }

  /// 🔹 Delete Project Milestone
  Future<bool> deleteMilestone(String milestoneId) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$milestoneId'),
        headers: await header(),
      );

      log("Response body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        log("Delete Response => $data");
        return data['success'] ?? false;
      } else {
        log("Failed to delete milestone: ${response.statusCode}");
        log("Response body: ${response.body}");
        throw Exception("Failed to delete milestone");
      }
    } catch (e) {
      log("Exception in deleteMilestone: $e");
      return false;
    }
  }
}
