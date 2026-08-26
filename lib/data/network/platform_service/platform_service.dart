import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/platform_service/platform_service_model.dart';
import 'package:http/http.dart' as http;

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';

class PlatformServicesService {
  final String baseUrl = ApiConstants.platformService; // Adjust endpoint

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch Platform Services (Paginated) ====================
  Future<PaginationResponse<PlatformServiceItem>> fetchServices({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<PlatformServiceItem>.fromJson(
          data,
          (json) => PlatformServiceItem.fromJson(json),
        );
      } else {
        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load platform services",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load platform services");
      }
    } catch (e) {
      rethrow;
    }
  }

  ///==================== Get Single Service by ID ====================
  Future<PlatformServiceItem?> getServiceById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PlatformServicesModel.fromJson(jsonData).data?.items?.first;
      } else {}
    } catch (e) {}
    return null;
  }
}
