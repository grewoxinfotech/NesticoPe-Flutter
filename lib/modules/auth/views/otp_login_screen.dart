// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/app_font_sizes.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
// import 'package:nesticope_app/widgets/button/button.dart';
// import 'package:nesticope_app/data/network/auth/service/auth_service.dart';
// import 'package:nesticope_app/data/database/secure_storage_service.dart';
// import 'package:nesticope_app/widgets/messages/snack_bar.dart';

// class OtpLoginScreen extends StatefulWidget {
//   const OtpLoginScreen({Key? key}) : super(key: key);

//   @override
//   _OtpLoginScreenState createState() => _OtpLoginScreenState();
// }

// class _OtpLoginScreenState extends State<OtpLoginScreen> {
//   final _phoneFormKey = GlobalKey<FormState>();
//   final _otpFormKey = GlobalKey<FormState>();
//   final _phoneController = TextEditingController();
//   final _otpController = TextEditingController();

//   bool _otpSent = false;
//   bool _sending = false;
//   bool _verifying = false;
//   bool _resending = false;
//   int _resendSecondsLeft = 0;
//   Timer? _timer;

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _phoneController.dispose();
//     _otpController.dispose();
//     super.dispose();
//   }

//   void _startTimer() {
//     _timer?.cancel();
//     _resendSecondsLeft = 120;
//     setState(() {});
//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (!mounted) {
//         t.cancel();
//         return;
//       }
//       if (_resendSecondsLeft <= 1) {
//         t.cancel();
//         setState(() => _resendSecondsLeft = 0);
//       } else {
//         setState(() => _resendSecondsLeft -= 1);
//       }
//     });
//   }

//   Future<void> _requestOtp() async {
//     if (!_phoneFormKey.currentState!.validate()) return;
//     final id = _phoneController.text.trim();
//     setState(() => _sending = true);
//     final ok = await AuthService().requestOtpLogin(id);
//     setState(() => _sending = false);
//     if (ok) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'OTP Sent',
//         message: 'Please enter the OTP within 2 minutes',
//         contentType: ContentType.success,
//       );
//       setState(() {
//         _otpSent = true;
//         _startTimer();
//       });
//     } else {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to send OTP',
//         contentType: ContentType.failure,
//       );
//     }
//   }

//   Future<void> _verifyOtp() async {
//     if (!_otpFormKey.currentState!.validate()) return;
//     final otp = _otpController.text.trim();
//     setState(() => _verifying = true);
//     final user = await AuthService().verifyLoginOtp(otp);
//     setState(() => _verifying = false);
//     if (user != null) {
//       await SecureStorage.saveLoggedIn(true);
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Login Successful',
//         message: 'You have logged in successfully',
//         contentType: ContentType.success,
//       );
//       if (mounted) Navigator.of(context).pop(true);
//     } else {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Verification Failed',
//         message: 'Invalid or expired OTP',
//         contentType: ContentType.failure,
//       );
//     }
//   }

//   Future<void> _resendOtp() async {
//     if (_resendSecondsLeft > 0 || _resending) return;
//     setState(() => _resending = true);
//     final ok = await AuthService().resendLoginOtp();
//     setState(() => _resending = false);
//     if (ok) {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'OTP Resent',
//         message: 'A new OTP was sent. Please check',
//         contentType: ContentType.success,
//       );
//       _startTimer();
//     } else {
//       NesticoPeSnackBar.showAwesomeSnackbar(
//         title: 'Error',
//         message: 'Failed to resend OTP',
//         contentType: ContentType.failure,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(_otpSent ? 'Verify OTP' : 'Login with OTP'),
//         centerTitle: true,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//           child: _otpSent ? _buildOtp(theme) : _buildPhone(theme),
//         ),
//       ),
//     );
//   }

