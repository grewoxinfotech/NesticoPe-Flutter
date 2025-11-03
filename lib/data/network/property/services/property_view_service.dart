import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';

class PropertyViewService {
  final String baseUrl = ApiConstants.property;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch property view data and return a list of property IDs
  Future<List<String>> fetchViewedPropertyIds(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/$userId/view');
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> properties = data['data']['property'] ?? [];
          return properties
              .map<String>((item) => item['propertyId'].toString())
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Failed to fetch property views: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching viewed properties: $e');
      return [];
    }
  }
}
