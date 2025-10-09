import 'dart:convert';

import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Referral_Service{
  Referral_Service._();
  static final Referral_Service instance = Referral_Service._();

  final String _baseUrl = '${ApiConstants.referralGet}';

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  void fetchReferrals() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: await headers());

      if (response.statusCode == 200) {
        final referrals = json.decode(response.body);

        print(referrals);
      } else {
        final referrals = json.decode(response.body);

        print(referrals);
        throw Exception('Failed to fetch referrals');
      }
    } on Exception catch (e) {
      print('Error fetching referrals: $e');
    }
  }


}