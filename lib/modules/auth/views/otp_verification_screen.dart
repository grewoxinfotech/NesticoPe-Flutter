// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/modules/auth/controllers/auth_controller.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../widgets/button/button.dart';
// import 'package:housing_flutter_app/widgets/messages/snack_bar.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
//
// import '../../dashboard/views/dashboard_screen.dart';
// import 'ResetPasswordScreen.dart';
//
// enum VerifyOTPFor { registration, passwordReset, sellerRegister }
//
// class OtpVerificationScreen extends StatefulWidget {
//   final String phone;
//   final String? token;
//   final VerifyOTPFor verifyOTPFor;
//   // final bool isPasswordReset;
//   final Widget? redirectAfterOtp; // <- Dynamic redirection
//
//   const OtpVerificationScreen({
//     Key? key,
//     required this.phone,
//     this.token,
//     // this.isPasswordReset = false,
//     this.redirectAfterOtp,
//     required this.verifyOTPFor,
//   }) : super(key: key);
//
//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final _otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   bool _isLoading = false;
//   bool _isResending = false;
//   int _resendTimeout = 60;
//   Timer? _resendTimer;
//   String? _token;
//
//   @override
//   void initState() {
//     super.initState();
//     _startResendTimer();
//     _loadToken();
//   }
//
//   Future<void> _loadToken() async {
//     _token = widget.token;
//     print("Loaded _token: $_token");
//     print("Securestorage token: ${SecureStorage.getToken()}");
//   }
//
//   void _startResendTimer() {
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendTimeout > 0) {
//         setState(() => _resendTimeout--);
//       } else {
//         _resendTimer?.cancel();
//       }
//     });
//   }
//
//   // Future<void> _verifyOtp() async {
//   //   if (!_formKey.currentState!.validate()) return;
//   //
//   //   setState(() => _isLoading = true);
//   //
//   //   try {
//   //     final authController = Get.find<AuthController>();
//   //     final tokenToUse = _token ?? '';
//   //
//   //     if (tokenToUse.isEmpty) {
//   //       NesticoPeSnackBar.showAwesomeSnackbar(
//   //         title: "Error",
//   //         message: "Token not available. Cannot verify OTP",
//   //         contentType: ContentType.failure,
//   //       );
//   //       return;
//   //     }
//   //
//   //     if (widget.isPasswordReset) {
//   //       await authController.verifyPasswordResetOtp(
//   //         _otpController.text,
//   //         tokenToUse,
//   //       );
//   //       NesticoPeSnackBar.showAwesomeSnackbar(
//   //         title: 'Success',
//   //         message: 'OTP verified. Please set your new password.',
//   //         contentType: ContentType.success,
//   //       );
//   //
//   //       // Store token after successful verification
//   //       await SecureStorage.saveToken(tokenToUse);
//   //
//   //       Get.off(() => widget.redirectAfterOtp ?? ResetPasswordScreen());
//   //     } else {
//   //       await authController.verifyOtp(_otpController.text, tokenToUse);
//   //       NesticoPeSnackBar.showAwesomeSnackbar(
//   //         title: 'Success',
//   //         message: 'Account verified successfully!',
//   //         contentType: ContentType.success,
//   //       );
//   //
//   //       // Store token after successful verification
//   //       await SecureStorage.saveToken(tokenToUse);
//   //
//   //       Get.offAll(() => widget.redirectAfterOtp ?? const DashboardScreen());
//   //     }
//   //   } catch (e) {
//   //     NesticoPeSnackBar.showAwesomeSnackbar(
//   //       title: 'Error',
//   //       message: e.toString().replaceAll('Exception:', '').trim(),
//   //       contentType: ContentType.failure,
//   //     );
//   //   } finally {
//   //     setState(() => _isLoading = false);
//   //   }
//   // }
//
//   Future<void> _verifyOtp() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() => _isLoading = true);
//
//     try {
//       final tokenToUse = _getToken();
//       if (tokenToUse == null) return;
//
//       // if (widget.isPasswordReset) {
//       //   await _handlePasswordResetFlow(tokenToUse);
//       // } else {
//       //   await _handleSellerAccountVerificationFlow(tokenToUse);
//       // }
//       switch (widget.verifyOTPFor) {
//         case VerifyOTPFor.passwordReset:
//           await _handlePasswordResetFlow(tokenToUse);
//           break;
//         case VerifyOTPFor.sellerRegister:
//           await _handleSellerAccountVerificationFlow(tokenToUse);
//           break;
//         case VerifyOTPFor.registration:
//           break;
//       }
//     } catch (e) {
//       _showError(e);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }
//
//   /// ✅ Step 1: Get token safely
//   String? _getToken() {
//     final tokenToUse = _token ?? '';
//     if (tokenToUse.isEmpty) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: "Error",
//         message: "Token not available. Cannot verify OTP",
//         contentType: ContentType.failure,
//       );
//       return null;
//     }
//     return tokenToUse;
//   }
//
//   /// ✅ Step 2a: Handle password reset flow
//   Future<void> _handlePasswordResetFlow(String token) async {
//     print("[DEBUG]=> Handling password reset with token: $token");
//
//     final authController = Get.find<AuthController>();
//
//     await authController.verifyPasswordResetOtp(_otpController.text, token);
//
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Success',
//       message: 'OTP verified. Please set your new password.',
//       contentType: ContentType.success,
//     );
//
//     await SecureStorage.saveToken(token);
//
//     Get.off(() => widget.redirectAfterOtp ?? ResetPasswordScreen());
//   }
//
//   /// ✅ Step 2b: Handle normal account verification flow
//   Future<void> _handleSellerAccountVerificationFlow(String token) async {
//     print("[DEBUG]=> Handling account verification with token: $token");
//     final authController = Get.find<AuthController>();
//
//     await authController.verifyOtpSellerRegister(_otpController.text, token);
//
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Success',
//       message: 'Account verified successfully!',
//       contentType: ContentType.success,
//     );
//
//     await SecureStorage.saveToken(token);
//
//     Get.offAll(() => widget.redirectAfterOtp ?? const DashboardScreen());
//   }
//
//   /// ✅ Step 3: Show error
//   void _showError(Object e) {
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Error',
//       message: e.toString().replaceAll('Exception:', '').trim(),
//       contentType: ContentType.failure,
//     );
//   }
//
//   Future<void> _resendOtp() async {
//     if ((_token ?? widget.token) == null) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: "Error",
//         message: "Missing token. Cannot resend OTP",
//         contentType: ContentType.failure,
//       );
//       return;
//     }
//
//     setState(() => _isResending = true);
//
//     try {
//       final authController = Get.find<AuthController>();
//       // if (widget.isPasswordReset) {
//       //   await authController.forgotPassword(id: widget.phone);
//       // } else {
//       //   await authController.resendOtp(_token ?? widget.token!);
//       // }
//
//       setState(() => _resendTimeout = 60);
//       _startResendTimer();
//
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: "OTP Resent",
//         message: "New OTP sent to ${widget.phone}",
//         contentType: ContentType.success,
//       );
//     } catch (e) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: "Resend Failed",
//         message: e.toString(),
//         contentType: ContentType.failure,
//       );
//     } finally {
//       setState(() => _isResending = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _otpController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async => !_isLoading, // Prevent back while verifying
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Verify OTP'),
//           centerTitle: true,
//           elevation: 0,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(24),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 const SizedBox(height: 40),
//                 const Icon(Icons.verified_user, size: 80, color: Colors.blue),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Enter OTP',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Text('Sent to ${widget.phone}', textAlign: TextAlign.center),
//                 const SizedBox(height: 40),
//                 TextFormField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 24),
//                   decoration: InputDecoration(
//                     counterText: '',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     hintText: '••••••',
//                     filled: true,
//                     fillColor: Colors.grey[100],
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 12,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty)
//                       return 'Please enter OTP';
//                     if (value.length != 6) return 'OTP must be 6 digits';
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 30),
//                 NesticoPeButton(title: 'Enter OTP', onTap: _verifyOtp),
//                 const SizedBox(height: 20),
//                 TextButton(
//                   onPressed:
//                       (_resendTimeout > 0 || _isResending) ? null : _resendOtp,
//                   style: TextButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                   ),
//                   child:
//                       _isResending
//                           ? const SizedBox(
//                             width: 20,
//                             height: 20,
//                             child: CircularProgressIndicator(strokeWidth: 2),
//                           )
//                           : Text(
//                             _resendTimeout > 0
//                                 ? 'Resend OTP in $_resendTimeout seconds'
//                                 : 'Resend OTP',
//                             style: TextStyle(
//                               color:
//                                   (_resendTimeout > 0 || _isResending)
//                                       ? Colors.grey
//                                       : Theme.of(context).primaryColor,
//                             ),
//                           ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../../data/database/secure_storage_service.dart';
import '../../../widgets/button/button.dart';
import '../../../widgets/messages/snack_bar.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../dashboard/views/dashboard_screen.dart';
import 'ResetPasswordScreen.dart';

