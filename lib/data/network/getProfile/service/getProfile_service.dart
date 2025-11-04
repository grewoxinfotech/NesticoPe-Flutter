// import 'package:housing_flutter_app/confige/helper/api_helper.dart';
import 'dart:convert';

import 'package:housing_flutter_app/confige/helper/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../../../app/constants/api_constants.dart';

class GetProfileService {
  GetProfileService._();

  static final GetProfileService getProfileService = GetProfileService._();

  final _baseUrl = ApiConstants.getUserProfile;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String, dynamic>?> getUserProfileData(String userId) async {
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
