
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class GetMyCertificateService {
  GetMyCertificateService._();

  static GetMyCertificateService instance = GetMyCertificateService._();

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  static Future<Map<String, dynamic>> getMyCertificate() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConstants.getMyCertificate),
        headers: await headers(),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        debugPrint("Failed to load certificate: ${response.statusCode}");
        debugPrint("Response body: ${response.body}");
        throw Exception("Failed to load certificate: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Exception in getMyCertificate: $e");
      rethrow; // Controller handles error
    }
  }
}