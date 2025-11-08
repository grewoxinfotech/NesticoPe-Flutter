import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/reseller/reseller_success_stories/reseller_success_stories_model.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

class ResellerSuccessStoryService {
  final String baseUrl = ApiConstants.resellerSuccessStory;

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch Success Stories ====================
  Future<PaginationResponse<ResellerSuccessItem>> fetchSuccessStories({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      debugPrint("📡 Fetching Reseller Success Stories from: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("✅ Success Stories API Response: $data");

        return PaginationResponse<ResellerSuccessItem>.fromJson(
          data,
          (json) => ResellerSuccessItem.fromJson(json),
        );
      } else {
        debugPrint("❌ Failed to load success stories: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        throw Exception("Failed to load success stories");
      }
    } catch (e) {
      debugPrint("⚠️ Exception in fetchSuccessStories: $e");
      rethrow;
    }
  }

  ///==================== Create Success Story ====================
  Future<bool> createSuccessStory({
    required ResellerSuccessItem storyData,
    File? image,
  }) async {
    try {
      final uri = Uri.parse(baseUrl);
      debugPrint("📤 Creating Success Story at: $uri");

      final headerMap = await headers();
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        ...headerMap,
        'Content-Type': 'multipart/form-data',
      });

      // Convert model to Map
      final storyMap = storyData.toJson();

      // ====== Add image file (if provided) ======
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      }

      // ====== Add all other fields ======
      storyMap.forEach((key, value) {
        if (value == null) return;
        if (key == 'image') return; // handled above
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      debugPrint("🧾 Multipart fields: ${request.fields}");
      debugPrint("📎 Attached files: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Create Success Story Response: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Success story created successfully",
          type: SnackBarType.success,
        );
        return true;
      }

      CustomSnackBar.show(
        Get.overlayContext!,
        message: "Failed to create success story",
        type: SnackBarType.error,
      );
      return false;
    } catch (e) {
      debugPrint("❌ Create Success Story Exception: $e");
      CustomSnackBar.show(
        Get.overlayContext!,
        message: "Error while creating success story",
        type: SnackBarType.error,
      );
      return false;
    }
  }

  ///==================== Update Success Story ====================
  Future<bool> updateSuccessStory({
    required String storyId,
    required ResellerSuccessItem storyData,
    File? image,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$storyId');
      debugPrint("📤 Updating Success Story at: $uri");

      final headerMap = await headers();
      var request = http.MultipartRequest('PUT', uri);

      request.headers.addAll({
        ...headerMap,
        'Content-Type': 'multipart/form-data',
      });

      final storyMap = storyData.toJson();

      // ===== Attach image if local file =====
      if (image != null) {
        final isNetwork = Uri.tryParse(image.path)?.isAbsolute ?? false;
        if (!isNetwork) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'image',
              image.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
        }
      }

      // ===== Attach fields =====
      storyMap.forEach((key, value) {
        if (value == null) return;
        if (key == 'image') return;
        if (value is Map || value is List) {
          request.fields[key] = jsonEncode(value);
        } else {
          request.fields[key] = value.toString();
        }
      });

      debugPrint("🧾 Multipart fields: ${request.fields}");
      debugPrint("📎 Attached files: ${request.files.length}");

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint("📩 Update Success Story Response: ${response.statusCode}");
      debugPrint("📄 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Success story updated successfully",
          type: SnackBarType.success,
        );
        return true;
      }

      CustomSnackBar.show(
        Get.overlayContext!,
        message: "Failed to update success story",
        type: SnackBarType.error,
      );
      return false;
    } catch (e) {
      debugPrint("❌ Update Success Story Exception: $e");
      CustomSnackBar.show(
        Get.overlayContext!,
        message: "Error while updating success story",
        type: SnackBarType.error,
      );
      return false;
    }
  }
}
