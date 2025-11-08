import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../../app/constants/api_constants.dart';
import '../model/reseller_fack_lead_model.dart';

class ResellerFakeLeadService {
  final String _baseUrl =
      ApiConstants.fackLead; // Example: https://api.yourapp.com

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch Reseller Fake Lead Stats
  Future<ResellerFakeLeadStatsResponse?> fetchFakeLeadStats(
    String resellerId,
  ) async {
    try {
      final url = Uri.parse("$_baseUrl/$resellerId/fake-stats");
      final response = await http.get(url, headers: await header());

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ResellerFakeLeadStatsResponse.fromJson(data);
      } else {
        print("❌ Failed to fetch stats: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Error fetching fake lead stats: $e");
    }
    return null;
  }
}
