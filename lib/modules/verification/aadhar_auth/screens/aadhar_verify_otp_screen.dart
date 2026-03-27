import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';
import '../controllers/aadhar_auth_controller.dart';

class AadharVerifyOTPScreen extends StatelessWidget {
  AadharVerifyOTPScreen({super.key});

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final AadharAuthController controller = Get.find<AadharAuthController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP'), centerTitle: true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),

                  // Header section
                  const Icon(
                    Icons.message_outlined,
                    size: 80,
                    color: ColorRes.primary,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Enter OTP',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Obx(() {
                    final aadharNum = controller.aadharNumber.value;
                    final maskedNumber =
                        aadharNum.length >= 4
                            ? 'XXXX XXXX ${aadharNum.substring(aadharNum.length - 4)}'
                            : 'XXXX XXXX XXXX';

                    return Text(
                      'We have sent a verification code to\nAadhar: $maskedNumber',
                      textAlign: TextAlign.center,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    );
                  }),

                  const SizedBox(height: 40),

                  // OTP Input Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,
                        height: 60,
                        child: TextFormField(
                          controller: otpControllers[index],
                          focusNode: focusNodes[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: ColorRes.primary,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: ColorRes.primary,
                                width: 2,
                              ),
                            ),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            if (value.isNotEmpty && index < 5) {
                              focusNodes[index + 1].requestFocus();
                            } else if (value.isEmpty && index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 32),

                  // Verify button
                  Obx(() {
                    final isLoading = controller.isLoading.value;
                    return SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            isLoading
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final otp =
                                        otpControllers
                                            .map((c) => c.text)
                                            .join();

                                    if (otp.length != 6) {
                                      NesticoPeSnackBar.showAwesomeSnackbar(
                                        title: 'Invalid OTP',
                                        message: 'Please enter all 6 digits',
                                        contentType: ContentType.failure,
                                      );
                                      return;
                                    }

                                    final success = await controller
                                        .verifyAadharOtp(otp);

                                    if (success) {
                                      NesticoPeSnackBar.showAwesomeSnackbar(
                                        title: 'Success',
                                        message:
                                            'Aadhar verified successfully!',
                                        contentType: ContentType.success,
                                      );

                                      await Future.delayed(
                                        const Duration(milliseconds: 300),
                                      );

                                      if (Get.isSnackbarOpen) {
                                        Get.closeCurrentSnackbar();
                                      }

                                      Get.back(); // OTP screen
                                      Get.back(); // Aadhaar screen
                                    }
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isLoading
                                  ? ColorRes.primary.withOpacity(0.6)
                                  : ColorRes.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:
                            isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                                : const Text(
                                  'Verify OTP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                      ),
                    );
                  }),

                  const SizedBox(height: 24),

                  // Resend OTP
                  TextButton(
                    onPressed: () {
                      // Clear OTP fields
                      for (var controller in otpControllers) {
                        controller.clear();
                      }
                      focusNodes[0].requestFocus();

                      // Resend OTP
                      controller.initiateAadharVerification(
                        controller.aadharNumber.value,
                      );
                    },
                    child: const Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Info section
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          color: Colors.orange.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'OTP is valid for 10 minutes. If you don\'t receive it, tap Resend OTP',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.orange.shade900,
                            ),
                          ),
                        ),
                      ],
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