/// Enum to decide OTP verification flow
enum VerifyOTPFor { registration, passwordReset, sellerRegister }

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String? token;
  final VerifyOTPFor verifyOTPFor;
  final Widget? redirectAfterOtp;

  const OtpVerificationScreen({
    Key? key,
    required this.phone,
    this.token,
    required this.verifyOTPFor,
    this.redirectAfterOtp,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isResending = false;
  int _resendTimeout = 60;
  Timer? _resendTimer;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _startResendTimer();
  }

  Future<void> _loadToken() async {
    _token = widget.token;
    // debugPrint("Loaded token: $_token");
    // debugPrint("SecureStorage token: ${SecureStorage.getToken()}");
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimeout > 0) {
        setState(() => _resendTimeout--);
      } else {
        _resendTimer?.cancel();
      }
    });
  }

  /// ✅ Main OTP Verification
  Future<void> _verifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final tokenToUse = _getToken();
      if (tokenToUse == null) return;

      print("[DEBUG]=> ${widget.verifyOTPFor.toString()}");
      switch (widget.verifyOTPFor) {
        case VerifyOTPFor.passwordReset:
          await _handlePasswordResetFlow(tokenToUse);
          break;

        case VerifyOTPFor.sellerRegister:
          await _handleSellerAccountVerificationFlow(tokenToUse);
          break;

        case VerifyOTPFor.registration:
          await _handleRegistrationFlow(tokenToUse);
          break;
      }
    } catch (e) {
      _showError(e);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// ✅ Safe token fetch
  String? _getToken() {
    final tokenToUse = _token ?? '';
    if (tokenToUse.isEmpty) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Token not available. Cannot verify OTP",
        contentType: ContentType.failure,
      );
      return null;
    }
    return tokenToUse;
  }

  /// ✅ Password Reset Flow
  Future<void> _handlePasswordResetFlow(String token) async {
    final authController = Get.find<AuthController>();

    await authController.verifyPasswordResetOtp(_otpController.text, token);

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'OTP verified. Please set your new password.',
      contentType: ContentType.success,
    );

    await SecureStorage.saveToken(token);

    Get.off(() => widget.redirectAfterOtp ?? ResetPasswordScreen());
  }

  /// ✅ Seller Registration Flow
  Future<void> _handleSellerAccountVerificationFlow(String token) async {
    final authController = Get.find<AuthController>();

    await authController.verifyOtpSellerRegister(_otpController.text, token);

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'Seller account verified successfully!',
      contentType: ContentType.success,
    );

    await SecureStorage.saveToken(token);

    Get.offAll(() => widget.redirectAfterOtp ?? const DashboardScreen());
  }

  /// ✅ Normal Registration Flow
  Future<void> _handleRegistrationFlow(String token) async {
    final authController = Get.find<AuthController>();

    await authController.verifyOtp(_otpController.text, token);

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'Account verified successfully!',
      contentType: ContentType.success,
    );

    await SecureStorage.saveToken(token);

    Get.offAll(() => widget.redirectAfterOtp ?? const DashboardScreen());
  }

  /// ✅ Error Handler
  void _showError(Object e) {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Error',
      message: e.toString().replaceAll('Exception:', '').trim(),
      contentType: ContentType.failure,
    );
  }

  /// ✅ Resend OTP
  Future<void> _resendOtp() async {
    if ((_token ?? widget.token) == null) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: "Missing token. Cannot resend OTP",
        contentType: ContentType.failure,
      );
      return;
    }

    setState(() => _isResending = true);

    try {
      final authController = Get.find<AuthController>();

      switch (widget.verifyOTPFor) {
        case VerifyOTPFor.passwordReset:
          await authController.forgotPassword(id: widget.phone);
          break;
        case VerifyOTPFor.sellerRegister:
        case VerifyOTPFor.registration:
          await authController.resendOtp(_token ?? widget.token!);
          break;
      }

      setState(() => _resendTimeout = 60);
      _startResendTimer();

      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "OTP Resent",
        message: "New OTP sent to ${widget.phone}",
        contentType: ContentType.success,
      );
    } catch (e) {
      _showError(e);
    } finally {
      setState(() => _isResending = false);
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("Verify Otp For : ${widget.verifyOTPFor}");
    return WillPopScope(
      onWillPop: () async => !_isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Verify OTP'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Icon(Icons.verified_user, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                Text(
                  'Enter OTP',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text('Sent to ${widget.phone}', textAlign: TextAlign.center),
                const SizedBox(height: 40),

                /// OTP Field
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24, letterSpacing: 4),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: '••••••',
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 12,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter OTP';
                    }
                    if (value.length != 6) return 'OTP must be 6 digits';
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                /// Verify Button
                NesticoPeButton(
                  title: _isLoading ? 'Verifying...' : 'Enter OTP',
                  onTap: _isLoading ? null : _verifyOtp,
                ),

                const SizedBox(height: 20),

                /// Resend Button
                TextButton(
                  onPressed:
                      (_resendTimeout > 0 || _isResending) ? null : _resendOtp,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child:
                      _isResending
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text(
                            _resendTimeout > 0
                                ? 'Resend OTP in $_resendTimeout seconds'
                                : 'Resend OTP',
                            style: TextStyle(
                              color:
                                  (_resendTimeout > 0 || _isResending)
                                      ? Colors.grey
                                      : Theme.of(context).primaryColor,
                            ),
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
