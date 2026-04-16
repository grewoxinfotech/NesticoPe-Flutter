// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
// import 'package:nesticope_app/modules/auth/views/forgot_password_screen.dart';
// import 'package:nesticope_app/modules/auth/views/select_account_type_screen.dart';
// import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/widgets/bar/app_bar/custom_appbar.dart';
//
// import '../../../app/constants/color_res.dart';
// import '../../../app/constants/font_res.dart';
// import '../../../app/constants/ic_res.dart';
// import '../../../app/utils/validation.dart';
// import '../../../widgets/New folder/inputs/text_field.dart';
// import '../../../widgets/bar/app_bar/common_bar.dart';
// import '../../../widgets/button/button.dart';
// import '../../../widgets/display/ic.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final AuthController authController = Get.put(AuthController());
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _formKey.currentState?.dispose();
//     super.dispose();
//   }
//
//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }
//
//   void _navigateToOtpLogin() {
//     Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (context) => const OtpLoginScreen()));
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Login Error'),
//             content: Text(message),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     authController.fillTestCredentials();
//     return Scaffold(
//       appBar: CommonNesticoPeAppBar(title: "Login", showBackArrow: true),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Logo and App Name
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.primary,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.home_work,
//                           size: 24,
//                           color: ColorRes.white,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'NesticoPe',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.subtitle,
//                           fontFamily: FontRes.nuNunitoSans,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: theme.colorScheme.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//
//                   // Login Title
//                   Text(
//                     'Login',
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       fontFamily: FontRes.nuNunitoSans,
//                       fontWeight: AppFontWeights.extraBold,
//                       color: ColorRes.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   // Email Field
//                   NesticoPeTextField(
//                     title: "Email / phone",
//                     controller: authController.emailController,
//                     validator: (value) => mixValidation(value ?? ''),
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     prefixIcon: Icons.person_outline,
//                     hintText: "Enter Email",
//                   ),
//
//                   const SizedBox(height: 16),
//
//                   NesticoPeTextField(
//                     title: "Password",
//                     controller: authController.passwordController,
//                     validator: (value) => passwordValidation(value ?? ''),
//                     obscureText: _isPasswordVisible,
//                     prefixIcon: Icons.lock_outline,
//                     autovalidateMode: AutovalidateMode.onUserInteraction,
//                     hintText: "Enter Password",
//                     suffixIcon: Container(
//                       height: 50,
//                       width: 50,
//                       alignment: Alignment.center,
//                       child: NesticoPeIc(
//                         iconPath: ICRes.viewPassword,
//                         onTap: _togglePasswordVisibility,
//                         height: 24,
//                         width: 24,
//                         color:
//                             _isPasswordVisible
//                                 ? Get.theme.colorScheme.outline
//                                 : Get.theme.colorScheme.primary,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   // Forgot Password aligned to right
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(() => ForgetPasswordScreen());
//                         },
//                         child: Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                             color: theme.colorScheme.primary,
//                             // fontWeight: FontWeight.bold,
//                             fontWeight: AppFontWeights.extraBold,
//                             fontFamily: FontRes.nuNunitoSans,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 24),
//
//                   // Login Button
//                   Obx(
//                     () => NesticoPeButton(
//                       title:
//                           authController.isLoading.value
//                               ? "Logging..."
//                               : "Login",
//                       backgroundColor:
//                           authController.isLoading.value
//                               ? ColorRes.primary.withOpacity(0.6)
//                               : ColorRes.primary,
//                       onTap:
//                           authController.isLoading.value
//                               ? null
//                               : () {
//                                 if (_formKey.currentState!.validate()) {
//                                   authController.login(
//                                     authController.emailController.text.trim(),
//                                     authController.passwordController.text
//                                         .trim(),
//                                   );
//                                 }
//                               },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const SizedBox(height: 24),
//
//                   // Register Link
//                   Center(
//                     child: SizedBox(
//                       width: double.infinity,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "Don't have an account?",
//                             style: TextStyle(
//                               color: ColorRes.leadGreyColor.shade700,
//                               fontFamily: FontRes.nuNunitoSans,
//                             ),
//                           ),
//                           TextButton(
//                             onPressed:
//                                 () => Get.to(
//                                   () => const SelectAccountTypeScreen(),
//                                 ),
//                             child: Text(
//                               'Sign Up here',
//                               style: TextStyle(
//                                 color: Get.theme.colorScheme.primary,
//                                 // fontWeight: FontWeight.bold,
//                                 fontWeight: AppFontWeights.extraBold,
//                                 fontFamily: FontRes.nuNunitoSans,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
// import 'package:nesticope_app/modules/auth/views/forgot_password_screen.dart';
// import 'package:nesticope_app/modules/auth/views/register_screen.dart';
// import 'package:nesticope_app/modules/auth/views/select_account_type_screen.dart';
// import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/widgets/bar/app_bar/custom_appbar.dart';

