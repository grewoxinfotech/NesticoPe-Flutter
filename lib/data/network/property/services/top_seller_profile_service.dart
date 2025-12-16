import 'dart:convert';

import 'package:housing_flutter_app/modules/profile/model/seller_profile.dart';
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
      print("uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("data: $data");

        return ProfileSellerModel.fromJson(data['data']);
      } else {
        print("Failed to load seller profile: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load seller profile");
      }
    } catch (e) {
      print("Exception in fetchSellerProfileById: $e");
      rethrow;
    }
  }

  Future<User> fetchUserModelById(String userId) async {
    try {
      final uri = Uri.parse('${ApiConstants.user}/$userId');
      print("uri: $uri");
      final response = await http.get(uri, headers: await headers());

      print("response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("USER DATA: $data");

        return User.fromJson(data['data']);
      } else {
        print("Failed to load user model: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load user model");
      }
    } catch (e) {
      print("Exception in fetchUserModelById: $e");
      rethrow;
    }
  }
}
