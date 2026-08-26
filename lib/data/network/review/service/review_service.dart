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

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse<ReviewItem>.fromJson(
          data,
          (json) => ReviewItem.fromJson(json),
        );
      } else {
        throw Exception("Failed to load Review");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// 🆕 Create a new review
  Future<bool> createReview(ReviewItem reviewData) async {
    try {
      final uri = Uri.parse('$baseUrl');
      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(reviewData.toCreatePayload()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
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
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// 🗑️ Delete a review
  Future<bool> deleteReview(String reviewId) async {
    try {
      final uri = Uri.parse('$baseUrl/reviews/$reviewId');
      final response = await http.delete(uri, headers: await headers());

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// 👍 Mark review as helpful
  Future<bool> markHelpful(String reviewId) async {
    try {
      final uri = Uri.parse('$baseUrl/$reviewId/helpful');
      final response = await http.post(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> getTheBuyerGiveReview(String id) async {
    try {
      final uri = Uri.parse("$getReviewCheck/$id");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          final hasReviewed = data["data"]?["hasReviewed"] ?? false;
          // log("✅ Buyer hasReviewed: $hasReviewed");
          return hasReviewed is bool ? hasReviewed : false;
        }
      }

      return false;
    } catch (e, st) {
      return false;
    }
  }

  Future<bool> addReviewForContractor(Map<String, dynamic> review) async {
    try {
      final uri = Uri.parse("$baseUrl");

      final response = await http.post(
        uri,
        headers: await headers(),
        body: jsonEncode(review),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data["success"] == true) {
          return true;
        }
      }

      return false;
    } catch (e, st) {
      return false;
    }
  }

  /// 👤 Fetch reviewer user details by user ID
}
