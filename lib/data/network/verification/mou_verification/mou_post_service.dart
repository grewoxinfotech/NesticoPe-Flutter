import 'dart:convert';
import 'dart:typed_data';
import 'package:housing_flutter_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;

class MouService {
  static String baseUrl = ApiConstants.digitalSignature;

  Future<bool> uploadSignature({
    required Uint8List signatureBytes,
    required String name,
    required String userId,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

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
}
