import 'dart:convert';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/network/review/model/review_model.dart';
import 'package:http/http.dart' as http;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../database/secure_storage_service.dart';

class ReviewService {
  final String baseUrl = ApiConstants.review;

  /// Headers with token
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<ReviewItem>> fetchReviews({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final uri = Uri.parse("$baseUrl").replace(queryParameters: queryParams);
      print("Review URI: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Review data: $data");

        return PaginationResponse<ReviewItem>.fromJson(
          data,
          (json) => ReviewItem.fromJson(json),
        );
      } else {
        print("Failed to load Review: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load Review");
      }
    } catch (e) {
      print("Exception in Review: $e");
      rethrow;
    }
  }

  /// 🆕 Create a new review
  Future<bool> createReview(ReviewItem reviewData) async {
    try {
      print('=============${reviewData.toJson()}');
      final uri = Uri.parse('$baseUrl');
      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(reviewData.toJson()),
      );

      if (response.statusCode == 201) {
        print('✅ Review created successfully');
        return true;
      } else {
        print('⚠️ Failed to create review: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error creating review: $e');
      return false;
    }
  }

  /// ✏️ Update an existing review
  Future<bool> updateReview(
    String reviewId,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final uri = Uri.parse('$baseUrl/reviews/$reviewId');
      final response = await http.put(
        uri,
        headers: await headers(),
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        print('✅ Review updated successfully');
        return true;
      } else {
        print('⚠️ Failed to update review: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error updating review: $e');
      return false;
    }
  }

  /// 🗑️ Delete a review
  Future<bool> deleteReview(String reviewId) async {
    try {
      final uri = Uri.parse('$baseUrl/reviews/$reviewId');
      final response = await http.delete(uri, headers: await headers());

      if (response.statusCode == 200) {
        print('✅ Review deleted successfully');
        return true;
      } else {
        print('⚠️ Failed to delete review: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error deleting review: $e');
      return false;
    }
  }

  /// 👍 Mark review as helpful
  Future<bool> markHelpful(String reviewId) async {
    try {
      final uri = Uri.parse('$baseUrl/reviews/$reviewId/helpful');
      final response = await http.post(uri);

      if (response.statusCode == 200) {
        print('✅ Marked as helpful');
        return true;
      } else {
        print('⚠️ Failed to mark helpful: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('❌ Error marking helpful: $e');
      return false;
    }
  }
}
