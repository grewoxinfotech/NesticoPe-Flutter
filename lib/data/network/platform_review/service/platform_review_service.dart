import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../app/constants/api_constants.dart';
import '../../../../app/widgets/snack_bar/custom_snackbar.dart';
import '../model/platform_review_model.dart';

class ReviewService {
  final String baseUrl = ApiConstants.platformReview;
  final String baseUrlUser = ApiConstants.user;
  // Add this to your ApiConstants

  ///==================== Common Headers ====================
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  ///==================== Fetch Reviews (Paginated) ====================
  Future<ReviewResponse?> fetchReviews({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);
      debugPrint("Fetching Reviews from: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Reviews API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(" to fetch reviews: ${response.body}");
        return ReviewResponse.fromJson(data);
      } else {
        debugPrint("Failed to fetch reviews: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load reviews",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load reviews");
      }
    } catch (e) {
      debugPrint("Exception in fetchReviews: $e");
      rethrow;
    }
  }

  Future<UsersResponse?> fetchReviewsData({
    int page = 1,

    Map<String, String>? filters,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse('$baseUrlUser').replace(queryParameters: queryParameters);
      debugPrint("Fetching Reviews from: $uri");

      final response = await http.get(uri, headers: await headers());

      debugPrint("Reviews Data API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint(" ufhu to fetch reviews: ${response.body}");
        debugPrint(" hudsfusdhf to fetch reviews: ${UsersResponse.fromJson(data).data?.toMap()}");

        return UsersResponse.fromJson(data);
      } else {
        debugPrint("Failed to fetch reviews: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");

        CustomSnackBar.show(
          Get.overlayContext!,
          message: "Failed to load reviews",
          type: SnackBarType.error,
        );

        throw Exception("Failed to load reviews");
      }
    } catch (e) {
      debugPrint("Exception in fetchReviews: $e");
      rethrow;
    }
  }

}
