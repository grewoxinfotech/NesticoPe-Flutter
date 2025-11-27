import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../../../../app/constants/api_constants.dart';
import '../../../../database/secure_storage_service.dart';
import '../model/reseller_update_profile_model.dart';

class ProfileUpdate {
  ProfileUpdate._();

  static ProfileUpdate profileUpdate = ProfileUpdate._();
  final _baseUrl = ApiConstants.user;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }
  // Future<Map<String, dynamic>> updateProfileDetails(
  //   User user,
  //   String userId,
  //    File? profileImageFile,
  // ) async {
  //   try {
  //     final response = await http.put(
  //       Uri.parse('$_baseUrl/$userId'),
  //       headers: await header(),
  //       body: jsonEncode(user),
  //     );
  //
  //     final decoded = jsonDecode(response.body);
  //     print('📦 Reseller Profile Update Response: $decoded');
  //     print('📦 Status Code: ${response.statusCode}');
  //
  //     if (decoded['otpRequired'] == true ||
  //         decoded['message']?.toString().toLowerCase().contains('otp') == true) {
  //       // Save updatePhoneToken if present
  //       if (decoded['updatePhoneToken'] != null) {
  //         await SecureStorage.saveToken(decoded['updatePhoneToken']);
  //         print('✅ Saved updatePhoneToken for OTP verification');
  //       }
  //       // Return full decoded response with OTP data
  //       return decoded;
  //     }
  //
  //     // For story responses (200/201)
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return decoded;
  //     }
  //
  //     // For other error responses
  //     print('⚠️ Reseller Profile Update Error Response: $decoded');
  //     return decoded; // Return full decoded response to preserve all fields
  //   } catch (e, stack) {
  //     print('❌ Exception in Reseller Profile Update: $e');
  //     print(stack);
  //     return {
  //       'story': false,
  //       'message': 'Error updating profile: ${e.toString()}',
  //     };
  //   }
  // }
  Future<Map<String, dynamic>> updateProfileDetails(
      User user,
      String userId,
      File? profileImageFile,
      ) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId');
      final request = http.MultipartRequest('PUT', uri);

      // ✅ Add headers
      final headersMap = await header();
      request.headers.addAll(headersMap);

      // ✅ Add profile image if provided
      if (profileImageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic', // <-- field name must match backend
            profileImageFile.path,
          ),
        );
        print('🖼️ Added profile image: ${profileImageFile.path}');
      }

      // ✅ Add user fields as form fields
      final userMap = user.toJson(); // ensure your `User` model has `toJson()`
      userMap.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      print('📤 Sending multipart request to $uri');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final decoded = jsonDecode(response.body);
      print('📦 Reseller Profile Update Response: $decoded');
      print('📦 Status Code: ${response.statusCode}');

      // ✅ Handle OTP requirement
      if (decoded['otpRequired'] == true ||
          decoded['message']?.toString().toLowerCase().contains('otp') == true) {
        if (decoded['updatePhoneToken'] != null) {
          await SecureStorage.saveToken(decoded['updatePhoneToken']);
          print('✅ Saved updatePhoneToken for OTP verification');
        }
        return decoded;
      }

      // ✅ Handle story (200/201)
      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded;
      }

      // ⚠️ Other errors
      print('⚠️ Reseller Profile Update Error Response: $decoded');
      return decoded;
    } catch (e, stack) {
      print('❌ Exception in Reseller Profile Update: $e');
      print(stack);
      return {
        'story': false,
        'message': 'Error updating profile: ${e.toString()}',
      };
    }
  }


  Future<Map<String, dynamic>> verifyOtpForResellerNumber(
    String otp,
    User user,
    String userId,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$userId/verify-phone-update'),
        headers: await header(),
        body: jsonEncode({"otp": otp, "updateData": user}),
      );

      final decoded = jsonDecode(response.body);
      print('📦 Reseller Verify Update Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear the updatePhoneToken after successful verification
        return decoded;
      } else {
        print('⚠️ Reseller Profile Update Error Response: $decoded');
        return {
          'story': false,
          'message': decoded['message'] ?? 'Failed to verify OTP',
        };
      }
    } catch (e, stack) {
      print('❌ Exception in Reseller Profile Update: $e');
      print(stack);
      return {
        'story': false,
        'message': 'Error verifying OTP: ${e.toString()}',
      };
    }
  }

  // Resend OTP for phone number update
  Future<Map<String, dynamic>> resendPhoneUpdateOtp(
    String userId,
    String phone,
  ) async {
    log("dhfbhd $phone");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$userId/resend-phone-update-otp'),
        headers: await header(),
        body: jsonEncode({'phone': phone}),
      );

      final decoded = jsonDecode(response.body);
      print('📦 Resend Phone Update OTP Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save new updatePhoneToken
        if (decoded['data']?['updatePhoneToken'] != null) {
          await SecureStorage.saveToken(
            decoded['data']['updatePhoneToken'],
          );
          print('✅ Saved new updatePhoneToken after resend');
        }
        return decoded;
      } else {
        print('⚠️ Resend OTP Error Response: $decoded');
        return {
          'story': false,
          'message': decoded['message'] ?? 'Failed to resend OTP',
        };
      }
    } catch (e, stack) {
      print('❌ Exception in Resend OTP: $e');
      print(stack);
      return {
        'story': false,
        'message': 'Error resending OTP: ${e.toString()}',
      };
    }
  }
}
