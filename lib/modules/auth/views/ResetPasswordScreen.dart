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
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/widgets/New folder/inputs/text_field.dart';
// import 'package:nesticope_app/widgets/button/button.dart';
// import '../../../app/constants/color_res.dart';
// import '../../../widgets/bar/app_bar/common_bar.dart';
// import '../controllers/auth_controller.dart';

// class ResetPasswordScreen extends StatelessWidget {
//   ResetPasswordScreen({super.key});

//   final _formKey = GlobalKey<FormState>();
//   final AuthController authController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:  CommonNesticoPeAppBar(
//         title: 'Reset Password',
//         showBackArrow: true,
//         leadingIcon: Icons.arrow_back,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Title
//                 Icon(Icons.verified_user, size: 80, color: ColorRes.primary),
//                 const SizedBox(height: 20),
//                 Text(
//                   "Reset Password",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 26,
//                     fontWeight: FontWeight.bold,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 // Subtitle
//                 Text(
//                   "Enter your new password below and confirm it to reset your account password.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[700],
//                   ),
//                 ),
//                 const SizedBox(height: 32),

//                 // New Password Field
//                 NesticoPeTextField(
//                   title: "New Password",
//                   controller: authController.newPasswordController,
//                   obscureText: true,
//                   prefixIcon: Icons.lock_outline,
//                   hintText: "Enter new password",
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter new password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Confirm Password Field
//                 NesticoPeTextField(
//                   title: "Confirm Password",
//                   controller: authController.confirmPasswordController,
//                   obscureText: true,
//                   prefixIcon: Icons.lock_outline,
//                   hintText: "Confirm new password",
//                   validator: (value) {
//                     if (value != authController.newPasswordController.text) {
//                       return 'Passwords do not match';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 32),

//                 // Reset Button
//                 NesticoPeButton(
//                   title: "Reset Password",
//                   onTap: () {
//                     if (_formKey.currentState!.validate()) {
//                       authController.resetPassword();
//                     }
//                   },
//                 ),