//   Widget _buildPhone(ThemeData theme) {
//     return Form(
//       key: _phoneFormKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 8),
//           Text(
//             'Welcome Back.',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w800,
//               color: ColorRes.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Enter your mobile number to securely access your portfolio.',
//             style: TextStyle(
//               fontSize: AppFontSizes.bodySmall,
//               color: ColorRes.leadGreyColor.shade700,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Theme(
//             data: theme.copyWith(
//               colorScheme: theme.colorScheme.copyWith(
//                 surface: const Color(0xFFE0E3E5),
//               ),
//             ),
//             child: NesticoPeTextField(
//               title: 'Mobile Number',
//               controller: _phoneController,
//               hintText: '0000000000',
//               keyboardType: TextInputType.phone,
//               prefixIcon: Icons.phone_outlined,
//               validator: (v) {
//                 final s = (v ?? '').trim();
//                 if (s.isEmpty) return 'Please enter your phone number';
//                 if (s.length != 10) return 'Enter 10-digit mobile number';
//                 return null;
//               },
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//             ),
//           ),
//           const SizedBox(height: 18),
//           NesticoPeButton(
//             title: _sending ? 'Sending...' : 'Send OTP',
//             onTap: _sending ? null : _requestOtp,
//             height: 50,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOtp(ThemeData theme) {
//     final masked = _phoneController.text.isNotEmpty
//         ? '+91 ${_phoneController.text.replaceRange(2, 8, '••••••')}'
//         : '';
//     return Form(
//       key: _otpFormKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 8),
//           Text(
//             'Verify OTP',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w800,
//               color: ColorRes.textPrimary,
//             ),
//             textAlign: TextAlign.left,
//           ),
//           const SizedBox(height: 6),
//           Text(
//             'Enter the OTP sent to your mobile number\n$masked',
//             style: TextStyle(
//               fontSize: AppFontSizes.bodySmall,
//               color: ColorRes.leadGreyColor.shade700,
//             ),
//           ),
//           const SizedBox(height: 20),
//           Theme(
//             data: theme.copyWith(
//               colorScheme: theme.colorScheme.copyWith(
//                 surface: const Color(0xFFE0E3E5),
//               ),
//             ),
//             child: NesticoPeTextField(
//               title: 'OTP',
//               controller: _otpController,
//               hintText: 'Enter 6-digit OTP',
//               keyboardType: TextInputType.number,
//               prefixIcon: Icons.lock_outline,
//               validator: (v) {
//                 final s = (v ?? '').trim();
//                 if (s.isEmpty) return 'Please enter OTP';
//                 if (s.length != 6) return 'Enter 6-digit OTP';
//                 return null;
//               },
//               autovalidateMode: AutovalidateMode.onUserInteraction,
//             ),
//           ),
//           const SizedBox(height: 12),
//           if (_resendSecondsLeft > 0)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(Icons.timer_outlined, size: 16, color: Colors.grey),
//                 const SizedBox(width: 6),
//                 Text(
//                   '00:${_resendSecondsLeft.toString().padLeft(2, '0')}',
//                   style: TextStyle(color: Colors.grey.shade600),
//                 ),
//               ],
//             ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Didn't receive the code? ",
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//               GestureDetector(
//                 onTap: _resendSecondsLeft == 0 && !_resending ? _resendOtp : null,
//                 child: Text(
//                   _resending ? 'Resending...' : 'Resend OTP',
//                   style: TextStyle(
//                     color: ColorRes.primary,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//           NesticoPeButton(
//             title: _verifying ? 'Verifying...' : 'Verify & Continue',
//             onTap: _verifying ? null : _verifyOtp,
//             height: 50,
//           ),
//           const SizedBox(height: 10),
//           TextButton(
//             onPressed: () => setState(() {
//               _otpSent = false;
//               _otpController.clear();
//               _timer?.cancel();
//               _resendSecondsLeft = 0;
//             }),
//             child: const Text('Change Phone Number'),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/network/auth/service/auth_service.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/in_app_messaging/service/in_app_messaging_service.dart';
import 'package:nesticope_app/data/network/user/service/notification_sync_service.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/auth/views/login_screen.dart';
import 'package:nesticope_app/modules/builder/view/builder_main_screen.dart';
import 'package:nesticope_app/modules/contractor/view/contractor_main.dart';
import 'package:nesticope_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:nesticope_app/services/notification_service.dart' as notif;

class OtpLoginScreen extends StatefulWidget {
  final bool isPartner;
  const OtpLoginScreen({Key? key, this.isPartner = false}) : super(key: key);

  @override
  _OtpLoginScreenState createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  AuthController authController =
      (Get.isRegistered<AuthController>())
          ? Get.find<AuthController>()
          : Get.put(AuthController());

