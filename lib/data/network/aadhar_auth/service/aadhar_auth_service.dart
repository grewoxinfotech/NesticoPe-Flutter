import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../app/constants/api_constants.dart';

class AadharAuthService {
  final String aadhar = ApiConstants.aadharInitiateVerification;
  final String aadharOtp = ApiConstants.aadharVerifyOtp;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Initiate Aadhar Verification
  Future<Map<String, dynamic>> initiateAadharVerification(
    String aadharNumber,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(aadhar),
        headers: await headers(),
        body: jsonEncode({'aadhaarNumber': aadharNumber}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ?? 'Failed to initiate Aadhar verification',
        );
      }
    } catch (e) {
      print("Error in initiateAadharVerification: $e");
      rethrow;
    }
  }

  /// Verify Aadhar OTP
  Future<Map<String, dynamic>> verifyAadharOtp(
    String requestId,
    String otp,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(aadharOtp),
        headers: await headers(),
        body: jsonEncode({'request_id': requestId, 'otp': otp}),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to verify Aadhar OTP');
      }
    } catch (e) {
      print("Error in verifyAadharOtp: $e");
      rethrow;
    }
  }
}
