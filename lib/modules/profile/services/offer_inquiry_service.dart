import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';

class OfferInquiryService {
  static const Duration _requestTimeout = Duration(seconds: 30);

  static Future<Map<String, dynamic>> submitOfferInquiry({
    required String name,
    required String email,
    required String phone,
    required Map<String, dynamic> meta,
  }) async {
    final uri = Uri.parse(ApiConstants.generalInquiry);

    try {
      final body = jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
        'meta': meta,
      });

      debugPrint('Offer Inquiry Body: $body');
      debugPrint('Offer Inquiry URL: $uri');

      final response = await http
          .post(uri, headers: await ApiConstants.getHeaders(), body: body)
          .timeout(_requestTimeout);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) return decoded;
        return {'success': true, 'message': 'Inquiry submitted successfully'};
      }

      return {
        'success': false,
        'message': 'Failed to submit inquiry: ${response.statusCode}',
      };
    } on Exception catch (e) {
      debugPrint('Error in submitOfferInquiry: $e');
      final message = e.toString().contains('TimeoutException') ||
              e.toString().contains('Connection timed out')
          ? 'Request timed out. Check your internet connection and try again.'
          : 'An error occurred while submitting inquiry';
      return {'success': false, 'message': message};
    }
  }
}
