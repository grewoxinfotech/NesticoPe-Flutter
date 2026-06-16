import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/app/constants/api_constants.dart';
import 'package:http/http.dart' as http;
import 'package:nesticope_app/data/network/verification/mou_verification/mou_content_model.dart';
import 'package:nesticope_app/data/network/verification/mou_verification/platform_setting_model.dart';

class MouService {
  static String baseUrl = ApiConstants.digitalSignature;
  static String plaftformFeeSettingUrl = ApiConstants.getPlatformFeeSetting;
  static String mouVerificationUrl = ApiConstants.mouVerification;
  Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }

  Future<PaginationResponse<PlatformFeeItem>> getPlatformFeeSetting({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      };
      final response = await http.get(
        Uri.parse(
          plaftformFeeSettingUrl,
        ).replace(queryParameters: queryParameters),
        headers: await header(),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Handle the platform fee setting data as needed
      return PaginationResponse<PlatformFeeItem>.fromJson(
  data,
  (item) => PlatformFeeItem.fromJson(
    Map<String, dynamic>.from(item),
  ),
);
        // print("Platform Fee Setting: $data");
      } else {
        throw Exception(
          "Failed to load platform fee setting: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Service error: $e");
    }
  }

  Future<PaginationResponse<MouItem>> getMouVerification({
    int? page,
    int? limit,
  }) async {
    try {
      final queryParameters = {
        if (page != null) 'page': page.toString(),
        if (limit != null) 'limit': limit.toString(),
      };
      final response = await http.get(
        Uri.parse(mouVerificationUrl).replace(queryParameters: queryParameters),
        headers: await header(),
      );

      if (response.statusCode == 200) {
        // final data = jsonDecode(response.body);
print(jsonDecode(response.body).runtimeType);
print(jsonDecode(response.body)['data'].runtimeType);
print(jsonDecode(response.body)['data']['items'].runtimeType);
        // print(" Mou Check it right ${data}");

        // Handle the platform fee setting data as needed
        final responseJson = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );

        return PaginationResponse<MouItem>.fromJson(
          responseJson,
          (item) => MouItem.fromJson(Map<String, dynamic>.from(item)),
        );
        // print("Platform Fee Setting: $data");
      } else {
        throw Exception(
          "Failed to load platform fee setting: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Service error: $e");
    }
  }

  Future<bool> uploadSignature({
    required Uint8List signatureBytes,
    required String name,
    required String userId,
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      request.headers.addAll(await header());

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
