import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../../app/constants/api_constants.dart';

class DigitalSignatureService {
  final String digitalSignature =
      ApiConstants.digitalSignature; // base endpoint

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Fetch Digital Signature List (MOU)
  Future<Map<String, dynamic>> fetchDigitalSignatures({
    required int page,
    required int limit,
    required String userId,
  }) async {
    try {
      final uri = Uri.parse(digitalSignature).replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          'userId': userId,
        },
      );

      final response = await http.get(uri, headers: await headers());

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(
          data['message'] ?? 'Failed to fetch digital signatures',
        );
      }
    } catch (e) {
      print("Error in fetchDigitalSignatures: $e");
      rethrow;
    }
  }
}
