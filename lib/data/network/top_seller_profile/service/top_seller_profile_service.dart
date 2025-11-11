import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/care/pagination/models/pagination_models.dart';
import '../../../../app/constants/api_constants.dart';
import '../model/top_seller_profile_model.dart';

class TopSellerService {
  final String baseUrl = ApiConstants.topSeller;

  /// Common headers
  static Future<Map<String, String>> headersWithoutToken() async {
    return await ApiConstants.getHeadersWithoutToken();
  }

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
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
      print("[TopSellerService] GET: $uri");

      final response = await http.get(uri, headers: await headers());
      print("[TopSellerService] Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return PaginationResponse.fromJson(
          data,
          (json) => TopSeller.fromJson(json),
        );
      } else {
        print("❌ [TopSellerService] Failed: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load top sellers (${response.statusCode})");
      }
    } catch (e) {
      print("🔥 [TopSellerService] Exception: $e");
      rethrow; // Let controller handle it
    }
  }
}
