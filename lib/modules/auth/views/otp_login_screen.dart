import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/input/custom_text_field.dart';

class OtpLoginScreen extends StatefulWidget {
  const OtpLoginScreen({Key? key}) : super(key: key);

  @override
  _OtpLoginScreenState createState() => _OtpLoginScreenState();
}

class _OtpLoginScreenState extends State<OtpLoginScreen> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _otpFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final bool _isLoading = false;
  bool _otpSent = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    print('request OTP clicked');
    // if (_phoneFormKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //
    //   try {
    //     final authController = Provider.of<AuthController>(context, listen: false);
    //     final success = await authController.requestOtp(context,_phoneController.text.trim());
    //
    //     if (success) {
    //       setState(() {
    //         _otpSent = true;
    //       });
    //     } else {
    //       _showErrorDialog(authController.errorMessage ?? 'Failed to send OTP');
    //     }
    //   } catch (e) {
    //     _showErrorDialog('An unexpected error occurred: ${e.toString()}');
    //   } finally {
    //     if (mounted) {
    //       setState(() {
    //         _isLoading = false;
    //       });
    //     }
    //   }
    // }
  }

  // Future<void> _verifyOtp() async {
  //   if (_otpFormKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     try {
  //       final authController = Provider.of<AuthController>(context, listen: false);
  //       final success = await authController.verifyOtp(context,_otpController.text.trim());
  //
  //       if (success) {
  //         Navigator.of(context).pushReplacement(
  //           MaterialPageRoute(builder: (context) => HomeScreen())
  //         );
  //       } else {
  //         _showErrorDialog(authController.errorMessage ?? 'Invalid OTP');
  //       }
  //     } catch (e) {
  //       _showErrorDialog('An unexpected error occurred: ${e.toString()}');
  //     } finally {
  //       if (mounted) {
  //         setState(() {
  //           _isLoading = false;
  //         });
  //       }
  //     }
  //   }
  // }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_otpSent ? 'Verify OTP' : 'Login with OTP'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child:
              _otpSent
                  ? _buildOtpVerificationForm(theme)
                  : _buildPhoneForm(theme),
        ),
      ),
    );
  }

  Widget _buildPhoneForm(ThemeData theme) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Icon(
              Icons.phone_android,
              size: 100,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Enter your phone number',
            style: theme.textTheme.headlineSmall?.copyWith(
              // fontWeight: FontWeight.bold,
              fontWeight: AppFontWeights.extraBold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'We will send you a verification code',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ColorRes.leadGreyColor.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Phone Field
          NesticoPeTextField(
            controller: _phoneController,
            hintText: 'Phone Number',
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              // Add phone number validation if needed
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Submit Button
          // CustomButton(
          //   text: 'Send OTP',
          //   onPressed: _isLoading ? null : _requestOtp,
          //   isLoading: _isLoading,
          // ),
        ],
      ),
    );
  }

  Widget _buildOtpVerificationForm(ThemeData theme) {
    return Form(
      key: _otpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Illustration
          Container(
            height: 200,
            alignment: Alignment.center,
            child: Icon(Icons.sms, size: 100, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Verify OTP',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: AppFontWeights.extraBold,
              // fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Enter the verification code sent to ${_phoneController.text}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: ColorRes.leadGreyColor.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // OTP Field
          NesticoPeTextField(
            controller: _otpController,
            hintText: 'Enter OTP',
            keyboardType: TextInputType.number,
            prefixIcon: Icons.lock_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the OTP';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),

          // Resend OTP
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _isLoading ? null : _requestOtp,
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: AppFontWeights.medium,
                    // fontWeight: AppFontWeights.medium,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Verify Button
          // CustomButton(
          //   text: 'Verify & Login',
          //   onPressed: _isLoading ? null : _verifyOtp,
          //   isLoading: _isLoading,
          // ),

          // Change Number
          TextButton(
            onPressed: () {
              setState(() {
                _otpSent = false;
              });
            },
            child: Text(
              'Change Phone Number',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