//                 const SizedBox(height: 16),
//                 //
//                 // // Back to Login
//                 // OutlinedButton.icon(
//                 //   onPressed: () {
//                 //     Get.back();
//                 //
//                 //   } ,
//                 //   icon: const Icon(Icons.arrow_back),
//                 //   label: const Text("Back to Login"),
//                 //   style: OutlinedButton.styleFrom(
//                 //     shape: RoundedRectangleBorder(
//                 //       borderRadius: BorderRadius.circular(8),
//                 //     ),
//                 //     side: BorderSide(color: Colors.blue),
//                 //     padding: const EdgeInsets.symmetric(vertical: 14),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/widgets/New folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import '../../../app/constants/color_res.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  ResetPasswordScreen({super.key});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = Get.find();
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  /// Returns a strength label and fill fraction 0.0–1.0
  _PasswordStrength _checkStrength(String password) {
    if (password.isEmpty) return _PasswordStrength('', 0.0, Colors.transparent);
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 1) {
      return _PasswordStrength('WEAK', 0.25,  ColorRes.error);
    }

    if (score == 2) {
      return _PasswordStrength('FAIR', 0.5, 
       ColorRes.warning);
    }
    if (score == 3) {
      return _PasswordStrength('GOOD', 0.75,  ColorRes.primary);
    }

    return _PasswordStrength('STRONG', 1.0,  ColorRes.success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),

      // Plain AppBar matching previous screens
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        // centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.primary),
          onPressed: () => Get.back(),
        ),
         titleSpacing: 0,
          title: Image.asset(
            'assets/images/Nestico-Pe_Logo-svg.png',
            height: 48,
            width: 150,
            alignment: Alignment.centerLeft,
            fit: BoxFit.cover,
          ),
      ),

      // Bottom nav bar
      // bottomNavigationBar: Container(
      //   decoration: const BoxDecoration(
      //     color: Colors.white,
      //     border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      //   ),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(vertical: 10),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           _NavBarItem(icon: Icons.help_outline_rounded, label: 'HELP'),
      //           _NavBarItem(
      //             icon: Icons.chat_bubble_outline_rounded,
      //             label: 'SUPPORT',
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),

      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          color: ColorRes.white, // dark navy background
          image: DecorationImage(
            image: AssetImage('assets/images/apartment1.png'),
            fit: BoxFit.cover,
            // repeat: ImageRepeat.repeat,
            opacity: 0.08,
          ),
        ),
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
        // Left-aligned title
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: ColorRes.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          size: 36,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: const Text(
                        'Reset Password',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: ColorRes.textPrimary,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
              
                    const SizedBox(height: 8),
              
                    // Subtitle
                    Center(
                      child: Text(
                        'Choose a secure password to protect your\naccount and property data.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                          height: 1.6,
                        ),
                      ),
                    ),
              
                    const SizedBox(height: 32),
              
                    // NEW PASSWORD label
                    // Text(
                    //   'NEW PASSWORD',
                    //   style: TextStyle(
                    //     fontSize: 10.5,
                    //     fontWeight: FontWeight.w700,
                    //     color: Colors.grey.shade500,
                    //     letterSpacing: 0.9,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
              
                    // New Password field — reactive for strength
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: authController.newPasswordController,
                      builder: (context, value, _) {
                        final strength = _checkStrength(value.text);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            NesticoPeTextField(
                              title: 'New Password',
                              controller: authController.newPasswordController,
                              obscureText: !_showNewPassword,
                              prefixIcon: Icons.lock_outline_rounded,
                              hintText: '••••••••',
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showNewPassword = !_showNewPassword;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  child: Icon(
                                    _showNewPassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    size: 20,
                                    color:
                                        _showNewPassword
                                            ? ColorRes.primary
                                            : Colors.grey.shade400,
                                  ),
                                ),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (v) {
                                if (v == null || v.isEmpty)
                                  return 'Please enter new password';
                                if (v.length < 6)
                                  return 'Password must be at least 6 characters';
                                return null;
                              },
                            ),
              
                            // Strength bar
                            if (value.text.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  // Bar track
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Container(
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        FractionallySizedBox(
                                          widthFactor: strength.fraction,
                                          child: Container(
                                            height: 3,
                                            decoration: BoxDecoration(
                                              color: strength.color,
                                              borderRadius: BorderRadius.circular(
                                                4,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'STRENGTH: ${strength.label}',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: strength.color,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline_rounded,
                                    size: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Mix of symbols & numbers',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      },
                    ),
              
                    const SizedBox(height: 20),
              
                    // CONFIRM PASSWORD label
                    // Text(
                    //   'CONFIRM PASSWORD',
                    //   style: TextStyle(
                    //     fontSize: 10.5,
                    //     fontWeight: FontWeight.w700,
                    //     color: Colors.grey.shade500,
                    //     letterSpacing: 0.9,
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    NesticoPeTextField(
                      title: 'Confirm Password',
                      controller: authController.confirmPasswordController,
                      obscureText: !_showConfirmPassword,
                      prefixIcon: Icons.lock_reset_rounded,
                      hintText: '••••••••',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(
                            _showConfirmPassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color:
                                _showConfirmPassword
                                    ? ColorRes.primary
                                    : Colors.grey.shade400,
                          ),
                        ),
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (v) {
                        if (v != authController.newPasswordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
              
                    const SizedBox(height: 32),
              
                    // Reset Password button
                    NesticoPeButton(
                      title: 'Reset Password',
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          authController.resetPassword();
                        }
                      },
                      height: 52,
                    ),
              
                    const SizedBox(height: 24),
              
                    // Having trouble? Contact Support
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Having trouble? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
              
                            // height: 1.55,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: open support
                          },
                          child: const Text(
                            'Contact Support',
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
      ),
    );
  }
}

/// Simple data class for password strength
class _PasswordStrength {
  final String label;
  final double fraction;
  final Color color;
  const _PasswordStrength(this.label, this.fraction, this.color);
}

/// Bottom nav bar item
class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  const _NavBarItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: Colors.grey.shade400),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade400,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }
}