// import '../../../app/constants/color_res.dart';
// import '../../../app/constants/font_res.dart';
// import '../../../app/constants/ic_res.dart';
// import '../../../app/utils/validation.dart';
// import '../../../data/network/auth/model/user_model.dart';
// import '../../../widgets/New folder/inputs/text_field.dart';
// import '../../../widgets/bar/app_bar/common_bar.dart';
// import '../../../widgets/button/button.dart';
// import '../../../widgets/display/ic.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final AuthController authController = Get.put(AuthController());
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//   bool _hasAttemptedSubmit = false;

//   @override
//   void initState() {
//     super.initState();
//     // Reset form validation state when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _formKey.currentState?.reset();
//       setState(() {
//         _hasAttemptedSubmit = false;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }

//   void _navigateToOtpLogin() {
//     Navigator.of(
//       context,
//     ).push(MaterialPageRoute(builder: (context) => const OtpLoginScreen()));
//   }

//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder:
//           (context) => AlertDialog(
//             title: const Text('Login Error'),
//             content: Text(message),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(context).pop(),
//                 child: const Text('OK'),
//               ),
//             ],
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     authController.fillTestCredentials();

//     return Scaffold(
//       appBar: CommonNesticoPeAppBar(title: "Login", showBackArrow: true),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Logo and App Name
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.primary,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Icon(
//                           Icons.home_work,
//                           size: 24,
//                           color: ColorRes.white,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Text(
//                         'NesticoPe',
//                         style: TextStyle(
//                           fontSize: AppFontSizes.subtitle,
//                           fontFamily: FontRes.nuNunitoSans,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: theme.colorScheme.primary,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 40),

//                   // Login Title
//                   Text(
//                     'Login',
//                     style: theme.textTheme.headlineMedium?.copyWith(
//                       fontFamily: FontRes.nuNunitoSans,
//                       fontWeight: AppFontWeights.extraBold,
//                       color: ColorRes.textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Email Field
//                   NesticoPeTextField(
//                     title: "Email / phone",
//                     controller: authController.emailController,
//                     validator: (value) => mixValidation(value ?? ''),
//                     autovalidateMode:
//                         _hasAttemptedSubmit
//                             ? AutovalidateMode.onUserInteraction
//                             : AutovalidateMode.disabled,
//                     prefixIcon: Icons.person_outline,
//                     hintText: "Enter Email",
//                   ),

//                   const SizedBox(height: 16),

//                   // Password Field
//                   NesticoPeTextField(
//                     title: "Password",
//                     controller: authController.passwordController,
//                     validator: (value) => passwordValidation(value ?? ''),
//                     obscureText: !_isPasswordVisible,
//                     prefixIcon: Icons.lock_outline,
//                     autovalidateMode:
//                         _hasAttemptedSubmit
//                             ? AutovalidateMode.onUserInteraction
//                             : AutovalidateMode.disabled,
//                     hintText: "Enter Password",
//                     suffixIcon: Container(
//                       height: 50,
//                       width: 50,
//                       alignment: Alignment.center,
//                       child: NesticoPeIc(
//                         iconPath: ICRes.viewPassword,
//                         onTap: _togglePasswordVisibility,
//                         height: 24,
//                         width: 24,
//                         color:
//                             _isPasswordVisible
//                                 ? Get.theme.colorScheme.primary
//                                 : Get.theme.colorScheme.outline,
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 10),

//                   // Forgot Password
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(() => ForgetPasswordScreen());
//                         },
//                         child: Text(
//                           'Forgot Password?',
//                           style: TextStyle(
//                             color: theme.colorScheme.primary,
//                             fontWeight: AppFontWeights.extraBold,
//                             fontFamily: FontRes.nuNunitoSans,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 24),

