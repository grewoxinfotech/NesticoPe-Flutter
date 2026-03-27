import 'dart:convert';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:nesticope_app/confige/helper/api_helper.dart';
import 'package:http/http.dart' as http;

import '../model/contractor_quotation/contractor_referral_model.dart';

class ContractorReferralService {
  final String userId;

  ContractorReferralService({required this.userId});

  static final String _baseUrl = ApiConstants.referral;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<ReferralResponseModel> fetchReferralInfo() async {
    final uri = Uri.parse('$_baseUrl/user/$userId/info/buyer');

    print("URL of Referral Info: $uri");

    try {
      final response = await http.get(uri, headers: await headers());
      final data = jsonDecode(response.body);
      print("Response of Referral Info: $data");
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        return ReferralResponseModel.fromJson(jsonResponse);
      } else {
        throw Exception(
          'Failed to fetch referral info (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Referral API Error: $e');
    }
  }
}