  // 4 separate OTP box controllers + focus nodes
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _otpSent = false;
  bool _sending = false;
  bool _verifying = false;
  bool _resending = false;
  int _resendSecondsLeft = 0;
  Timer? _timer;

  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  static const Color _primaryBlue = Color(0xFF1e3a8a);
  static const Color _accentBlue = Color(0xFF2563eb);

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _termsRecognizer =
        TapGestureRecognizer()
          ..onTap = () => _openUrl('https://nesticope.com/terms');
    _privacyRecognizer =
        TapGestureRecognizer()
          ..onTap = () => _openUrl('https://nesticope.com/privacy');
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Unable to open',
        message: 'Could not open the link',
        contentType: ContentType.failure,
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _resendSecondsLeft = 120;
    setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSecondsLeft <= 1) {
        t.cancel();
        setState(() => _resendSecondsLeft = 0);
      } else {
        setState(() => _resendSecondsLeft -= 1);
      }
    });
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();

  Future<void> _requestOtp() async {
    if (!_phoneFormKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final ok = await AuthService().requestOtpLogin(
      _phoneController.text.trim(),
      module: widget.isPartner ? 'panel' : null,
    );

    setState(() => _sending = false);
    if (ok) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'OTP Sent',
        message: 'Please enter the OTP within 2 minutes',
        contentType: ContentType.success,
      );
      setState(() {
        _otpSent = true;
      });
      _startTimer();
    } else {
      // Error snackbar already handled inside AuthService.requestOtpLogin
      // Avoid showing a duplicate generic error here
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpValue;
    if (otp.length != 4) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Invalid OTP',
        message: 'Please enter all 4 digits',
        contentType: ContentType.failure,
      );
      return;
    }
    setState(() => _verifying = true);
    final user = await AuthService().verifyLoginOtp(otp);

    setState(() => _verifying = false);
    if (user != null) {
      await SecureStorage.saveLoggedIn(true);
      //  final user = await authService.login(email, password);

      print('Login With Otp ${user.user?.toJson()}');

      // 2️⃣ Save auth data
      await SecureStorage.saveToken(user.token!);
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);
      await SecureStorage.saveTermAndConditionValue(false.toString());

      // 3️⃣ Set user role/type
      await UserHelper.setUserType(
        user.user?.userType,
        sellerType: user.user?.sellerType,
        isAadharVerified: user.user?.isAadharVerified,
      );

      authController.currentUser.value = user;
      authController.authState.value = AuthState.authenticated;

      // 4️⃣ 🔔 NOTIFICATION SYNC
      final userId = user.user?.id?.toString();
      print('userId: $userId');
      print('role: ${UserHelper.userType?.name}');

      final role = UserHelper.userType?.name ?? 'buyer';

      if (userId != null && userId.isNotEmpty) {
        await notif.NotificationService.instance.attachLoggedInUser(
          userId: userId,
          role: role,
          syncToBackend: (playerId) async {
            // ✅ THIS IS THE SYNC POINT
            await NotificationSyncService.instance.syncToBackend(
              deviceToken: playerId,
              metadata: {'user_id': userId, 'role': role},
            );
          },
        );
      }

      // 5️⃣ Navigate (always LAST)
      if (UserHelper.userType == UserType.buyer) {
        Get.offAll(() => const DashboardScreen());
      } else if (UserHelper.userType == UserType.seller &&
          UserHelper.sellerType == SellerType.owner) {
        Get.offAll(() => const SellerDashboardScreen());
      } else if (UserHelper.userType == UserType.reseller) {
        Get.offAll(() => const MainNavigationScreen());
      } else if (UserHelper.userType == UserType.contractor) {
        Get.offAll(() => ContractorMainScreen());
      } else if (UserHelper.userType == UserType.seller &&
          UserHelper.sellerType == SellerType.builder) {
        Get.offAll(() => const BuilderMainScreen());
      } else {
        Get.offAll(() => const DashboardScreen());
      }
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Login Successful',
        message: 'You have logged in successfully',
        contentType: ContentType.success,
      );
      // if (mounted) Navigator.of(context).pop(true);
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Verification Failed',
        message: 'Invalid or expired OTP',
        contentType: ContentType.failure,
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_resendSecondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    final ok = await AuthService().resendLoginOtp();
    setState(() => _resending = false);
    if (ok) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'OTP Resent',
        message: 'A new OTP was sent. Please check',
        contentType: ContentType.success,
      );
      _startTimer();
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to resend OTP',
        contentType: ContentType.failure,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // Custom app bar to match screenshot
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder:
                (child, anim) => FadeTransition(opacity: anim, child: child),
            child:
                _otpSent
                    ? _buildOtpScreen(key: const ValueKey('otp'))
                    : _buildPhoneScreen(key: const ValueKey('phone')),
          ),
        ),
      ),
    );
  }

  // ── SCREEN 1: Phone Entry ─────────────────────────────────────────────────
  Widget _buildPhoneScreen({Key? key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Center(
        child: Form(
          key: _phoneFormKey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // House image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                        color: ColorRes.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Welcome heading
                    const Text(
                      'Welcome Back.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: ColorRes.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Enter your mobile number to securely access\nyour curated estate portfolio.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // MOBILE NUMBER label
                // Text(
                //   'MOBILE NUMBER',
                //   style: TextStyle(
                //     fontSize: 11,
                //     fontWeight: FontWeight.w700,
                //     color: Colors.grey.shade600,
                //     letterSpacing: 0.9,
                //   ),
                // ),
                // const SizedBox(height: 8),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(surface: const Color(0xFFE0E3E5)),
                  ),
                  child: NesticoPeTextField(
                    title: 'Mobile Number',
                    controller: _phoneController,
                    hintText: 'Enter your mobile number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Please enter your phone number';
                      if (s.length < 10) return 'Enter a valid phone number';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Send OTP button
                NesticoPeButton(
                  title: _sending ? 'Sending OTP…' : 'Send OTP',
                  onTap: _sending ? null : _requestOtp,
                  height: 48,
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 0.8,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR CONTINUE WITH',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade400,
                        thickness: 0.8,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Back to email login (pill button)
                _altButton(
                  icon: Icons.mail_rounded,
                  label: 'Login with Email',
                  onTap: () => Get.to(() => LoginScreen()),
                ),
                const SizedBox(height: 20),
                _altButton(
                  icon: Icons.person_rounded,
                  label: 'Login as Partner',
                  onTap:
                      () => Get.to(
                        () => const OtpLoginAsPartnerScreen(isPartner: true),
                      ),
                ),

                const SizedBox(height: 28),

                // Security badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 14,
                            color: ColorRes.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SECURED BY ARCHITECTURAL GRADE ENCRYPTION',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By continuing, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              recognizer: _termsRecognizer,
                              style: const TextStyle(
                                color: ColorRes.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              recognizer: _privacyRecognizer,
                              style: const TextStyle(
                                color: _accentBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
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
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SCREEN 2: OTP Verification ────────────────────────────────────────────
  Widget _buildOtpScreen({Key? key}) {
    final masked =
        _phoneController.text.isNotEmpty
            ? '+(91)••• ••• ••${_phoneController.text.substring(_phoneController.text.length >= 2 ? _phoneController.text.length - 2 : 0)}'
            : '+(91)••• ••• ••92';

    final minutes = (_resendSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSecondsLeft % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Shield icon circle
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ColorRes.white,
                // borderRadius: BorderRadius.circular(20),
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

          // Title
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

          // Subtitle with masked number
          Center(
            child: Text(
              'Enter the OTP sent to your mobile number\n$masked',
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

          // 6 OTP boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) => _otpBox(i)),
          ),

          const SizedBox(height: 24),

          // Timer
          if (_resendSecondsLeft > 0)
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
                    '$minutes:$seconds',
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

          // Resend row
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
                      _resendSecondsLeft == 0 && !_resending
                          ? _resendOtp
                          : null,
                  child: Text(
                    _resending ? 'Resending…' : 'Resend OTP',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          _resendSecondsLeft == 0 && !_resending
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

          // Verify & Continue button
          NesticoPeButton(
            title: _verifying ? 'Verifying…' : 'Verify & Continue',
            onTap: _verifying ? null : _verifyOtp,
            height: 48,
          ),

          const SizedBox(height: 20),

          // Secure Verification card
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

          // Change phone number
          // Center(
          //   child: TextButton(
          //     onPressed:
          //         () => setState(() {
          //           _otpSent = false;
          //           for (final c in _otpControllers) c.clear();
          //           _timer?.cancel();
          //           _resendSecondsLeft = 0;
          //         }),
          //     child: Text(
          //       'Change Phone Number',
          //       style: TextStyle(color: Colors.grey.shade600, fontSize: 13,
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
            onTap: () {
              setState(() {
                _otpSent = false;
                for (final c in _otpControllers) c.clear();
                _timer?.cancel();
                _resendSecondsLeft = 0;
              });
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Single OTP digit box ──────────────────────────────────────────────────
  Widget _otpBox(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 46,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(surface: const Color(0xFFE0E3E5)),
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
              if (val.isNotEmpty && index < _otpFocusNodes.length - 1) {
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

  // ── Primary gradient button ───────────────────────────────────────────────
  Widget _primaryButton({
    required String label,
    required bool isLoading,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isLoading
                    ? [const Color(0xFF5a7abf), const Color(0xFF5a7abf)]
                    : [const Color(0xFF1e3a8a), const Color(0xFF2563eb)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1e3a8a).withOpacity(0.32),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
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
}

class OtpLoginAsPartnerScreen extends StatefulWidget {
  final bool isPartner;
  const OtpLoginAsPartnerScreen({Key? key, this.isPartner = false})
    : super(key: key);

  @override
  _OtpLoginAsPartnerScreenState createState() =>
      _OtpLoginAsPartnerScreenState();
}

class _OtpLoginAsPartnerScreenState extends State<OtpLoginAsPartnerScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  AuthController authController =
      (Get.isRegistered<AuthController>())
          ? Get.find<AuthController>()
          : Get.put(AuthController());

  // 4 separate OTP box controllers + focus nodes
  final List<TextEditingController> _otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(4, (_) => FocusNode());

  bool _otpSent = false;
  bool _sending = false;
  bool _verifying = false;
  bool _resending = false;
  int _resendSecondsLeft = 0;
  Timer? _timer;
  late TapGestureRecognizer _termsRecognizer;
  late TapGestureRecognizer _privacyRecognizer;

  static const Color _primaryBlue = Color(0xFF1e3a8a);
  static const Color _accentBlue = Color(0xFF2563eb);

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (final c in _otpControllers) c.dispose();
    for (final f in _otpFocusNodes) f.dispose();
    _termsRecognizer.dispose();
    _privacyRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _termsRecognizer =
        TapGestureRecognizer()
          ..onTap = () => _openUrl('https://nesticope.com/terms');
    _privacyRecognizer =
        TapGestureRecognizer()
          ..onTap = () => _openUrl('https://nesticope.com/privacy');
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Unable to open',
        message: 'Could not open the link',
        contentType: ContentType.failure,
      );
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _resendSecondsLeft = 120;
    setState(() {});
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_resendSecondsLeft <= 1) {
        t.cancel();
        setState(() => _resendSecondsLeft = 0);
      } else {
        setState(() => _resendSecondsLeft -= 1);
      }
    });
  }

  String get _otpValue => _otpControllers.map((c) => c.text).join();

  Future<void> _requestOtp() async {
    if (!_phoneFormKey.currentState!.validate()) return;
    setState(() => _sending = true);
    final ok = await AuthService().requestOtpLogin(
      _phoneController.text.trim(),
      module: widget.isPartner ? 'panel' : null,
    );

    setState(() => _sending = false);
    if (ok) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'OTP Sent',
        message: 'Please enter the OTP within 2 minutes',
        contentType: ContentType.success,
      );
      setState(() {
        _otpSent = true;
      });
      _startTimer();
    } else {
      // Error snackbar already handled inside AuthService.requestOtpLogin
      // Avoid showing a duplicate generic error here
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpValue;
    if (otp.length != 4) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Invalid OTP',
        message: 'Please enter all 4 digits',
        contentType: ContentType.failure,
      );
      return;
    }
    setState(() => _verifying = true);
    final user = await AuthService().verifyLoginOtp(otp);

    setState(() => _verifying = false);
    if (user != null) {
      await SecureStorage.saveLoggedIn(true);
      //  final user = await authService.login(email, password);

      print('Login With Otp ${user.user?.toJson()}');

      // 2️⃣ Save auth data
      await SecureStorage.saveToken(user.token!);
      await SecureStorage.saveUserData(user);
      await SecureStorage.saveLoggedIn(true);
      await SecureStorage.saveTermAndConditionValue(false.toString());

      // 3️⃣ Set user role/type
      await UserHelper.setUserType(
        user.user?.userType,
        sellerType: user.user?.sellerType,
        isAadharVerified: user.user?.isAadharVerified,
      );

      authController.currentUser.value = user;
      authController.authState.value = AuthState.authenticated;

      // 4️⃣ 🔔 NOTIFICATION SYNC
      final userId = user.user?.id?.toString();
      print('userId: $userId');
      print('role: ${UserHelper.userType?.name}');

      final role = UserHelper.userType?.name ?? 'buyer';

      if (userId != null && userId.isNotEmpty) {
        await notif.NotificationService.instance.attachLoggedInUser(
          userId: userId,
          role: role,
          syncToBackend: (playerId) async {
            // ✅ THIS IS THE SYNC POINT
            await NotificationSyncService.instance.syncToBackend(
              deviceToken: playerId,
              metadata: {'user_id': userId, 'role': role},
            );
          },
        );
      }

      // 5️⃣ Navigate (always LAST)
      if (UserHelper.userType == UserType.buyer) {
        Get.offAll(() => const DashboardScreen());
      } else if (UserHelper.userType == UserType.seller &&
          UserHelper.sellerType == SellerType.owner) {
        Get.offAll(() => const SellerDashboardScreen());
      } else if (UserHelper.userType == UserType.reseller) {
        Get.offAll(() => const MainNavigationScreen());
      } else if (UserHelper.userType == UserType.contractor) {
        Get.offAll(() => ContractorMainScreen());
      } else if (UserHelper.userType == UserType.seller &&
          UserHelper.sellerType == SellerType.builder) {
        Get.offAll(() => const BuilderMainScreen());
      } else {
        Get.offAll(() => const DashboardScreen());
      }
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Login Successful',
        message: 'You have logged in successfully',
        contentType: ContentType.success,
      );
      // if (mounted) Navigator.of(context).pop(true);
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Verification Failed',
        message: 'Invalid or expired OTP',
        contentType: ContentType.failure,
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_resendSecondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    final ok = await AuthService().resendLoginOtp();
    setState(() => _resending = false);
    if (ok) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'OTP Resent',
        message: 'A new OTP was sent. Please check',
        contentType: ContentType.success,
      );
      _startTimer();
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to resend OTP',
        contentType: ContentType.failure,
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // Custom app bar to match screenshot
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder:
                (child, anim) => FadeTransition(opacity: anim, child: child),
            child:
                _otpSent
                    ? _buildOtpScreen(key: const ValueKey('otp'))
                    : _buildPhoneScreen(key: const ValueKey('phone')),
          ),
        ),
      ),
    );
  }

  // ── SCREEN 1: Phone Entry ─────────────────────────────────────────────────
  Widget _buildPhoneScreen({Key? key}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Center(
        child: Form(
          key: _phoneFormKey,
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // House image
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.account_circle_outlined,
                        size: 40,
                        color: ColorRes.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Welcome heading
                    const Text(
                      'Login as Partner',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: ColorRes.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      'Enter your mobile number to securely access\nyour curated estate portfolio.',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                // MOBILE NUMBER label
                // Text(
                //   'MOBILE NUMBER',
                //   style: TextStyle(
                //     fontSize: 11,
                //     fontWeight: FontWeight.w700,
                //     color: Colors.grey.shade600,
                //     letterSpacing: 0.9,
                //   ),
                // ),
                // const SizedBox(height: 8),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(
                      context,
                    ).colorScheme.copyWith(surface: const Color(0xFFE0E3E5)),
                  ),
                  child: NesticoPeTextField(
                    title: 'Mobile Number',
                    controller: _phoneController,
                    hintText: 'Enter your mobile number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone_outlined,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    formatter: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (v) {
                      final s = (v ?? '').trim();
                      if (s.isEmpty) return 'Please enter your phone number';
                      if (s.length < 10) return 'Enter a valid phone number';
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Send OTP button
                NesticoPeButton(
                  title: _sending ? 'Sending OTP…' : 'Send OTP',
                  onTap: _sending ? null : _requestOtp,
                  height: 48,
                ),

                // const SizedBox(height: 24),
                //    Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           color: Colors.grey.shade400,
                //           thickness: 0.8,
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 12),
                //         child: Text(
                //           'OR CONTINUE WITH',
                //           style: TextStyle(
                //             fontSize: 10,
                //             color: Colors.grey.shade600,
                //             letterSpacing: 1.0,
                //             fontWeight: FontWeight.w600,
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           color: Colors.grey.shade400,
                //           thickness: 0.8,
                //         ),
                //       ),
                //     ],
                //   ),

                //   const SizedBox(height: 18),

                // // Back to email login (pill button)
                // _altButton(
                //   icon: Icons.mail_rounded,
                //   label: 'Login with Email',
                //   onTap: () => Get.to(() =>  LoginScreen()),
                // ),
                // const SizedBox(height: 20),
                //   _altButton(
                //     icon: Icons.grid_view_rounded,
                //     label: 'Login with Partner',
                //     onTap: () => Get.to(() => const OtpLoginScreen(isPartner: true)),
                //   ),
                const SizedBox(height: 28),

                // Security badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            size: 14,
                            color: ColorRes.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'SECURED BY ARCHITECTURAL GRADE ENCRYPTION',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              letterSpacing: 0.6,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                          children: [
                            const TextSpan(
                              text: 'By continuing, you agree to our ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              recognizer: _termsRecognizer,
                              style: const TextStyle(
                                color: ColorRes.primary,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              recognizer: _privacyRecognizer,
                              style: const TextStyle(
                                color: _accentBlue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
              ],
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
                fontSize: 13,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── SCREEN 2: OTP Verification ────────────────────────────────────────────
  Widget _buildOtpScreen({Key? key}) {
    final masked =
        _phoneController.text.isNotEmpty
            ? '+(91)••• ••• ••${_phoneController.text.substring(_phoneController.text.length >= 2 ? _phoneController.text.length - 2 : 0)}'
            : '+(91)••• ••• ••92';

    final minutes = (_resendSecondsLeft ~/ 60).toString().padLeft(2, '0');
    final seconds = (_resendSecondsLeft % 60).toString().padLeft(2, '0');

    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),

          // Shield icon circle
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: ColorRes.white,
                // borderRadius: BorderRadius.circular(20),
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

          // Title
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

          // Subtitle with masked number
          Center(
            child: Text(
              'Enter the OTP sent to your mobile number\n$masked',
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

          // 6 OTP boxes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (i) => _otpBox(i)),
          ),

          const SizedBox(height: 24),

          // Timer
          if (_resendSecondsLeft > 0)
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
                    '$minutes:$seconds',
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

          // Resend row
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
                      _resendSecondsLeft == 0 && !_resending
                          ? _resendOtp
                          : null,
                  child: Text(
                    _resending ? 'Resending…' : 'Resend OTP',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          _resendSecondsLeft == 0 && !_resending
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

          // Verify & Continue button
          NesticoPeButton(
            title: _verifying ? 'Verifying…' : 'Verify & Continue',
            onTap: _verifying ? null : _verifyOtp,
            height: 48,
          ),

          const SizedBox(height: 20),

          // Secure Verification card
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

          // Change phone number
          // Center(
          //   child: TextButton(
          //     onPressed:
          //         () => setState(() {
          //           _otpSent = false;
          //           for (final c in _otpControllers) c.clear();
          //           _timer?.cancel();
          //           _resendSecondsLeft = 0;
          //         }),
          //     child: Text(
          //       'Change Phone Number',
          //       style: TextStyle(color: Colors.grey.shade600, fontSize: 13,
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
            onTap: () {
              setState(() {
                _otpSent = false;
                for (final c in _otpControllers) c.clear();
                _timer?.cancel();
                _resendSecondsLeft = 0;
              });
            },
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Single OTP digit box ──────────────────────────────────────────────────
  Widget _otpBox(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 46,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(surface: const Color(0xFFE0E3E5)),
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
              if (val.isNotEmpty && index < _otpFocusNodes.length - 1) {
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

  // ── Primary gradient button ───────────────────────────────────────────────
  Widget _primaryButton({
    required String label,
    required bool isLoading,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 54,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:
                isLoading
                    ? [const Color(0xFF5a7abf), const Color(0xFF5a7abf)]
                    : [const Color(0xFF1e3a8a), const Color(0xFF2563eb)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1e3a8a).withOpacity(0.32),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
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
}
