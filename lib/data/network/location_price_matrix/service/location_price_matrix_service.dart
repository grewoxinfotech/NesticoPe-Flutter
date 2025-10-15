import 'dart:convert';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

import '../model/location_price_matrix_model.dart';

class LocationPriceMatrixService {
  final String baseUrl = ApiConstants.locationPriceMetrics;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch property data (Buy + Rent)
  Future<LocationPriceMatrixModel?> fetchPropertyData() async {
    try {
      final uri = Uri.parse('$baseUrl'); // <-- your endpoint here
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200) {
        final jsonMap = jsonDecode(response.body);
        return LocationPriceMatrixModel.fromJson(jsonMap);
      } else {
        print('❌ Failed to load property data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('⚠️ Error fetching property data: $e');
      return null;
    }
  }
}
