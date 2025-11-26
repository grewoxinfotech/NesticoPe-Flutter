import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';
import '../models/inquiry_model.dart';

class PropertyContactedService {
  final String baseUrl = ApiConstants.property;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch contacted property inquiries for a given user
  Future<List<Inquiry>> fetchContactedInquiries(String userId) async {
    try {
      final uri = Uri.parse('$baseUrl/$userId/inquiry');
      final response = await http.get(uri, headers: await headers());

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final inquiryResponse = InquiryResponse.fromJson(data);
          return inquiryResponse.data.items??[];
        } else {
          return [];
        }
      } else {
        throw Exception(
          'Failed to fetch contacted inquiries: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching contacted inquiries: $e');
      return [];
    }
  }

  /// Fetch only contacted property IDs for a given user
  Future<List<String>> fetchContactedPropertyIds(String userId) async {
    try {
      final inquiries = await fetchContactedInquiries(userId);
      return inquiries.map((e) => e.propertyId).toList();
    } catch (e) {
      print('Error fetching contacted property IDs: $e');
      return [];
    }
  }
}
