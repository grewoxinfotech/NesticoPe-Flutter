// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../widgets/button/button.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';
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


//===================================================================OLD CODE=============

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/data/network/auth/service/auth_service.dart';

// import '../../../app/constants/color_res.dart';
// import '../../../data/database/secure_storage_service.dart';
// import '../../../utils/logger/app_logger.dart';
// import '../../../widgets/button/button.dart';
// import '../../../widgets/messages/snack_bar.dart';
// import '../../auth/controllers/auth_controller.dart';
// import '../../dashboard/views/dashboard_screen.dart';
// import 'ResetPasswordScreen.dart';

// /// Enum to decide OTP verification flow
// enum VerifyOTPFor { registration, passwordReset, sellerRegister }

// class OtpVerificationScreen extends StatefulWidget {
//   final String phone;
//   final String? token;
//   final VerifyOTPFor verifyOTPFor;
//   final Widget? redirectAfterOtp;
//   final Map<String, dynamic>? data;

//   const OtpVerificationScreen({
//     Key? key,
//     required this.phone,
//     this.token,
//     required this.verifyOTPFor,
//     this.redirectAfterOtp,
//     this.data,
//   }) : super(key: key);

//   @override
//   State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
// }

// class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
//   final _otpController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   bool _isLoading = false;
//   bool _isResending = false;
//   int _resendTimeout = 60;
//   Timer? _resendTimer;
//   String? _token;

//   @override
//   void initState() {
//     super.initState();
//     _loadToken();
//     _startResendTimer();
//   }

//   Future<void> _loadToken() async {
//     _token = widget.token;
//     // debugPrint("Loaded token: $_token");
//     // debugPrint("SecureStorage token: ${SecureStorage.getToken()}");
//   }

//   void _startResendTimer() {
//     _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_resendTimeout > 0) {
//         setState(() => _resendTimeout--);
//       } else {
//         _resendTimer?.cancel();
//       }
//     });
//   }

//   /// ✅ Main OTP Verification
//   Future<void> _verifyOtp() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => _isLoading = true);

//     try {
//       final tokenToUse = _getToken();
//       if (tokenToUse == null) return;

//       print("[DEBUG]=> ${widget.verifyOTPFor.toString()}");
//       switch (widget.verifyOTPFor) {
//         case VerifyOTPFor.passwordReset:
//           await _handlePasswordResetFlow(tokenToUse);
//           break;

//         case VerifyOTPFor.sellerRegister:
//           await _handleSellerAccountVerificationFlow(tokenToUse);
//           break;

//         case VerifyOTPFor.registration:
//           await _handleRegistrationFlow(tokenToUse,);
//           break;
//       }
//     } catch (e) {
//       _showError(e);
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   /// ✅ Safe token fetch
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

//   /// ✅ Password Reset Flow
//   Future<void> _handlePasswordResetFlow(String token) async {
//     final authController = Get.find<AuthController>();

//     await authController.verifyPasswordResetOtp(_otpController.text, token);

//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Success',
//       message: 'OTP verified. Please set your new password.',
//       contentType: ContentType.success,
//     );

//     await SecureStorage.saveToken(token);

//     Get.off(() => widget.redirectAfterOtp ?? ResetPasswordScreen());
//   }

//   /// ✅ Seller Registration Flow
//   // Future<void> _handleSellerAccountVerificationFlow(String token) async {
//   //   final authController = Get.find<AuthController>();
//   //
//   //   await authController.verifyOtpSellerRegister(_otpController.text, token);
//   //
//   //   final success = await authController.completeSellerRegistration(
//   //     widget.data ?? {},
//   //   );
//   //
//   //   NesticoPeSnackBar.showAwesomeSnackbar(
//   //     title: 'Success',
//   //     message: 'Seller account verified successfully!',
//   //     contentType: ContentType.success,
//   //   );
//   //
//   //   // await SecureStorage.saveToken(token);
//   //
//   //   Get.offUntil(
//   //     MaterialPageRoute(
//   //       builder: (_) => widget.redirectAfterOtp ?? const DashboardScreen(),
//   //     ),
//   //     (route) => route.isFirst,
//   //   );
//   // }

//   Future<void> _handleSellerAccountVerificationFlow(String token) async {
//     final authController = Get.find<AuthController>();

//     // Step 1: Verify OTP
//     await authController.verifyOtpSellerRegister(_otpController.text, token);

//     // Step 2: Complete seller registration
//     final success = await authController.completeSellerRegistration(
//       widget.data ?? {},
//     );

//     if (!success) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to complete registration.',
//         contentType: ContentType.failure,
//       );
//       return; // Stop navigation if registration fails
//     }

//     // Step 3: Success message and redirect
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Success',
//       message: 'Seller account verified and registration completed!',
//       contentType: ContentType.success,
//     );

