import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
import 'package:housing_flutter_app/modules/auth/views/forgot_password_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/select_account_type_screen.dart';
import 'package:housing_flutter_app/modules/auth/views/otp_login_screen.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/widgets/bar/app_bar/custom_appbar.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/constants/font_res.dart';
import '../../../app/constants/ic_res.dart';
import '../../../app/utils/validation.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/bar/app_bar/common_bar.dart';
import '../../../widgets/button/button.dart';
import '../../../widgets/display/ic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _navigateToOtpLogin() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const OtpLoginScreen()));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Login Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    authController.fillTestCredentials();
    return Scaffold(
      appBar: CommonNesticoPeAppBar(title: "Login", showBackArrow: true),
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
                  // Logo and App Name
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.home_work,
                          size: 24,
                          color: ColorRes.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NesticoPe',
                        style: TextStyle(
                          fontSize: AppFontSizes.subtitle,
                          fontFamily: FontRes.nuNunitoSans,
                          fontWeight: AppFontWeights.extraBold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Login Title
                  Text(
                    'Login',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontFamily: FontRes.nuNunitoSans,
                      fontWeight: AppFontWeights.extraBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email Field
                  NesticoPeTextField(
                    title: "Email / phone",
                    controller: authController.emailController,
                    validator: (value) => mixValidation(value ?? ''),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    prefixIcon: Icons.person_outline,
                    hintText: "Enter Email",
                  ),

                  const SizedBox(height: 16),

                  NesticoPeTextField(
                    title: "Password",
                    controller: authController.passwordController,
                    validator: (value) => passwordValidation(value ?? ''),
                    obscureText: _isPasswordVisible,
                    prefixIcon: Icons.lock_outline,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    hintText: "Enter Password",
                    suffixIcon: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: NesticoPeIc(
                        iconPath: ICRes.viewPassword,
                        onTap: _togglePasswordVisibility,
                        height: 24,
                        width: 24,
                        color:
                            _isPasswordVisible
                                ? Get.theme.colorScheme.outline
                                : Get.theme.colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Forgot Password aligned to right
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ForgetPasswordScreen());
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            // fontWeight: FontWeight.bold,
                            fontWeight: AppFontWeights.extraBold,
                            fontFamily: FontRes.nuNunitoSans,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  Obx(
                    () => NesticoPeButton(
                      title:
                          authController.isLoading.value
                              ? "Logging..."
                              : "Login",
                      backgroundColor:
                          authController.isLoading.value
                              ? ColorRes.primary.withOpacity(0.6)
                              : ColorRes.primary,
                      onTap:
                          authController.isLoading.value
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  authController.login(
                                    authController.emailController.text.trim(),
                                    authController.passwordController.text
                                        .trim(),
                                  );
                                }
                              },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 24),

                  // Register Link
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                              color: ColorRes.leadGreyColor.shade700,
                              fontFamily: FontRes.nuNunitoSans,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                () => Get.to(
                                  () => const SelectAccountTypeScreen(),
                                ),
                            child: Text(
                              'Sign Up here',
                              style: TextStyle(
                                color: Get.theme.colorScheme.primary,
                                // fontWeight: FontWeight.bold,
                                fontWeight: AppFontWeights.extraBold,
                                fontFamily: FontRes.nuNunitoSans,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
