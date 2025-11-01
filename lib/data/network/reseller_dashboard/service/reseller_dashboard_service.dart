import 'dart:convert';

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ResellerDashboardService {
  ResellerDashboardService._();

  static ResellerDashboardService resellerDashboardService =
      ResellerDashboardService._();
  final String _baseUrl = ApiConstants.resellerDashboard;
  final String _userId = '';

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String, dynamic>?> fetchResellerDashboard(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$userId'),
        headers: await header(),
      );

      final decoded = jsonDecode(response.body);
      print('📦 Reseller Dashboard Raw Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      } else {
        print('⚠️ Reseller Dashboard Error Response: $decoded');
        return decoded;
      }
    } catch (e, stack) {
      print('❌ Exception in fetchResellerDashboard: $e');
      print(stack);
      return null;
    }
  }

}