//     Get.offUntil(
//       MaterialPageRoute(
//         builder: (_) => widget.redirectAfterOtp ?? const DashboardScreen(),
//       ),
//       (route) => route.isFirst,
//     );
//   }

//   /// ✅ Normal Registration Flow
//   Future<void> _handleRegistrationFlow(
//     String token) async {
//     final authController = Get.find<AuthController>();

//     await authController.verifyOtp(_otpController.text, token);




//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Success',
//       message: 'Account verified successfully!',
//       contentType: ContentType.success,
//     );

//     await SecureStorage.saveToken(token);

//     Get.offAll(() => widget.redirectAfterOtp ?? const DashboardScreen());
//   }

//   /// ✅ Error Handler
//   void _showError(Object e) {
//     NesticoPeSnackBar.showAwesomeSnackbar(
//       title: 'Error',
//       message: e.toString().replaceAll('Exception:', '').trim(),
//       contentType: ContentType.failure,
//     );
//   }

//   /// ✅ Resend OTP
//   Future<void> _resendOtp() async {
//     if ((_token ?? widget.token) == null) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: "Error",
//         message: "Missing token. Cannot resend OTP",
//         contentType: ContentType.failure,
//       );
//       return;
//     }

//     setState(() => _isResending = true);

//     try {
//       final authController = Get.find<AuthController>();

//       switch (widget.verifyOTPFor) {
//         case VerifyOTPFor.passwordReset:
//           await authController.forgotPassword(id: widget.phone);
//           break;
//         case VerifyOTPFor.sellerRegister:
//         case VerifyOTPFor.registration:
//           await authController.resendOtp(_token ?? widget.token!);
//           break;
//       }

//       setState(() => _resendTimeout = 60);
//       _startResendTimer();

//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: "OTP Resent",
//         message: "New OTP sent to ${widget.phone}",
//         contentType: ContentType.success,
//       );
//     } catch (e) {
//       _showError(e);
//     } finally {
//       setState(() => _isResending = false);
//     }
//   }

//   @override
//   void dispose() {
//     _otpController.dispose();
//     _resendTimer?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // print("Verify Otp For : ${widget.verifyOTPFor}");
//     return WillPopScope(
//       onWillPop: () async => !_isLoading,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Verify OTP'),
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
//                 Icon(Icons.verified_user, size: 80, color: ColorRes.blueColor),
//                 const SizedBox(height: 20),
//                 Text(
//                   'Enter OTP',
//                   style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     fontWeight: AppFontWeights.extraBold,
//                     // fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Text('Sent to ${widget.phone}', textAlign: TextAlign.center),
//                 const SizedBox(height: 40),

//                 /// OTP Field
//                 TextFormField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   maxLength: 6,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 24, letterSpacing: 4),
//                   decoration: InputDecoration(
//                     counterText: '',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     hintText: '••••••',
//                     filled: true,
//                     fillColor: ColorRes.leadGreyColor.shade100,
//                     contentPadding: const EdgeInsets.symmetric(
//                       vertical: 16,
//                       horizontal: 12,
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter OTP';
//                     }
//                     if (value.length != 6) return 'OTP must be 6 digits';
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 30),

//                 /// Verify Button
//                 NesticoPeButton(
//                   title: _isLoading ? 'Verifying...' : 'Enter OTP',
//                   onTap: _isLoading ? null : _verifyOtp,
//                 ),

//                 const SizedBox(height: 20),

//                 /// Resend Button
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
//                                       ? ColorRes.leadGreyColor
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
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/data/network/auth/service/auth_service.dart';
import 'package:flutter/services.dart';

import '../../../app/constants/color_res.dart';
import '../../../data/database/secure_storage_service.dart';
import '../../../utils/logger/app_logger.dart';
import '../../../widgets/button/button.dart';
import '../../../widgets/messages/snack_bar.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../dashboard/views/dashboard_screen.dart';
import 'ResetPasswordScreen.dart';

import 'package:nesticope_app/widgets/New folder/inputs/text_field.dart';

/// Enum to decide OTP verification flow
enum VerifyOTPFor { registration, passwordReset, sellerRegister }

class OtpVerificationScreen extends StatefulWidget {
  final String phone;
  final String? token;
  final VerifyOTPFor verifyOTPFor;
  final Widget? redirectAfterOtp;
  final Map<String, dynamic>? data;
  
  const OtpVerificationScreen({
    Key? key,
    required this.phone,
    this.token,
    required this.verifyOTPFor,
    this.redirectAfterOtp,
    this.data,
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
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  String get _otpValue => _otpControllers.map((c) => c.text).join();

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
          await _handleRegistrationFlow(tokenToUse,);
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

    await authController.verifyPasswordResetOtp(_otpValue, token);

    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'OTP verified. Please set your new password.',
      contentType: ContentType.success,
    );

    await SecureStorage.saveToken(token);

    Get.off(() => widget.redirectAfterOtp ?? ResetPasswordScreen());
  }

