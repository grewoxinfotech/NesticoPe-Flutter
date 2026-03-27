import 'dart:convert';
import 'dart:developer';

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class ContractorCompareService {
  ContractorCompareService._();

  static ContractorCompareService service = ContractorCompareService._();
  final _baseUrl = ApiConstants.contractorCompare;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String,dynamic>> getContractorById(String id) async {
    try {
      log("Compare Contractor $id");
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: await header(),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        // avoid logging full payload to reduce log spam and potential jank
        final data=jsonDecode(response.body);
        return data;
      }
      return {};
    } catch (e) {
      return {};
    }
  }
}
