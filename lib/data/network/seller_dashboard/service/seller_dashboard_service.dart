import 'dart:convert';
import 'dart:developer';

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/confige/helper/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class SellerDashBoardService {
  SellerDashBoardService._();

  static final SellerDashBoardService sellerDashBoardService =
      SellerDashBoardService._();
  final _baseUrl = ApiConstants.getSellerDashboard;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String, dynamic>?> getSellerDashBoard(String id,{   int? leadsYear,}) async {
    try {
      final queryParams = <String, String>{};
      if (leadsYear != null) {
        queryParams['year'] = leadsYear.toString();
      }
      final uri=Uri.parse('$_baseUrl/$id').replace(queryParameters: queryParams);
      log("Seller Dss $uri");
      final response = await http.get(
        uri,
        headers: await header(),
      );
      final decoded = jsonDecode(response.body);
      print('📦 Seller Dashboard Raw Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      } else {
        print('⚠️ Seller Dashboard Error Response: $decoded');
        return decoded;
      }
    } catch (e, stack) {
      print('❌ Exception in SellerDashboard: $e');
      print(stack);
      return null;
    }
  }
}
