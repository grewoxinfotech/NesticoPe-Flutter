import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contractor/model/contractor_project_model/contracto_project_model.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';

import '../../../../../utils/logger/app_logger.dart';

class ContractorProjectService {
  ContractorProjectService._();

  static ContractorProjectService contractorProjectService =
      ContractorProjectService._();
  final _baseUrl = ApiConstants.contractorProject;
  final _basePhotoUrl = ApiConstants.contractorProjectPhotos;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<bool> uploadBeforePhotos({
    required String projectId,
    required List<File> beforePhotos,
    required String key,
  }) async {
    try {
      final uri = Uri.parse('$_basePhotoUrl/upload');
      final request = http.MultipartRequest('POST', uri);

      // Attach headers
      final headers = await header();
      request.headers.addAll(headers);

      // Add fields
      request.fields['projectId'] = projectId;

      // Add multiple image files
      for (final photo in beforePhotos) {
        request.files.add(
          await http.MultipartFile.fromPath('$key', photo.path),
        );
      }

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(responseBody);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e, stack) {
      return false;
    }
  }

  /*  Future<bool> deletedProjectPhoto(Map<String, dynamic> status) async {
    try {
      final uri = Uri.parse('${ApiConstants.contractorProjectPhotos}/delete');
      log("🗑️ Deleting project photo with data: $status");

      final request = http.Request('DELETE', uri)
        ..headers.addAll(await header())
        ..body = jsonEncode(status);

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      log("📨 Delete photo response: $responseBody");

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        final data = jsonDecode(responseBody);
        return data['success'] == true;
      } else {
        log("❌ Failed to delete photo: ${streamedResponse.statusCode}");
        return false;
      }
    } catch (e, stack) {
      log("🚨 Exception in deletedProjectPhoto: $e\n$stack");
      return false;
    }
  }*/
  Future<bool> deletedProjectPhoto(Map<String, dynamic> status) async {
    try {
      final uri = Uri.parse('${ApiConstants.contractorProjectPhotos}/delete');

      final headers =
          await header()
            ..addAll({'Content-Type': 'application/json'});

      // 🚀 Direct delete request with body
      final response = await http.delete(
        uri,
        headers: headers,
        body: jsonEncode(status),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['success'] == true;
      } else {
        return false;
      }
    } catch (e, stack) {
      return false;
    }
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

      final response = await http.get(uri, headers: await header());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<ContractorProjectItem>.fromJson(
          data,
          (json) =>
              ContractorProjectItem.fromJson(json as Map<String, dynamic>),
        );
      } else {
        throw Exception("Failed to load project");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateStatus(Map<String, dynamic> status, String id) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.contractorProject}/$id'),
        headers: await header(),
        body: jsonEncode(status),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data['success'];
      } else {
        throw Exception("Failed to load Update Project");
      }

      //2025-12-13T18:30:00.000Z
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProject(Map<String, dynamic> status, String id) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConstants.contractorProject}/$id'),
        headers: await header(),
        body: jsonEncode(status),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data['success'];
      } else {
        throw Exception("Failed to load Update Project");
      }

      //2025-12-13T18:30:00.000Z
    } catch (e) {
      return false;
    }
  }

  Future<bool> deletedProject(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConstants.contractorProject}/$id'),
        headers: await header(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data['success'];
      } else {
        throw Exception("Failed to load Delete Project");
      }
    } catch (e) {
      return false;
    }
  }
}
