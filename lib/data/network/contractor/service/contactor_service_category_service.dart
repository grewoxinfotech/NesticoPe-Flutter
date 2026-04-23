import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/app/widgets/snack_bar/custom_snackbar.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;

import '../model/contractot_service_model/contractor_service_category_model.dart';
class TopCategoryService {
  final String baseUrl = ApiConstants.contractorTopServiceCategory;

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch Top Categories ====================
  Future<List<TopCategoryItem>> fetchTopCategories({
    int? limit,
    String? city,
  }) async {
    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {
        if (limit != null) 'limit': limit.toString(),
       
      });
      // debugPrint("Fetching Top Categories from: $uri");

      final response = await http.get(
        uri,
        headers: await headers(),
      );

      // debugPrint("Top Categories API Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        final model = TopCategoryResponse.fromJson(jsonData);
        // AppLogger.structured('Top Categorise of full ',model.toJson() );


        return model.data?.items ?? [];
      } else {
        // debugPrint(
        //     "Failed to fetch top categories: ${response.statusCode}");
        // debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load top categories",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load top categories");
      }
    } catch (e) {
      // debugPrint("Exception in fetchTopCategories: $e");
      rethrow;
    }
  }

  ///==================== Get Single Category by ID ====================
  Future<TopCategoryItem?> getCategoryById(String id) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      // debugPrint("Get category by ID response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final model = TopCategoryResponse.fromJson(jsonData);
        return model.data?.items.first;
      } else {
        // debugPrint(
            // "Failed to get category by ID: ${response.statusCode}");
      }
    } catch (e) {
      // debugPrint("Get category by ID exception: $e");
    }
    return null;
  }
}