//                   // Login Button
//                   Obx(
//                     () => NesticoPeButton(
//                       title:
//                           authController.isLoading.value
//                               ? "Logging..."
//                               : "Login",
//                       backgroundColor:
//                           authController.isLoading.value
//                               ? ColorRes.primary.withOpacity(0.6)
//                               : ColorRes.primary,
//                       onTap:
//                           authController.isLoading.value
//                               ? null
//                               : () {
//                                 setState(() {
//                                   _hasAttemptedSubmit = true;
//                                 });

//                                 if (_formKey.currentState!.validate()) {
//                                   authController.login(
//                                     authController.emailController.text.trim(),
//                                     authController.passwordController.text
//                                         .trim(),
//                                   );
//                                 }
//                               },
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const SizedBox(height: 24),

//                   // Register Link
//                   Center(
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           "Don't have an account?",
//                           style: TextStyle(
//                             color: ColorRes.leadGreyColor.shade700,
//                             fontFamily: FontRes.nuNunitoSans,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed:
//                               () =>
//                                   // Get.to(() => const SelectAccountTypeScreen()),
//                               Get.to(
//                                     () =>
//                                     RegisterScreen(role: UserRole.buyer),
//                               ),
//                           child: Text(
//                             'Sign Up here',
//                             style: TextStyle(
//                               color: Get.theme.colorScheme.primary,
//                               fontWeight: AppFontWeights.extraBold,
//                               fontFamily: FontRes.nuNunitoSans,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/auth/views/forgot_password_screen.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/bar/app_bar/common_bar.dart';
import 'package:nesticope_app/widgets/button/button.dart';

