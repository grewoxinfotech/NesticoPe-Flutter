import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';
import '../models/favorite_item_model.dart';

class PropertyFavoriteService {
  final String baseUrl = ApiConstants.property;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch user's favorite list (both project/property)
  Future<FavoriteResponseModel?> getFavorite(String id) async {
    try {
      final url = Uri.parse("$baseUrl/$id/favorite");
      print("🔹 Fetching favorites: $url");

      final response = await http.get(url, headers: await headers());

      print("🔹 Response Status: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return FavoriteResponseModel.fromJson(jsonResponse);
      } else {
        print("❌ Failed to fetch favorites: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Exception in getFavorite: $e");
      return null;
    }
  }

  Future<bool> addFavorite(String id) async {
    try {
      print("baseUrl : ${baseUrl}/${id}");
      final response = await http.post(
        Uri.parse("$baseUrl/$id/favorite"),
        headers: await headers(),
      );
      print("response : --------------------  ${response.body}");
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Delete property exception: $e");
      return false;
    }
  }
}
