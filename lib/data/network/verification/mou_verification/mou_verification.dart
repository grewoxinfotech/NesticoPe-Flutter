import 'dart:convert';
import 'dart:typed_data';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class DigitalSignatureService {
  static String baseUrl = ApiConstants.digitalSignature;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  /// Upload Digital Signature
  Future<bool> uploadSignature({
    required Uint8List signatureBytes,
    required String name,
    required String userId,
  }) async {
    try {
      final uri = Uri.parse(baseUrl);
      print("URI of Digital Signature: $uri");

      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll(await headers());

      /// Add fields
      request.fields['name'] = name;
      request.fields['userId'] = userId;

      /// Add signature file
      request.files.add(
        http.MultipartFile.fromBytes(
          'signature',
          signatureBytes,
          filename: 'signature.png',
        ),
      );

      /// Send request
      var streamedResponse = await request.send();

      /// Convert to normal response
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw Exception(
          "Upload failed: ${response.statusCode} ${response.body}",
        );
      }
    } catch (e) {
      throw Exception("Service error: $e");
    }
  }

  /// Fetch Digital Signature List (MOU)
  Future<Map<String, dynamic>> fetchDigitalSignatures({
    required int page,
    required int limit,
    required String userId,
  }) async {
    try {
      final uri = Uri.parse(baseUrl).replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          'userId': userId,
        },
      );

      print("URI of Digital Signature: $uri");
      print("Headers for Digital Signature: ${await headers()}");
     

      final response = await http.get(uri, headers: await headers());
       print("Query Parameters: ${response.statusCode} ${response.body}");

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