import '../../../app/constants/color_res.dart';
import '../../../app/constants/font_res.dart';
import '../../../app/utils/validation.dart';
import '../../../data/network/auth/model/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _hasAttemptedSubmit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _formKey.currentState?.reset();
      setState(() => _hasAttemptedSubmit = false);
    });
  }

  void _togglePasswordVisibility() {
    setState(() => _isPasswordVisible = !_isPasswordVisible);
  }

  void _onLoginTap() {
    setState(() => _hasAttemptedSubmit = true);
    if (_formKey.currentState!.validate()) {
      authController.login(
        authController.emailController.text.trim(),
        authController.passwordController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    authController.fillTestCredentials();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back, color: ColorRes.primary),
        ),
        // centerTitle: true,
        titleSpacing: 0,
        title: Image.asset(
          'assets/images/Nestico-Pe_Logo-svg.png',
          height: 48,
          width: 150,
          alignment: Alignment.centerLeft,
          fit: BoxFit.cover,
        ),
      ),
      // appBar: CommonNesticoPeAppBar(title: "Login", showBackArrow: true),
      body: Container(
        decoration: const BoxDecoration(
          color: ColorRes.white, // dark navy background
          image: DecorationImage(
            image: AssetImage('assets/images/apartment1.png'),
            fit: BoxFit.cover,

            repeat: ImageRepeat.repeat,
            opacity: 0.08,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // ── App Icon ────────────────────────────────────────────
                  Center(
                    child: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: ColorRes.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: ColorRes.primary.withOpacity(0.30),
                            blurRadius: 18,
                            offset: const Offset(0, 7),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'n',
                          style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── Brand Title ─────────────────────────────────────────
                  const Center(
                    child: Text(
                      'NesticoPe',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: ColorRes.primary,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // ── Subtitle ────────────────────────────────────────────
                  Center(
                    child: Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── EMAIL LABEL ─────────────────────────────────────────
                  // _label('EMAIL ADDRESS'),
                  // const SizedBox(height: 8),

                  // ── Email Field (NesticoPeTextField) ─────────────────────
                  Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                        surface: const Color(0xFFE0E3E5),
                      ),
                    ),
                    child: NesticoPeTextField(
                      title: "Email ID / Phone Number",

                      controller: authController.emailController,
                      validator: (value) => mixValidation(value ?? ''),
                      autovalidateMode:
                          _hasAttemptedSubmit
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                      prefixIcon: Icons.email_outlined,
                      hintText: "name@example.com",
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Forgot Password (Right-aligned) ─────────────────────

                  // ── Password Field (NesticoPeTextField) ──────────────────
                  Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                        surface: const Color(0xFFE0E3E5),
                      ),
                    ),
                    child: NesticoPeTextField(
                      title: "Password",
                      controller: authController.passwordController,
                      validator: (value) => passwordValidation(value ?? ''),
                      obscureText: !_isPasswordVisible,
                      prefixIcon: Icons.lock_outline_rounded,
                      autovalidateMode:
                          _hasAttemptedSubmit
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                      hintText: "Enter Password",
                      suffixIcon: GestureDetector(
                        onTap: _togglePasswordVisibility,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color:
                                _isPasswordVisible
                                    ? ColorRes.primary
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => Get.to(() => ForgetPasswordScreen()),
                        child: const Padding(
                          padding: EdgeInsets.only(right: 2, top: 2, bottom: 2),
                          child: Text(
                            'Forgot Password?',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorRes.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Login Button (NesticoPeButton) ──────────────────────
                  Obx(() {
                    final isLoading = authController.isLoading.value;
                    return NesticoPeButton(
                      title: isLoading ? "Logging..." : "Login",
                      onTap:
                          isLoading
                              ? null
                              : () {
                                setState(() {
                                  _hasAttemptedSubmit = true;
                                });
                                _onLoginTap();
                              },
                      backgroundColor:
                          isLoading
                              ? ColorRes.primary.withOpacity(0.6)
                              : ColorRes.primary,
                      height: 48,
                    );
                  }),

                  // const SizedBox(height: 24),

                  // // ── OR CONTINUE WITH divider ────────────────────────────
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: Divider(
                  //         color: Colors.grey.shade400,
                  //         thickness: 0.8,
                  //       ),
                  //     ),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 12),
                  //       child: Text(
                  //         'OR CONTINUE WITH',
                  //         style: TextStyle(
                  //           fontSize: 10,
                  //           color: Colors.grey.shade600,
                  //           letterSpacing: 1.0,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Divider(
                  //         color: Colors.grey.shade400,
                  //         thickness: 0.8,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // const SizedBox(height: 18),

                  // // ── Login with OTP ──────────────────────────────────────
                  // _altButton(
                  //   icon: Icons.grid_view_rounded,
                  //   label: 'Login with OTP',
                  //   onTap: () => Get.to(() => const OtpLoginScreen()),
                  // ),

                  // const SizedBox(height: 20),
                  //  _altButton(
                  //   icon: Icons.grid_view_rounded,
                  //   label: 'Login with Partner',
                  //   onTap: () => Get.to(() => const OtpLoginScreen(isPartner: true)),
                  // ),

                  // const SizedBox(height: 20),

                  // ── Login with Mobile Number ────────────────────────────
                  // _altButton(
                  //   icon: Icons.phone_android_rounded,
                  //   label: 'Login with Mobile Number',
                  //   onTap: () {
                  //     // Navigate to mobile number login
                  //   },
                  // ),

                  const SizedBox(height: 28),

                  // ── Sign Up Link ────────────────────────────────────────
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade700,
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap:
                              () => Get.to(
                                () => RegisterScreen(role: UserRole.buyer),
                              ),
                          child: const Text(
                            ' Sign Up',
                            style: TextStyle(
                              fontSize: 13,
                              color: ColorRes.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Secure Badge ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_rounded,
                        size: 11,
                        color: Colors.grey.shade500,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'SECURE BANK-LEVEL ENCRYPTION',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────── Helper Widgets ─────────────────────────────────

  Widget _label(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade700,
        letterSpacing: 0.9,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    bool obscure = false,
    bool autovalidate = false,
    Widget? suffix,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,

      autovalidateMode:
          autovalidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
      style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
      decoration: InputDecoration(
        hintText: hint,

        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade400),
        suffixIcon: suffix,
        filled: true,
        // Semi-transparent white fill — matches the frosted field look
        fillColor: Colors.white.withOpacity(0.75),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.7),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: ColorRes.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      ),
    );
  }

  Widget _loginButton({required bool isLoading, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isLoading
                    ? [ColorRes.primary, ColorRes.primary.withOpacity(0.2)]
                    : [ColorRes.primary, ColorRes.primary],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1e3a8a).withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLoading ? 'Logging in…' : 'Login',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
            if (!isLoading) ...[
              const SizedBox(width: 10),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 20,
              ),
            ],
            if (isLoading) ...[
              const SizedBox(width: 12),
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _altButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          // Semi-transparent white — matches screenshot frosted pill style
          color: Colors.white.withOpacity(0.72),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.85), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
