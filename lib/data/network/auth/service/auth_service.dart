import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:housing_flutter_app/data/network/auth/model/user_model.dart';
import 'package:housing_flutter_app/modules/auth/views/login_screen.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constants/api_constants.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:get/get.dart';

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
  }) async {
    final response = await http.post(
      Uri.parse(ApiConstants.sellerRegister),
      headers: {i: j},
      body: jsonEncode({
        'phone': phone,
        'userType': userType,
        'sellerType': sellerType,
      }),
    );

    print("API URL${ApiConstants.sellerRegister}");

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Registration failed');
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
    // print("[DEBUG]=> ${response.body}");
    // debugPrint("[DEBUG]=> ${response.body}");
    if (response.statusCode == 200 && data['success'] == true) {
      return data['data']['token'];
    }
    throw Exception(data['message'] ?? 'OTP verification failed');
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
}
