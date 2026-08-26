import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/property_share/property_share_model.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';

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

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(share.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Extract share link safely
        final shareLink = data["data"];

        if (shareLink != null) {
          return PropertyShareModel.fromJson(shareLink);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"] != null) {
          final List listData = data["data"]['items'];

          return listData.map((e) => PropertyShareModel.fromJson(e)).toList();
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<MultiShareData?> addMultiPropertyShare(
    CreateMultiShareRequest shareRequest,
  ) async {
    isSharing.value = true;
    try {
      final uri = Uri.parse(multiShare); // ✅ Update endpoint as needed

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(shareRequest.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // ✅ Extract the share bundle URL safely
        final bundleUrl = data["data"];

        if (bundleUrl != null) {
          return MultiShareData.fromJson(bundleUrl);
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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
      return null;
    }
  }

  Future<bool> deletePropertyShare(String shareId) async {
    try {
      final Uri uri = Uri.parse("$baseUrl/$shareId");

      final response = await http.delete(uri, headers: await headers());

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
