/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/common_bar.dart';

import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/button/button.dart';
import '../controllers/auth_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonNesticoPeAppBar(
        title: 'Forgot Password',
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
                  // Forgot Password Title
                  // Text(
                  //
                  //   style: theme.textTheme.headlineMedium?.copyWith(
                  //     fontFamily: FontRes.nuNunitoSans,
                  //     fontWeight: AppFontWeights.extraBold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  // Email Field
                  NesticoPeTextField(
                    title: "Phone",
                    controller: authController.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    prefixIcon: Icons.person_outline,
                    hintText: "Enter Phone",
                  ),
                  const SizedBox(height: 24),
                  NesticoPeButton(
                    title: "Send OTP",
                    onTap:
                        () {
                          authController.forgotPassword(
                            id: authController.emailController.text.trim(),
                          );

                        }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/constants/color_res.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/bar/app_bar/common_bar.dart';
import '../../../widgets/button/button.dart';
import '../controllers/auth_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      appBar: const CommonNesticoPeAppBar(
        title: 'Forgot Password',
        showBackArrow: true,
        leadingIcon: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
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
                "Enter your phone number to receive OTP for password reset",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],

                ),
              ),
              const SizedBox(height: 32),

              // Phone input
              NesticoPeTextField(
                title: "Phone Number",
                controller: authController.phoneController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  }
                  if (value.length != 10) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: Icons.phone_outlined,
                hintText: "Enter your 10-digit phone number",
              ),
              const SizedBox(height: 24),

              // Send Instructions Button
              NesticoPeButton(
                title: "Send Instructions",
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    authController.forgotPassword(
                      id: authController.phoneController.text.trim(),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),

              // Secure password reset note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shield_outlined, size: 20, color: ColorRes.primary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Secure password reset process",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Back to Login Button
              SizedBox(
                width: 50,

                child: OutlinedButton.icon(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back to Login"),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: ColorRes.primary),

                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
