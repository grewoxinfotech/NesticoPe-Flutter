import 'dart:convert';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:http/http.dart' as http;

class RecommendedPropertyService {
  final String baseUrl = "${ApiConstants.propertyRecommend}";

  /// Headers with token
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch recommended properties
  ///
  /// Example filters:
  /// ```dart
  /// {
  ///   "city": "Mumbai",
  ///   "budget_min": "500000",
  ///   "budget_max": "2000000",
  ///   "propertyType": "Apartment"
  /// }
  /// ```
  Future<PaginationResponse<Items>> fetchRecommendedProperties({
    int page = 1,
    Map<String, String>? filters,
  }) async {
    try {
      final queryParams = {
        'page': page.toString(),
        if (filters != null) ...filters,
      };

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? "";

      final uri = Uri.parse(
        "$baseUrl/$userId",
      ).replace(queryParameters: queryParams);
      print("Recommended Property URI: $uri");

      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Recommended properties data: $data");

        return PaginationResponse<Items>.fromJson(
          data,
          (json) => Items.fromJson(json),
        );
      } else {
        print("Failed to load recommended properties: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load recommended properties");
      }
    } catch (e) {
      print("Exception in fetchRecommendedProperties: $e");
      rethrow;
    }
  }
}
