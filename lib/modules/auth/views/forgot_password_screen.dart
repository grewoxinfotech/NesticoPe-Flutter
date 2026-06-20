/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/widgets/bar/app_bar/common_bar.dart';

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
                  //     fontFamily: FontRes.poppins,
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

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../app/constants/color_res.dart';
// import '../../../widgets/New folder/inputs/text_field.dart';
// import '../../../widgets/bar/app_bar/common_bar.dart';
// import '../../../widgets/button/button.dart';
// import '../controllers/auth_controller.dart';

// class ForgetPasswordScreen extends StatelessWidget {
//   ForgetPasswordScreen({super.key});

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final AuthController authController = Get.put(AuthController());

//     return Scaffold(
//       appBar: const CommonNesticoPeAppBar(
//         title: 'Forgot Password',
//         showBackArrow: true,
//         leadingIcon: Icons.arrow_back,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               // Title

//               Icon(Icons.verified_user, size: 80, color: ColorRes.primary),
//               const SizedBox(height: 20),
//               Text(
//                 "Reset Password",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: ColorRes.primary,
//                 ),
//               ),
//               const SizedBox(height: 12),
//               // Subtitle
//               Text(
//                 "Enter your phone number to receive OTP for password reset",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey[700],

//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Phone input
//               NesticoPeTextField(
//                 title: "Phone Number",
//                 controller: authController.phoneController,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter phone number';
//                   }
//                   if (value.length != 10) {
//                     return 'Enter a valid 10-digit phone number';
//                   }
//                   return null;
//                 },
//                 autovalidateMode: AutovalidateMode.onUserInteraction,
//                 prefixIcon: Icons.phone_outlined,
//                 hintText: "Enter your 10-digit phone number",
//               ),
//               const SizedBox(height: 24),

//               // Send Instructions Button
//               NesticoPeButton(
//                 title: "Send Instructions",
//                 onTap: () {
//                   if (_formKey.currentState!.validate()) {
//                     authController.forgotPassword(
//                       id: authController.phoneController.text.trim(),
//                     );
//                   }
//                 },
//               ),
//               const SizedBox(height: 12),

//               // Secure password reset note
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: ColorRes.primary.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: const [
//                     Icon(Icons.shield_outlined, size: 20, color: ColorRes.primary),
//                     SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         "Secure password reset process",
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: ColorRes.primary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Back to Login Button
//               SizedBox(
//                 width: 50,

//                 child: OutlinedButton.icon(
//                   onPressed: () => Get.back(),
//                   icon: const Icon(Icons.arrow_back),
//                   label: const Text("Back to Login"),
//                   style: OutlinedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     side: BorderSide(color: ColorRes.primary),

//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/constants/color_res.dart';
import '../../../widgets/New folder/inputs/text_field.dart';
import '../../../widgets/button/button.dart';
import '../controllers/auth_controller.dart';

class ForgetPasswordScreen extends StatefulWidget {

  ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.put(AuthController());
    bool _sending = false;

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // centerTitle: true,
         title: Image.asset(
            'assets/images/Nestico-Pe_Logo-svg.png',
            height: 48,
            width: 150,
            alignment: Alignment.centerLeft,
            fit: BoxFit.cover,
          ),
      ),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  // Restore icon in rounded square
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        size: 36,
                        color: ColorRes.primary,
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 24),
          
                  // Title
                  const Text(
                    'Restore Access',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: ColorRes.textPrimary,
                      letterSpacing: -0.3,
                    ),
                  ),
          
                  const SizedBox(height: 10),
          
                  // Subtitle
                  Text(
                    'Enter your details to receive a\nsecure verification link.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                    ),
                  ),
          
                  const SizedBox(height: 32),
          
                  // Input card
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Field label
                        // Text(
                        //   'MOBILE NUMBER',
                        //   style: TextStyle(
                        //     fontSize: 10.5,
                        //     fontWeight: FontWeight.w700,
                        //     color: Colors.grey.shade500,
                        //     letterSpacing: 0.9,
                        //   ),
                        // ),
          
                        // const SizedBox(height: 8),
          
                        // Phone field
                        NesticoPeTextField(
                          title: 'Mobile Number',
                          controller: authController.phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          hintText: 'Enter your 10-digit number',
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          formatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(10),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
          
                        const SizedBox(height: 8),
          
                        // Helper text
                        Text(
                          "We'll verify your account identity first.",
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
          
                  const SizedBox(height: 24),
          
                  // Send Reset Link / OTP button
                  NesticoPeButton(
                    title: _sending ? 'Sending...' : 'Send OTP',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        // setState(() => _sending = true);
                        authController.forgotPassword(
                          id: authController.phoneController.text.trim(),
                        );
                        //  setState(() => _sending = false);
                        // 
                        //setState(() {
                        //   _sending = false;
                        // });
                      }
                    },
                    height: 48,
                  ),
          
                  const SizedBox(height: 28),
          
                  // Remembered your password? Log In
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Remembered your password? ",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ColorRes.primary,
                          ),
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
}