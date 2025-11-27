import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/property_share/property_share_model.dart';
import 'package:http/http.dart' as http;
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

class PropertyShareService {
  final String baseUrl = ApiConstants.propertyShare;
  final String multiShare = ApiConstants.multiPropertyShare;
  var isSharing = false.obs;

  /// Get headers with token
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Add new property share and return share link
  Future<PropertyShareModel?> addPropertyShare(PropertyShareModel share) async {
    isSharing.value = true;
    try {
      final uri = Uri.parse(baseUrl);

      debugPrint("➡️ Creating Property Share: ${uri.toString()}");
      debugPrint("Payload: ${jsonEncode(share.toJson())}");

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(share.toJson()),
      );

      debugPrint("Property Share Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract share link safely
        final shareLink = data["data"];

        if (shareLink != null) {
          debugPrint("✅ Property shared successfully: $shareLink");
          return PropertyShareModel.fromJson(shareLink);
        } else {
          debugPrint("⚠️ Response did not contain a share link");
          return null;
        }
      } else {
        debugPrint("❌ Failed to create property share: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error creating property share: $e");
      return null;
    } finally {
      isSharing.value = false;
    }
  }

  Future<List<PropertyShareModel>?> getPropertyShareByPropertyAndReseller({
    required String propertyId,
    required String resellerId,
  }) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {"propertyId": propertyId, "resellerId": resellerId},
      );

      debugPrint("🔍 Fetching Property Share: ${uri.toString()}");

      final response = await http.get(uri, headers: await headers());
      debugPrint("📥 Property Share Fetch Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["story"] == true && data["data"] != null) {
          final List listData = data["data"]['items'];

          debugPrint(
            "✅ Property Shares fetched successfully (${listData.length})",
          );

          return listData.map((e) => PropertyShareModel.fromJson(e)).toList();
        } else {
          debugPrint("⚠️ No Property Share found for given IDs");
          return null;
        }
      } else {
        debugPrint("❌ Failed to fetch property share: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching property share: $e");
      return null;
    }
  }

  Future<MultiShareData?> addMultiPropertyShare(
    CreateMultiShareRequest shareRequest,
  ) async {
    isSharing.value = true;
    try {
      final uri = Uri.parse(multiShare); // ✅ Update endpoint as needed

      debugPrint("➡️ Creating Multi Property Share: ${uri.toString()}");
      debugPrint("Payload: ${jsonEncode(shareRequest.toJson())}");

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(shareRequest.toJson()),
      );

      debugPrint("Multi Property Share Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // ✅ Extract the share bundle URL safely
        final bundleUrl = data["data"];

        if (bundleUrl != null) {
          debugPrint("✅ Multi-property share created successfully: $bundleUrl");
          return MultiShareData.fromJson(bundleUrl);
        } else {
          debugPrint("⚠️ Response did not contain a bundle URL");
          return null;
        }
      } else {
        debugPrint(
          "❌ Failed to create multi-property share: ${response.statusCode}",
        );
        return null;
      }
    } catch (e) {
      debugPrint("⚠️ Error creating multi-property share: $e");
      return null;
    } finally {
      isSharing.value = false;
    }
  }

  Future<List<MultiShareData>?> getMultiPropertyShare() async {
    try {
      final uri = Uri.parse("$multiShare/my");
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonBody = jsonDecode(response.body);

        if (jsonBody['data'] != null && jsonBody['data'] is List) {
          return (jsonBody['data'] as List)
              .map((e) => MultiShareData.fromJson(e))
              .toList();
        }
      }

      return null;
    } catch (e) {
      print("⚠️ Error fetching property share: $e");
      return null;
    }
  }

  Future<bool> deletePropertyShare(String shareId) async {
    try {
      final Uri uri = Uri.parse("$baseUrl/$shareId");
      print("➡️ Deleting property share: ${uri.toString()}");
      final response = await http.delete(uri, headers: await headers());
      print("Property share deletion response: ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Error deleting property share: $e");
      return false;
    }
  }
}
