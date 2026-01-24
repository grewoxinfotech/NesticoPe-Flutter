
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../../../app/constants/api_constants.dart';
import '../../../../../modules/profile/model/seller_profile.dart';
import '../../../../../widgets/messages/snack_bar.dart';
import '../../../../database/secure_storage_service.dart';
import '../../model/profile/contractor_profile_model.dart';


class ContractorProfileUpdate {
  ContractorProfileUpdate._();

  static ContractorProfileUpdate profileUpdate = ContractorProfileUpdate._();
  final _baseUrl = ApiConstants.user;
  final _baseUrlSeller = ApiConstants.getUserProfile;

  static Future<Map<String, String>> header() async {
    return await ApiConstants.getHeaders();
  }
  static Future<Map<String, String>> headerUpdateToken() async {
    return await ApiConstants.getUpdatedHeaders();
  }

  Future<Map<String, dynamic>?> getUserProfileData(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrlSeller/$userId'),
        headers: await header(),
      );
      final decoded = jsonDecode(response.body);
      print('📦 Selhjuyler Raw Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return decoded['data'];
      } else {
        print('⚠️ Contractor Dashboard Error Response: $decoded');
        return decoded['data'];
      }
    } catch (e, stack) {
      print('❌ Exception in fetchContractorDashboard: $e');
      print(stack);
      return null;
    }
  }

  // Future<Map<String, dynamic>> updateSellerProfileDetails(
  //     UserUpdateProfile user,
  //     String userId,) async {
  //   try {
  //     // If there's a profile image file, use multipart upload
  //     // Otherwise, use regular JSON update
  //     final response = await http.put(
  //       Uri.parse('$_baseUrl/$userId'),
  //       headers: await header(),
  //       body: jsonEncode(user.toMap()),
  //     );
  //
  //     final decoded = jsonDecode(response.body);
  //     print('📦 Reseller Profile Update Response: $decoded');
  //     print('📦 Status Code: ${response.statusCode}');
  //
  //     if (decoded['otpRequired'] == true ||
  //         decoded['message']?.toString().toLowerCase().contains('otp') ==
  //             true) {
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
  //     return decoded;
  //   } catch (e, stack) {
  //     print('❌ Exception in Reseller Profile Update: $e');
  //     print(stack);
  //     return {
  //       'story': false,
  //       'message': 'Error updating profile: ${e.toString()}',
  //     };
  //   }
  // }
  Future<Map<String, dynamic>> updateSellerProfileDetails(
      ContractorUserUpdateProfile user,
      String userId, {
        File? profileImageFile,
      }) async {
    try {
      final uri = Uri.parse('$_baseUrl/$userId');
      final request = http.MultipartRequest('PUT', uri);

      // ✅ Add headers
      final headersMap = await header();
      request.headers.addAll(headersMap);

      // ✅ Add profile image (if provided)
      if (profileImageFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profilePic',
            profileImageFile.path,
          ),
        );
        print('🖼️ Added profile image: ${profileImageFile.path}');
      }

      // ✅ Convert user object to Map
      final userMap = user.toMap();

      // ✅ Flatten nested maps (like profiledata)
      final flattenedMap = _flattenToStringMap(userMap);

      // ✅ Add all flattened fields
      request.fields.addAll(flattenedMap);

      print('📤 Sending multipart request to $uri');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final decoded = jsonDecode(response.body);
      print('📦 Seller Profile Update Response: $decoded');
      print('📦 Status Code: ${response.statusCode}');
      final jsonData = json.decode(response.body);
      // final jsonData = json.decode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: jsonData['message'],
        contentType: ContentType.success,
      );
      // ✅ Handle OTP-required responses
      if (decoded['otpRequired'] == true ||
          decoded['message']?.toString().toLowerCase().contains('otp') == true) {
        if (decoded['updatePhoneToken'] != null) {
          await SecureStorage.saveUpdatePhoneToken(decoded['updatePhoneToken']);
          print('✅ Saved updatePhoneToken for OTP verification');
        }
        return decoded;
      }

      // ✅ Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return decoded;
      }
       json.decode(response.body);
      // final jsonData = json.decode(response.body);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: jsonData['message']??"Failed to update profile Data",
        contentType: ContentType.failure,
      );

      // ⚠️ Error
      print('⚠️ Contractor Profile Update Error Response: $decoded');
      return decoded;
    } catch (e, stack) {
      print('❌ Exception in Seller Profile Update: $e');
      print(stack);
      return {
        'story': false,
        'message': 'Error updating profile: ${e.toString()}',
      };
    }
  }
  Map<String, String> _flattenToStringMap(Map<String, dynamic> data, [String parentKey = '']) {
    final result = <String, String>{};

    data.forEach((key, value) {
      if(key == 'profilePic') return;
      final newKey = parentKey.isEmpty ? key : '$parentKey[$key]';
      if (value == null) return;

      if (value is Map<String, dynamic>) {
        result.addAll(_flattenToStringMap(value, newKey));
      } else {
        result[newKey] = value.toString();
      }
    });

    return result;
  }




  Future<Map<String, dynamic>> verifyOtpForSellerNumber(String otp,
      Map user,
      String userId,) async {
    try {
      log('user id dshfbd $userId');
      log('user OTP  $otp');
      log("user Data ${user}");
      final response = await http.post(
        Uri.parse('$_baseUrl/$userId/verify-phone-update'),
        headers: await headerUpdateToken(),
        body: jsonEncode({"otp": otp, "updateData": user}),
      );

      final decoded = jsonDecode(response.body);
      print('📦 Contractor Verify Update Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Clear the updatePhoneToken after successful verification
        print('✅ Cleared updatePhoneToken after successful verification');
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return decoded;
      } else {
        print('⚠️ Contractor Profile Update Error Response: $decoded');
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: jsonData['message'],
          contentType: ContentType.failure,
        );
        return {
          'story': false,
          'message': decoded['message'] ?? 'Failed to verify OTP',
        };
      }
    } catch (e, stack) {
      print('❌ Exception in Contractor Profile Update: $e');
      print(stack);
      return {
        'story': false,
        'message': 'Error verifying OTP: ${e.toString()}',
      };
    }
  }

  // Resend OTP for phone number update
  Future<Map<String, dynamic>> resendPhoneSellerUpdateOtp(String userId,
      String phone,) async {
    log("dhfbhd $phone");
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/$userId/resend-phone-update-otp'),
        headers: await headerUpdateToken(),
        body: jsonEncode({'phone': phone}),
      );

      final decoded = jsonDecode(response.body);
      print('📦 Resend Phone Update OTP Response: $decoded');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Save new updatePhoneToken
        if (decoded['data']?['updatePhoneToken'] != null) {
          await SecureStorage.saveUpdatePhoneToken(
            decoded['data']['updatePhoneToken'],
          );
          print('✅ Saved new updatePhoneToken after resend');
        }
        final jsonData = json.decode(response.body);
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Success',
          message: jsonData['message'],
          contentType: ContentType.success,
        );
        return decoded;
      } else {
        print('⚠️ Resend OTP Error Response: $decoded');
        // final jsonData = json.decode(response.body);
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Failed',
          message: decoded['message'],
          contentType: ContentType.failure,
        );
        return {
          'story': false,
          'message': decoded['message'] ?? 'Failed to resend OTP',
        };
      }
    } catch (e, stack) {
      print('❌ Exception in Resend OTP: $e');
      print(stack);
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Failed',
        message: "Error while updating project",
        contentType: ContentType.failure,
      );
      return {
        'story': false,
        'message': 'Error resending OTP: ${e.toString()}',
      };
    }
  }

// Helper method for multipart image upload}
}
