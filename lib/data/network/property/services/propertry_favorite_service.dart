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

      final response = await http.get(url, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return FavoriteResponseModel.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<bool> addFavorite(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/$id/favorite"),
        headers: await headers(),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}
