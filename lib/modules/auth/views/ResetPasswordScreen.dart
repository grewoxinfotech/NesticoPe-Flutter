/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/widgets/bar/app_bar/common_bar.dart';

import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/button/button.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonNesticoPeAppBar(
        title: 'Reset Password',
        showBackArrow: true,
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NesticoPeTextField(
                    title: "New Password",
                    controller: authController.newPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                    hintText: "Enter new password",
                  ),
                  const SizedBox(height: 16),
                  NesticoPeTextField(
                    title: "Confirm Password",
                    controller: authController.confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value != authController.newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                    hintText: "Confirm new password",
                  ),
                  const SizedBox(height: 24),
                  NesticoPeButton(
                    title: "Reset Password",
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        authController.resetPassword();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/widgets/New folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import '../../../app/constants/color_res.dart';
import '../../../widgets/bar/app_bar/common_bar.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  CommonNesticoPeAppBar(
        title: 'Reset Password',
        showBackArrow: true,
        leadingIcon: Icons.arrow_back,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Icon(Icons.verified_user, size: 80, color: ColorRes.primary),
                const SizedBox(height: 20),
                Text(
                  "Reset Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: ColorRes.primary,
                  ),
                ),
                const SizedBox(height: 12),
                // Subtitle
                Text(
                  "Enter your new password below and confirm it to reset your account password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 32),

                // New Password Field
                NesticoPeTextField(
                  title: "New Password",
                  controller: authController.newPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  hintText: "Enter new password",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter new password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                NesticoPeTextField(
                  title: "Confirm Password",
                  controller: authController.confirmPasswordController,
                  obscureText: true,
                  prefixIcon: Icons.lock_outline,
                  hintText: "Confirm new password",
                  validator: (value) {
                    if (value != authController.newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Reset Button
                NesticoPeButton(
                  title: "Reset Password",
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      authController.resetPassword();
                    }
                  },
                ),

                const SizedBox(height: 16),
                //
                // // Back to Login
                // OutlinedButton.icon(
                //   onPressed: () {
                //     Get.back();
                //
                //   } ,
                //   icon: const Icon(Icons.arrow_back),
                //   label: const Text("Back to Login"),
                //   style: OutlinedButton.styleFrom(
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     side: BorderSide(color: Colors.blue),
                //     padding: const EdgeInsets.symmetric(vertical: 14),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
