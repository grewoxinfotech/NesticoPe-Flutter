import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/builder/model/builder_model.dart';
import 'package:http/http.dart' as http;

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

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

      // ====== Handle brochure (document) properly ======
      if (documents != null) {
        final brochureObject = {
          "name": documents.path.split('/').last,
          "file": "brochureFile"
        };

        // Attach file with same key as mentioned inside brochureObject
        request.files.add(await http.MultipartFile.fromPath(
          'brochureFile', // this must match the key in "file"
          documents.path,
        ));

        // Replace the brochure field with an object instead of a flat string
        projectMap["brochure"] = brochureObject;
      }

      // ====== Add all other fields ======
      projectMap.forEach((key, value) {
        if (value == null) return;

        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      // ====== Attach Images ======
      if (images != null && images.isNotEmpty) {
        for (var i = 0; i < images.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'images[$i]',
            images[i].path,
          ));
        }
      }

      // ====== Attach Videos ======
      if (videos != null && videos.isNotEmpty) {
        for (var i = 0; i < videos.length; i++) {
          request.files.add(await http.MultipartFile.fromPath(
            'videos[$i]',
            videos[i].path,
          ));
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
      } return false;
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
