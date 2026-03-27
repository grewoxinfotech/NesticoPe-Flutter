import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';

class OfferInquiryService {
  static const String _baseUrl =
      'https://nesticopeapi.grewoxinfotech.com/api/v1/property/general-inquiry';
  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  static Future<Map<String, dynamic>> submitOfferInquiry({
    required String name,
    required String email,
    required String phone,
    required Map<String, dynamic> meta,
  }) async {
    try {
      final body = jsonEncode({
        "name": name,
        "email": email,
        "phone": phone,
        "meta": meta,
      });

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: await headers(),
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Failed to submit inquiry: ${response.statusCode}",
        };
      }
    } catch (e) {
      debugPrint("Error in submitOfferInquiry: $e");
      return {
        "success": false,
        "message": "An error occurred while submitting inquiry",
      };
    }
  }
}
