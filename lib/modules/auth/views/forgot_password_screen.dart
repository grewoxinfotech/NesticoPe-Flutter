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
                  //     fontWeight: FontWeight.w800,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  // Email Field
                  NesticoPeTextField(
                    title: "Email / Phone",
                    controller: authController.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                    prefixIcon: Icons.person_outline,
                    hintText: "Enter Email or Phone",
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
