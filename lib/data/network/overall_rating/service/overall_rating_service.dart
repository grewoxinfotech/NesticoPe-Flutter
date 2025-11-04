import 'dart:convert';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../../../database/secure_storage_service.dart';
import '../model/overall_rating_model.dart';

class OverallRatingService {
  final String baseUrl = ApiConstants.overAllRating;

  /// 🧾 Get common headers with token
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// 🔹 Fetch overall rating for a specific property
  Future<PropertyReviewResponse?> fetchOverallRating(String propertyId) async {
    try {
      final uri = Uri.parse("$baseUrl/$propertyId/stats");
      print("Overall Rating URI: $uri");

      final response = await http.get(uri, headers: await headers());

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PropertyReviewResponse.fromJson(data);
      } else {
        print("⚠️ Failed to load overall rating: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception in fetchOverallRating: $e");
      return null;
    }
  }
}
