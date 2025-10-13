import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:http/http.dart' as http;

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:http_parser/http_parser.dart';

class BuilderService {
  final String baseUrl = ApiConstants.builderProject; // Adjust endpoint

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Create Project under a Builder ====================
  Future<bool> createProject({
    required ProjectModel projectData,
    List<File>? images,
    List<File>? videos,
    File? documents,
  }) async {
    try {
      final uri = Uri.parse(baseUrl);
      debugPrint("📤 Creating project at: $uri");

      final headerMap = await headers();

      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        ...headerMap,
        'Content-Type': 'multipart/form-data',
      });

      // Convert model to Map
      final projectMap = projectData.toJson();

      if (documents != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'brochure',
            documents.path,
            contentType: MediaType('application', 'pdf'),
          ),
        );
      }

      // ====== Add all other fields ======
      projectMap.forEach((key, value) {
        if (value == null) return;

        if (key == 'brochure') return;

        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // ==== Attach Project Images ====
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'project_images',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }
      //
      // ==== Attach Project Videos ====
      if (videos != null && videos.isNotEmpty) {
        for (var video in videos) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'project_videos',
              video.path,
              contentType: MediaType('video', 'mp4'),
            ),
          );
        }
      }
      debugPrint("🧾 Multipart fields: ${request.fields}");
      debugPrint("📎 Attached files: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Create Project Response: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Project created successfully",
          type: SnackBarType.success,
        );
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("❌ Create project exception: $e");
      CustomSnackBar.show(
        Get.overlayContext!,
        message: "Error while creating project",
        type: SnackBarType.error,
      );
      return false;
    }
  }
}
