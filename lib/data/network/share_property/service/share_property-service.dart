import 'dart:convert';
import 'dart:developer';

import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class SharePropertyService {
  SharePropertyService._();
  static SharePropertyService service = SharePropertyService._();
  final _baseUrl = ApiConstants.sharePropertyLink;
  final _baseSharePropertyUrl = ApiConstants.resellerPropertyShare;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<Map<String, dynamic>> getPropertyLink(String propertyId) async {
    try {
      final url = Uri.parse(_baseUrl);
      final response = await http.post(
        url,
        headers: await header(),
        body: jsonEncode({
          "propertyId": propertyId,
          "platform": "copy_link",
          "shareType": "direct",
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        return data;
      }
    } catch (e) {
      return {};
    }
    return {};
  }

  Future<String?> sharePropertyLink(String propertyId) async {
    try {
      final url = Uri.parse(_baseSharePropertyUrl);

      final response = await http.post(
        url,
        headers: await header(),
        body: jsonEncode({"propertyId": propertyId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        if (data is Map && data['success'] == true) {
          final shareData = data['data'];
          if (shareData != null && shareData['shareUrl'] != null) {
            final shareUrl = shareData['shareUrl'].toString();

            return shareUrl;
          }
        }

        return null;
      } else {
        return null;
      }
    } catch (e, stack) {
      return null;
    }
  }
}
