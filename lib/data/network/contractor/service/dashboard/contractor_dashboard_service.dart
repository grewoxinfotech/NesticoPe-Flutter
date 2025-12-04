import 'dart:convert';
import 'dart:developer';

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart'as http;

class ContractorDashboardService{
  ContractorDashboardService._();
  static ContractorDashboardService contractorDashboardService=ContractorDashboardService._();
  final _baseUrl=ApiConstants.contractorDashboard;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String,dynamic>> getContractorDashboard(
      String id, {
        int? leadsYear,
        int? inquiriesYear,
      }) async {
    try {
      log("Contractor $leadsYear   $inquiriesYear");
      final queryParams = <String, String>{};
      if (leadsYear != null) {
        queryParams['leadsYear'] = leadsYear.toString();
      }
      if (inquiriesYear != null) {
        queryParams['inquiriesYear'] = inquiriesYear.toString();
      }

      final uri = Uri.parse('$_baseUrl/$id').replace(queryParameters: queryParams);
log("Uri Contractor $uri");
      final response = await http.get(
        uri,
        headers: await header(),
      );

      if (response.statusCode == 200) {
        log("Json Response of Contractor ${response.body}");
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        print("HTTP Error: ${response.statusCode}");
        return {};
      }
    } catch (e, stack) {
      print("Exception in getContractorDashboard: $e");
      print(stack);
      return {};
    }
  }


}