  /// ✅ Seller Registration Flow
  // Future<void> _handleSellerAccountVerificationFlow(String token) async {
  //   final authController = Get.find<AuthController>();
  //
  //   await authController.verifyOtpSellerRegister(_otpController.text, token);
  //
  //   final success = await authController.completeSellerRegistration(
  //     widget.data ?? {},
  //   );
  //
  //   NesticoPeSnackBar.showAwesomeSnackbar(
  //     title: 'Success',
  //     message: 'Seller account verified successfully!',
  //     contentType: ContentType.success,
  //   );
  //
  //   // await SecureStorage.saveToken(token);
  //
  //   Get.offUntil(
  //     MaterialPageRoute(
  //       builder: (_) => widget.redirectAfterOtp ?? const DashboardScreen(),
  //     ),
  //     (route) => route.isFirst,
  //   );
  // }

  Future<void> _handleSellerAccountVerificationFlow(String token) async {
    final authController = Get.find<AuthController>();

    // Step 1: Verify OTP
    await authController.verifyOtpSellerRegister(_otpValue, token);

    // Step 2: Complete seller registration
    final success = await authController.completeSellerRegistration(
      widget.data ?? {},
    );

    if (!success) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to complete registration.',
        contentType: ContentType.failure,
      );
      return; // Stop navigation if registration fails
    }

    // Step 3: Success message and redirect
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: 'Seller account verified and registration completed!',
      contentType: ContentType.success,
    );

    Get.offUntil(
      MaterialPageRoute(
        builder: (_) => widget.redirectAfterOtp ?? const DashboardScreen(),
      ),
      (route) => route.isFirst,
    );
  }

  /// ✅ Normal Registration Flow
  Future<void> _handleRegistrationFlow(
    String token) async {
    final authController = Get.find<AuthController>();

    await authController.verifyOtp(_otpValue, token);




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
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: ColorRes.primary, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
               'NesticoPe',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: ColorRes.primary,
            ),
          ),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.more_vert, color: ColorRes.primary, size: 20),
          //     onPressed: () {
          //      Get.to(() =>  ResetPasswordScreen());
          //     },
          //   ),
          // ],
          // centerTitle: true,
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
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: ColorRes.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_user_rounded,
                          size: 36,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontSize: 24,
                fontWeight: FontWeight.w800,
                color: ColorRes.textPrimary,
                letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Enter the OTP sent to your mobile number\n${_maskedPhone()}',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (i) => _otpBox(i)),
                    ),
                    const SizedBox(height: 24),
                    if (_resendTimeout > 0)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 15,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${(_resendTimeout ~/ 60).toString().padLeft(2, '0')}:${(_resendTimeout % 60).toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "DIDN'T RECEIVE THE CODE?  ",
                            style: TextStyle(
                              fontSize: 11,
                             color: Colors.grey.shade700,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                            ),
                          ),
                          GestureDetector(
                            onTap:
                                (_resendTimeout == 0 && !_isResending)
                                    ? _resendOtp
                                    : null,
                            child: Text(
                              _isResending ? 'Resending…' : 'Resend OTP',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    (_resendTimeout == 0 && !_isResending)
                                        ? ColorRes.primary
                                        : Colors.grey.shade500,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    NesticoPeButton(
                      title: _isLoading ? 'Verifying…' : 'Verify & Continue',
                      onTap: _isLoading ? null : _verifyOtp,
                      height: 48,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: ColorRes.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Secure Verification',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  color: ColorRes.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  'Your privacy and security are our top priorities.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                       fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Center(
                    //   child: TextButton(
                    //     onPressed: () => Navigator.of(context).pop(),
                    //     child: Text(
                    //       'Change Phone Number',
                    //       style: TextStyle(
                    //         color: Colors.grey.shade600,
                    //         fontSize: 13,
                    //         letterSpacing: 0.3,
                    //         fontWeight: FontWeight.w600,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                     SizedBox(height: 10),
                    _altButton(
                      icon: Icons.phone,
                      label: 'Change Phone Number',
                      onTap: () => Navigator.of(context).pop(),
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
  String _maskedPhone() {
    final s = widget.phone;
    if (s.isEmpty) return '+(91)••• ••• ••XX';
    final last2 = s.substring(s.length >= 2 ? s.length - 2 : 0);
    return '+(91)••• ••• ••$last2';
  }

  Widget _otpBox(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: SizedBox(
        width: 46,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  surface: const Color(0xFFE0E3E5),
                ),
          ),
          child: NesticoPeTextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            keyboardType: TextInputType.number,
            maxLength: 1,
            formatter: [FilteringTextInputFormatter.digitsOnly],
            hintText: '',
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (val) {
              if (val.isNotEmpty && index < 5) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
              } else if (val.isEmpty && index > 0) {
                FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
              }
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
