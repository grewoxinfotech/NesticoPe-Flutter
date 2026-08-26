import 'dart:convert';

import 'package:nesticope_app/modules/profile/model/seller_profile.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';
import '../../auth/model/user_model.dart';

class TopSellerProfileService {
  final String baseUrl = ApiConstants.getProfile;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<ProfileSellerModel> fetchSellerProfileById(String sellerId) async {
    try {
      final uri = Uri.parse('$baseUrl/$sellerId');

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
}
