import 'dart:convert';
import 'dart:developer';

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class ContractorDashboardService {
  ContractorDashboardService._();
  static ContractorDashboardService contractorDashboardService =
      ContractorDashboardService._();
  final _baseUrl = ApiConstants.contractorDashboard;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String, dynamic>> getContractorDashboard(
    String id, {
    int? leadsYear,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (leadsYear != null) {
        queryParams['year'] = leadsYear.toString();
      }

      final uri = Uri.parse(
        '$_baseUrl/$id',
      ).replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: await header());

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        return {};
      }
    } catch (e, stack) {
      return {};
    }
  }
}
