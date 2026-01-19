import 'dart:convert';
import 'dart:math';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:get/get.dart';

import '../../../../app/widgets/snackbar/snackbar.dart';
import '../../../../widgets/messages/snack_bar.dart';

class AuthService {
  final String url = ApiConstants.auth;
  final String i = ApiConstants.contentType;
  final String j = ApiConstants.applicationJson;

  static Future<Map<String, String>> headers() async {
    return await ApiConstants.getHeaders();
  }

  // Login
  Future<UserModel> login(String email, String password) async {
    print("[DEBUG]=> $email $password");
    final response = await http.post(
      Uri.parse(ApiConstants.loginEndpoint),
      headers: {i: j},
      body: jsonEncode({'id': email, 'password': password}),
    );
    print("[DEBUG]=> ${response.headers}");
    print("[DEBUG]=> ${response.body}");

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
    required String username,
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
        'username': username,
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
    print("[DEBUG]=> ${response.body}");
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
    String? referCode,
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.sellerRegister),
      headers: {i: j},
      body: jsonEncode({
        'phone': phone,
        'userType': userType,
        'sellerType': sellerType,
        if (referCode != null) 'referralCode': referCode,
      }),
    );

    print("API URL${ApiConstants.sellerRegister}");

    final data = jsonDecode(response.body);
    print("Seller [DEBUG]=> ${response.body}");
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

      debugPrint('[DEBUG] => Registration Payload: $payload');
      debugPrint('[DEBUG] => API URL: $uri');

      final response = await http.post(
        uri,
        headers: await ApiConstants.getHeadersWithoutToken(),
        body: jsonEncode(payload),
      );

      debugPrint('[DEBUG] => Contractor Response: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Contractor registration failed',
        );
      }
    } catch (e) {
      debugPrint('[ERROR] => Contractor registration exception: $e');
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

      debugPrint('[DEBUG] => Reseller Registration Payload: $payload');
      debugPrint('[DEBUG] => API URL: $uri');

      final response = await http.post(
        uri,
        headers: await ApiConstants.getHeadersWithoutToken(),
        body: jsonEncode(payload),
      );

      debugPrint('[DEBUG] => Reseller Response: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(
          responseData['message'] ?? 'Reseller registration failed',
        );
      }
    } catch (e) {
      debugPrint('[ERROR] => Reseller registration exception: $e');
      rethrow;
    }
  }

  Future<String?> sellerRegistrationComplete(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse("$url/complete-seller-registration"),
        headers: await headers(),
        body: jsonEncode(data),
      );

      print("response : -----------------> ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Seller Complete [DEBUG]=> ${response.body}");

        if (body['success'] == true) {
          // Return token from response
          return body['data']['token'];
        }
      }
      return null;
    } catch (e) {
      print("Error in sellerRegistrationComplete: $e");
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
      return UserModel.fromJson(data['data']['user'])
        ..token = data['data']['token'] ?? token;
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
    print("OTP [DEBUG]=> ${response.body}");
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
    print(
      "Convert to Url Contractor ${Uri.parse('${ApiConstants.convertToContractor}/$userId')}",
    );
    final data = jsonDecode(response.body);
    print("Convert to Api Contractor ${response.body}");
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
    print("[DEBUG]=> ${response.body}");
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
    Get.offAll(const LoginScreen());
  }

  Future<bool> deleteAccount(String userId, String reason) async {
    final response = await http.post(
      Uri.parse(ApiConstants.deleteAccount),
      headers: await headers(),
      body: jsonEncode({'userId': userId, 'reason': reason}),
    );

    final data = jsonDecode(response.body);
    print("[DEBUG]=> Delete Account ${response.body}");
    if (response.statusCode == 200 && data['success'] == true) {
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
