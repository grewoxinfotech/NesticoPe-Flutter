import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../app/constants/api_constants.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:get/get.dart';

import '../../../../services/notification_service.dart';
import '../../../../widgets/messages/snack_bar.dart';

class AuthService {
  final String url = ApiConstants.auth;
  final String i = ApiConstants.contentType;
  final String j = ApiConstants.applicationJson;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  Future<UserModel?> loginWithTrueCaller(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.truecallerLogin),
        headers: {i: j},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        final user = UserModel.fromJson(data['data']);

        final token = data['data']['token'] ?? user.token;

        await SecureStorage.saveUserData(user);
        await SecureStorage.saveToken(token);
        await SecureStorage.saveLoggedIn(true);
        final success = data['success'] == true;
        if (success) {
          // Fluttertoast.showToast(
          //   msg: "🎉 Login With Truecaller Done Successfully!",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   backgroundColor: Colors.green,
          //   textColor: Colors.white,
          // );
          return user;
        } else {
          // Fluttertoast.showToast(
          //   msg: "⚠️ Failed to Login With Truecaller. Please try again.",
          //   toastLength: Toast.LENGTH_SHORT,
          //   gravity: ToastGravity.BOTTOM,
          //   backgroundColor: Colors.red,
          //   textColor: Colors.white,
          // );
        }
      } else {
        // Fluttertoast.showToast(
        //   msg: "⚠️ Failed to Login With Truecaller. Please try again.",
        //   toastLength: Toast.LENGTH_SHORT,
        //   gravity: ToastGravity.BOTTOM,
        //   backgroundColor: Colors.red,
        //   textColor: Colors.white,
        // );
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<bool> generateResellerCertificate(
    Map<String, dynamic> userData,
  ) async {
    try {
      // AppLogger.structured("Fetch The Certificate Data from API", userData);

      final user = {
        "userId": userData['userId'],
        "certificateData": {
          "firstName": "",
          "lastName": "",
          "username": userData['username'],
          "email": userData['email'],
          "phone": userData['phone'],
        },
      };
      // AppLogger.structured("Fetch The Certificate Data from API", user);
      final response = await http.post(
        Uri.parse(ApiConstants.generateResellerCertificate),
        headers: await ApiConstants.getHeadersWithoutToken(),
        body: jsonEncode(user),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final url = data['data']['certificateUrl'];

        await downloadOpenSharePdf(url);

        /*  if (path != null) {
          print("Certificate saved at: $path");
        }
*/
        final success = data['success'] == true;

        // ✅ Show success/failure toast
        if (success) {
          Fluttertoast.showToast(
            msg: "🎉 Certificate generated successfully!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: "⚠️ Failed to generate certificate. Please try again.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.orange,
            textColor: Colors.white,
          );
        }

        return success;
      } else {
        Fluttertoast.showToast(
          msg: "❌ Server Error: ${response.statusCode}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "🚫 Error: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future<String?> downloadCertificate(String pdfUrl) async {
    try {
      final dio = Dio();

      final dir = await getApplicationDocumentsDirectory();
      final fileName = pdfUrl.split('/').last;
      final filePath = "${dir.path}/$fileName";

      await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      return filePath;
    } catch (e) {
      return null;
    }
  }

  Future<void> downloadOpenSharePdf(String pdfUrl) async {
    try {
      final dio = Dio();

      final dir = await getApplicationDocumentsDirectory();
      final fileName = pdfUrl.split('/').last;
      final filePath = "${dir.path}/$fileName";

      await dio.download(
        pdfUrl,
        filePath,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
        ),
      );

      // 🔓 Open PDF
      await OpenFilex.open(filePath);

      // 📤 Share PDF
      await Share.shareXFiles([
        XFile(filePath),
      ], text: "Here is your certificate");
    } catch (e) {}
  }

  // Login
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {i: j},
      body: jsonEncode({'id': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      final user = UserModel.fromJson(data['data']);
      final token = data['token'] ?? user.token;

      if (token != null && token.isNotEmpty) {
        await SecureStorage.saveToken(token);
      }

      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);

      return user;
    } else {
      throw Exception(data["message"] ?? "Login failed");
    }
  }

  Future<Map<String, dynamic>> register({
    required String password,
    required String email,
    required String userType,
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String city,
    required String state,
    required String zipCode,
    String? referCode,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.registerEndpoint),
      headers: {i: j},
      body: jsonEncode({
        'password': password,
        'email': email,
        'userType': userType,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        'address': address,
        'city': city,
        'state': state,
        'zipCode': zipCode,
        if (referCode != null) 'referralCode': referCode,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  //seler register
  Future<Map<String, dynamic>> sellerRegister({
    required String phone,
    required String userType,
    required String sellerType,
    String propertyType = 'residential',
    String lookingTo = 'rent',
    String? referCode,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.sellerRegister),
      headers: {i: j},
      body: jsonEncode({
        'phone': phone,
        'userType': userType,
        'sellerType': sellerType,
        'propertyType': propertyType,
        'lookingTo': lookingTo,
        if (referCode != null) 'referralCode': referCode,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
    }
  }

  ///==================== Contractor Registration ====================
  Future<Map<String, dynamic>> contractorRegister({
    required String userType,
    required Map<String, dynamic> data,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.registerEndpoint);

      final payload = {'userType': userType, ...data};

      final response = await http.post(
        uri,
        headers: await ApiConstants.getHeadersWithoutToken(),
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Contractor registration failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> resellerRegister({
    required String userType,
    required Map<String, dynamic> data,
  }) async {
    try {
      final uri = Uri.parse(ApiConstants.registerEndpoint);

      final payload = {
        'userType': userType, // "reseller"
        ...data,
      };

      final response = await http.post(
        uri,
        headers: await ApiConstants.getHeadersWithoutToken(),
        body: jsonEncode(payload),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Partner registration failed',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> sellerRegistrationComplete(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$url/complete-seller-registration"),
        headers: await headers(),
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body['success'] == true) {
          final responseData = body['data'] as Map<String, dynamic>? ?? {};
          final userJson = responseData['user'] as Map<String, dynamic>? ?? {};
          final token = responseData['token']?.toString();
          if (token == null || token.isEmpty) return null;

          return UserModel(token: token, user: User.fromJson(userJson));
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> resendOtp(String token) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/resend-otp'),
      headers: await headers(),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data['message'] ?? 'Failed to resend OTP');
    }
  }

  Future<UserModel> verifyOtp(String otp, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/verify-otp'),
      headers: await headers(),
      body: jsonEncode({'otp': otp}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      final responseData = data['data'] as Map<String, dynamic>? ?? {};
      final userJson = responseData['user'] as Map<String, dynamic>? ?? {};
      final resolvedToken = (responseData['token'] ?? token).toString();

      if (userJson['userType'] == "reseller" &&
          responseData['certificateData'] != null) {
        generateResellerCertificate(responseData['certificateData']);
      }

      return UserModel(token: resolvedToken, user: User.fromJson(userJson));
    }
    throw Exception(data['message'] ?? 'OTP verification failed');
  }

  Future<String> forgotPassword(String id) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/forgot-password'),
      headers: {i: j},
      body: jsonEncode({'id': id}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return data['data']['token'];
    } else {
      throw Exception(data["message"] ?? "Failed to send OTP");
    }
  }

  Future<String> verifyOtpSellerRegister(String otp, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/verify-otp'),
      headers: {i: j, 'Authorization': 'Bearer $token'},
      body: jsonEncode({'otp': otp}),
    );

    final data = jsonDecode(response.body);

    // debugPrint("[DEBUG]=> ${response.body}");
    if (response.statusCode == 200 && data['success'] == true) {
      return data['data']['token'];
    }
    throw Exception(data['message'] ?? 'OTP verification failed');
  }

  Future<bool> convertBuyerToSeller(String sellerType) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';
    final response = await http.post(
      Uri.parse('${ApiConstants.covertToSeller}/$userId'),
      headers: await headers(),
      body: jsonEncode({'sellerType': sellerType}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      return true;
    } else {
      throw Exception(data["message"] ?? "Failed to convert buyer to seller");
    }
  }

  Future<bool> convertBuyerToReseller({
    required String city,
    required String zipCode,
  }) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';

    final response = await http.post(
      Uri.parse('${ApiConstants.convertToReseller}/$userId'),
      headers: await headers(),
      body: jsonEncode({'city': city, "zipCode": zipCode}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      await generateResellerCertificate(data['data']['certificateData']);
      return true;
    } else {
      throw Exception(data["message"] ?? "Failed to convert buyer to reseller");
    }
  }

  Future<bool> convertBuyerToContractor(String city, String type) async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';
    final response = await http.post(
      Uri.parse('${ApiConstants.convertToContractor}/$userId'),
      headers: await headers(),
      body: jsonEncode({'city': city, "contractorType": type}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return true;
    } else {
      throw Exception(data["message"] ?? "Failed to convert buyer to reseller");
    }
  }

  Future<String> verifyPasswordResetOtp(String otp, String token) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/verify-otp'),
      headers: {i: j, 'Authorization': 'Bearer $token'},
      body: jsonEncode({'otp': otp}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return data['data']['resetToken'];
    } else {
      throw Exception(data["message"] ?? "OTP verification failed");
    }
  }

  Future<void> resetPassword(String newPassword, String resetToken) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/reset-password'),
      headers: {i: j, 'Authorization': 'Bearer $resetToken'},
      body: jsonEncode({'newPassword': newPassword}),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode != 200 || data['success'] != true) {
      throw Exception(data["message"] ?? "Password reset failed");
    }
  }

  Future<void> logout() async {
    await SecureStorage.clearAll();
    await NotificationService.instance.resetToGuest();
    Get.offAll(OtpLoginScreen());
  }

  Future<bool> requestOtpLogin(String id, {String? module}) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/otp-login'),
      headers: {i: j},
      body: jsonEncode({'id': id, if (module != null) 'module': module}),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final token = (data['data']?['token'] ?? '').toString();

      if (token.isNotEmpty) {
        await SecureStorage.saveLoginWithOtpToken(token);
      }
      return true;
    }
    if (response.statusCode == 429) {
      showTopAwesomeSnackbar(
        title: 'Too Many Requests',
        color: ColorRes.white,
        message:
            'Maximum OTP requests reached 3 times in 24 hours. Please try again later.',
        contentType: ContentType.failure,
      );
      return false;
    }
    if (response.statusCode == 400) {
      var message = data['message'].toString();

      // print("OTP Login Error: $message");

      if (message.contains('Seller') ||
          message.contains('Builder') ||
          message.contains('Partner') ||
          message.contains('Contractor')) {
        showTopAwesomeSnackbar(
          title: 'Click on Login as Partner ',
          color: ColorRes.white,
          message: message,
          contentType: ContentType.failure,
        );
        return false;
      } else {
        showTopAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to resend OTP',
          color: ColorRes.white,
          contentType: ContentType.failure,
        );
        return false;
      }
    }
    showTopAwesomeSnackbar(
      title: 'Error',
      message: 'Failed to resend OTP',
      color: ColorRes.white,
      contentType: ContentType.failure,
    );
    return false;
  }

  Future<UserModel?> verifyLoginOtp(String otp) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/verify-otp'),
      headers: await ApiConstants.getUpdatedLoginWithOtpHeaders(),
      body: jsonEncode({'otp': otp}),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      final user = UserModel.fromJson(data['data']);

      final token = data['data']['token'] ?? user.token;
      if (token.isNotEmpty) {
        await SecureStorage.saveToken(token);
      }
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);
      await SecureStorage.deleteLoginWithOtpToken();
      return user;
    }
    return null;
  }

  Future<bool> resendLoginOtp() async {
    final response = await http.post(
      Uri.parse('${ApiConstants.auth}/resend-otp'),
      headers: await ApiConstants.getUpdatedLoginWithOtpHeaders(),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['success'] == true) {
      final token = (data['data']?['token'] ?? '').toString();
      if (token.isNotEmpty) {
        await SecureStorage.saveLoginWithOtpToken(token);
      }
      return true;
    }
    if (response.statusCode == 429) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Too Many Requests',
        message:
            'Maximum OTP requests reached 3 times in 24 hours. Please try again later.',
        contentType: ContentType.failure,
      );
      return false;
    }

    if (response.statusCode == 400) {
      var message = data['message'];

      if (message.contains('Seller') ||
          message.contains('Builder') ||
          message.contains('Partner') ||
          message.contains('Contractor')) {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Click on Login as Partner ',
          message: message,

          contentType: ContentType.failure,
        );
      } else {
        NesticoPeSnackBar.showAwesomeSnackbar(
          title: 'Error',
          message: 'Failed to resend OTP',
          contentType: ContentType.failure,
        );
      }
      return false;
    }
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Error',
      message: 'Failed to resend OTP',
      contentType: ContentType.failure,
    );
    return false;
  }

  Future<bool> deleteAccount(String userId, String reason) async {
    final response = await http.post(
      Uri.parse(ApiConstants.deleteAccount),
      headers: await headers(),
      body: jsonEncode({'userId': userId, 'reason': reason}),
    );

    final data = jsonDecode(response.body);

    if (data['success'] == true) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: data['message'] ?? 'Account deleted successfully',
        contentType: ContentType.success,
      );
      return true;
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',

        message: data['message'] ?? 'Failed to delete account',
        contentType: ContentType.failure,
      );
      return false;
    }
  }
}
