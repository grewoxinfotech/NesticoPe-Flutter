import 'dart:convert';
import 'dart:developer';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/data/network/review/model/review_model.dart';
import 'package:http/http.dart' as http;

import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../database/secure_storage_service.dart';

class ReviewUserService {
  final String baseUrl = ApiConstants.review;
  final String getReviewCheck = ApiConstants.myContractorProfileReview;

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
      print("Review URIsdfcdsh: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Review data:  $data");

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
      print('=============${reviewData.toCreatePayload()}');
      final uri = Uri.parse('$baseUrl');
      final response = await http.post(
        
        uri,
        headers: await headers(),
        body: jsonEncode(reviewData.toCreatePayload()),
      );
      print('=============${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      log("Print second number $reviewId");
      final uri = Uri.parse('$baseUrl/$reviewId/helpful');
      final response = await http.post(uri,headers: await headers());
      log("Print second change  $uri");
      if (response.statusCode == 200||response.statusCode == 201) {
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

  Future<bool> getTheBuyerGiveReview(String id) async {
    try {
      final uri = Uri.parse("$getReviewCheck/$id");
      log("🔹 Checking review status: $uri");

      final response = await http.get(uri, headers: await headers());

      log("🔹 Review Check Response: ${response.statusCode}");
      log("🔹 Review Check Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          final hasReviewed = data["data"]?["hasReviewed"] ?? false;
          log("✅ Buyer hasReviewed: $hasReviewed");
          return hasReviewed is bool ? hasReviewed : false;
        }
      }

      log("⚠️ Unexpected response or missing data");
      return false;
    } catch (e, st) {
      log("❌ Error in getTheBuyerGiveReview: $e\n$st");
      return false;
    }
  }

  Future<bool> addReviewForContractor(Map<String, dynamic> review) async {
    try {
      final uri = Uri.parse("$baseUrl");
      log("🔹 Checking review status: $uri");

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(review),
      );

      log("🔹 Review Check Response: ${response.statusCode}");
      log("🔹 Review Check Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          return true;
        }
      }

      log("⚠️ Unexpected response or missing data");
      return false;
    } catch (e, st) {
      log("❌ Error in getTheBuyerGiveReview: $e\n$st");
      return false;
    }
  }

  /// 👤 Fetch reviewer user details by user ID
}
