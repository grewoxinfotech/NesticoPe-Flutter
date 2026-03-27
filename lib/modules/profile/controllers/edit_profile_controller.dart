import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:http/http.dart' as http;

import '../../../app/widgets/snackbar/snackbar.dart';
import '../../../widgets/messages/snack_bar.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Dropdown value
  var selectedUserType = 'seller'.obs;

  // TextEditingControllers (initialize with empty string, will set in onInit)
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  final authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
    final user = authController.currentUser.value!.user;

    if (user != null) {
      usernameController.text = user.username ?? '';
      emailController.text = user.email ?? '';
      firstNameController.text = user.firstName ?? '';
      lastNameController.text = user.lastName ?? '';
      phoneController.text = user.phone ?? '';
      addressController.text = user.address ?? '';
      cityController.text = user.city ?? '';
      stateController.text = user.state ?? '';
      zipCodeController.text = user.zipCode ?? '';
      selectedUserType.value = user.userType ?? 'seller';
    }

    // Password is not usually returned for security reasons
    passwordController.text = '';
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }

  Future<void> updateProfile() async {
    try {
      authController.isLoading.value = true;
      if (!(formKey.currentState?.validate() ?? false)) return;

      final userId = authController.currentUser.value?.user?.id;
      final token = authController.currentUser.value?.token;
      if (userId == null || token == null) {
        return;
      }
      final url = Uri.parse(
        'https://your-api.com/user/$userId',
      ); // Replace with your actual base URL
      final body = {
        "username": usernameController.text.trim(),
        "password": passwordController.text.trim(),
        "email": emailController.text.trim(),
        "userType": selectedUserType.value,
        "firstName": firstNameController.text.trim(),
        "lastName": lastNameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": addressController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "zipCode": zipCodeController.text.trim(),
      };

      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      authController.errorMessage.value = e.toString();
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Login Failed",
        message: e.toString(),
        contentType: ContentType.failure,
      );
    } finally {
      authController.isLoading.value = false;
    }
  }
}
