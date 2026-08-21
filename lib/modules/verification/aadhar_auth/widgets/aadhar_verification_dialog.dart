import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/utils/helper_function/user_helper/user_helper.dart';
import '../../../../data/network/verification/aadhar_auth/service/aadhar_auth_service.dart';
import '../../../../widgets/messages/snack_bar.dart';

class AadharVerificationDialog extends StatefulWidget {
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const AadharVerificationDialog({
    super.key,
    this.onSuccess,
    this.onCancel,
  });

  static Future<bool?> show(
    BuildContext context, {
    VoidCallback? onSuccess,
    VoidCallback? onCancel,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AadharVerificationDialog(
        onSuccess: onSuccess,
        onCancel: onCancel,
      ),
    );
  }

  @override
  State<AadharVerificationDialog> createState() => _AadharVerificationDialogState();
}

class _AadharVerificationDialogState extends State<AadharVerificationDialog> {
  final AadharAuthService _aadharAuthService = AadharAuthService();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 1; // 1 = Enter Aadhaar, 2 = Verify OTP
  bool _isLoading = false;
  String _refId = '';
  String _maskedAadhaar = '';
  Timer? _resendTimer;
  int _resendCountdown = 0;

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendCountdown = 45;
    });
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  @override
  void dispose() {
    _aadharController.dispose();
    _otpController.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final aadharNum = _aadharController.text.trim();
    if (aadharNum.length != 12) {
      _showError('Aadhaar number must be 12 digits');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aadharAuthService.initiateAadharVerification(aadharNum);

      if (response['success'] == true) {
        final innerData = response['data'];
        
        // Handle service dynamically skipped
        if (innerData != null && innerData['skipped'] == true) {
          await UserHelper.setAadharVerified(true);
          _showSuccess('Aadhaar verification skipped (service inactive)');
          widget.onSuccess?.call();
          Navigator.of(context).pop(true);
          return;
        }

        // Get ref_id/reference_id
        String? refId;
        final level1 = response['data'];
        if (level1 is Map) {
          final level2 = level1['data'];
          if (level2 is Map) {
            final level3 = level2['data'];
            if (level3 is Map) {
              refId = (level3['reference_id'] ?? level3['ref_id'])?.toString();
            }
            refId ??= (level2['reference_id'] ?? level2['ref_id'] ?? level2['request_id'])?.toString();
          }
          refId ??= (level1['reference_id'] ?? level1['ref_id'] ?? level1['request_id'])?.toString();
        }
        refId ??= (response['reference_id'] ?? response['ref_id'] ?? response['request_id'])?.toString();
        if (refId != null) {
          setState(() {
            _refId = refId.toString();
            _maskedAadhaar = aadharNum;
            _currentStep = 2;
          });
          _showSuccess('OTP sent successfully to your Aadhaar linked mobile');
        } else {
          String? specificError;
          final l1 = response['data'];
          if (l1 is Map) {
            final l2 = l1['data'];
            if (l2 is Map) {
              final l3 = l2['data'];
              if (l3 is Map) {
                specificError = l3['message']?.toString();
              }
              specificError ??= l2['message']?.toString();
            }
            specificError ??= l1['message']?.toString();
          }
          specificError ??= response['message']?.toString();

          _showError(specificError ?? 'Failed to get verification reference ID. Please try again.');
        }
      } else {
        _showError(response['message'] ?? 'Failed to send Aadhaar OTP');
      }
    } catch (e) {
      _showError('Network/Server Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showError('OTP must be a 6-digit number');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _aadharAuthService.verifyAadharOtp(_refId, otp);

      if (response['success'] == true && response['data']?['verified'] == true) {
        await UserHelper.setAadharVerified(true);
        _showSuccess('Aadhaar verified successfully!');
        
        widget.onSuccess?.call();
        Navigator.of(context).pop(true);
      } else {
        _showError(response['message'] ?? 'Invalid OTP or verification failed');
      }
    } catch (e) {
      _showError('Network/Server Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showError(String message) {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Error',
      message: message,
      contentType: ContentType.failure,
    );
  }

  void _showSuccess(String message) {
    NesticoPeSnackBar.showAwesomeSnackbar(
      title: 'Success',
      message: message,
      contentType: ContentType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Bar
          Container(
            color: ColorRes.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Verify Your Aadhaar Number',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onCancel?.call();
                    Navigator.of(context).pop(false);
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Step Indicator
                  _buildStepper(),
                  const SizedBox(height: 24),

                  if (_currentStep == 1) ...[
                    // Step 1 Body
                    TextFormField(
                      controller: _aadharController,
                      keyboardType: TextInputType.number,
                      maxLength: 12,
                      decoration: InputDecoration(
                        hintText: 'Enter 12-digit Aadhaar number',
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: ColorRes.primary),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Aadhaar Number';
                        }
                        if (value.length != 12) {
                          return 'Aadhaar Number must be 12 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: (_isLoading || _resendCountdown > 0)
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _sendOtp();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _resendCountdown > 0
                                    ? 'Resend OTP in ${_resendCountdown}s'
                                    : 'Send OTP',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                  ] else ...[
                    // Step 2 Body
                    RichText(
                      text: TextSpan(
                        text: 'Aadhaar Number: ',
                        style: const TextStyle(
                          color: ColorRes.textColor,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: _maskedAadhaar,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorRes.textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: 'Enter 6-digit OTP',
                        counterText: '',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: ColorRes.primary),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter verification OTP';
                        }
                        if (value.length != 6) {
                          return 'OTP must be 6 digits';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _verifyOtp();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorRes.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Verify Aadhaar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                setState(() {
                                  _currentStep = 1;
                                  _otpController.clear();
                                });
                                _startResendTimer();
                              },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    final step1Active = _currentStep == 1;
    final step2Active = _currentStep == 2;

    return Row(
      children: [
        // Step 1 Circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: step2Active ? ColorRes.primary.withOpacity(0.2) : ColorRes.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: step2Active
              ? const Icon(
                  Icons.check,
                  color: ColorRes.primary,
                  size: 14,
                )
              : const Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(width: 8),
        Text(
          'Enter Aadhaar',
          style: TextStyle(
            color: step1Active ? Colors.black : Colors.grey,
            fontSize: 13,
            fontWeight: step1Active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(width: 8),

        // Connect Line
        Expanded(
          child: Container(
            height: 1,
            color: step2Active ? ColorRes.primary : Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 8),

        // Step 2 Circle
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: step2Active ? ColorRes.primary : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '2',
            style: TextStyle(
              color: step2Active ? Colors.white : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Verify OTP',
          style: TextStyle(
            color: step2Active ? Colors.black : Colors.grey,
            fontSize: 13,
            fontWeight: step2Active ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
