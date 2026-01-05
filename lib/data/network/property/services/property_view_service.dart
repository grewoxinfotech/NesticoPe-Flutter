import 'dart:convert';
import 'package:housing_flutter_app/data/network/property/models/viewed_item_model.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';

class PropertyViewService {
  final String baseUrl = ApiConstants.property;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch property view data and return a list of property IDs
  Future<ViewResponseModel?> fetchViewedPropertyIds(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/$userId/view');
      print('Fetching viewed properties from: $uri');

      final response = await http.get(uri, headers: await headers());
      print('Response status code: ${response.statusCode}');
      print('Response body viewed Property:  ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return ViewResponseModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to fetch property views: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching viewed properties: $e');
      return null;
    }
  }
}
