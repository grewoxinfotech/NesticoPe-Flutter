import 'dart:convert';
import 'dart:developer';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:nesticope_app/modules/profile/model/seller_profile.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';
import 'package:http/http.dart' as http;
import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../model/top_seller_profile_model.dart';

class TopSellerService {
  final String baseUrl = ApiConstants.topSeller;
  final String baseBuilderUrl = ApiConstants.topBuilderProfile;
  final String userDataUrl = ApiConstants.user;
  final String userProfileUrl = ApiConstants.getUserProfile;

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<User> fetchUserModelById(String userId) async {
    try {
      final uri = Uri.parse('${ApiConstants.user}/$userId');

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return User.fromJson(data['data']);
      } else {
        throw Exception("Failed to load user model");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<ProfileSellerModel> fetchSellerProfileById(String sellerId) async {
    try {
      final uri = Uri.parse('$userProfileUrl/$sellerId');

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return ProfileSellerModel.fromJson(data['data']);
      } else {
        throw Exception("Failed to load seller profile");
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch Top Sellers with optional pagination
  Future<PaginationResponse<TopSeller>> fetchTopSellers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
      };

      final uri = Uri.parse(baseUrl).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse.fromJson(
          data,
          (json) => TopSeller.fromJson(json),
        );
      } else {
        throw Exception("Failed to load top sellers (${response.statusCode})");
      }
    } catch (e) {
      rethrow; // Let controller handle it
    }
  }

  Future<PaginationResponse<BuilderItem>> fetchTopBuilderProfiles({
    int page = 1,
    String limit = "10",
    String? city,
    String? createdBy,
    String? status,
  }) async {
    try {
      final queryParameters = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (city != null && city.isNotEmpty) 'city': city,
        if (createdBy != null && createdBy.isNotEmpty) 'created_by': createdBy,
        if (status != null && status.isNotEmpty) 'status': status,
      };

      final uri = Uri.parse(
        baseBuilderUrl,
      ).replace(queryParameters: queryParameters);

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (city != null) {
        } else {}
        return PaginationResponse.fromJson(
          data,
          (json) => BuilderItem.fromMap(json),
        );
      } else {
        throw Exception("Failed to load top sellers (${response.statusCode})");
      }
    } catch (e) {
      rethrow; // Let controller handle it
    }
  }
}
