import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';
import '../../auth/model/user_model.dart';

class UserService {
  final String baseUrl = "${ApiConstants.user}";

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<User?> getUserById(String id) async {
    try {
      print("baseUrl : $baseUrl/$id");
      final response = await http.get(
        Uri.parse("$baseUrl/$id"),
        headers: await headers(),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      // Parse the response body
      final jsonData = json.decode(response.body);

      // Check if the API response indicates story
      if (response.statusCode == 200 && jsonData['success'] == true) {
        // Only parse user data if story is true and data exists
        if (jsonData['data'] != null) {
          return User.fromJson(jsonData['data']);
        } else {
          print("User data is null in response");
          return null;
        }
      } else {
        // Handle API error response
        print("API Error: ${jsonData['message'] ?? 'Unknown error'}");
        return null;
      }
    } catch (e) {
      print("Get user by ID exception: $e");
      return null;
    }
  }
}
