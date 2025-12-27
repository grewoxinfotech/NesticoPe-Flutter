import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';
import '../model/location_price_matrix_model.dart';

class MarketInsightService {
  MarketInsightService._();
  static final MarketInsightService instance = MarketInsightService._();

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Update this with your actual endpoint
  static String _marketInsightEndpoint = ApiConstants.locationPriceMetrics;

  /// Fetch Buy/Rent market insights
  Future<MarketInsightResponse> fetchMarketInsights({
    Map<String, String>? filters,
  }) async {
    final uri = Uri.parse(
      '$_marketInsightEndpoint',
    ).replace(queryParameters: {if (filters != null) ...filters});
    print("Matrix URI: $uri");

    final response = await http.get(uri, headers: await headers());

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print("Decoded data: $decoded");
      return MarketInsightResponse.fromJson(decoded);
    } else {
      throw Exception(
        'Failed to fetch market insights (${response.statusCode})',
      );
    }
  }
}
