import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/font_res.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';

class PaymentStatusScreen extends StatelessWidget {
  final bool isSuccess;
  final String? message;
  final String? orderId;
  final String? paymentId;

  const PaymentStatusScreen({
    super.key,
    required this.isSuccess,
    this.message,
    this.orderId,
    this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color:
                        isSuccess
                            ? ColorRes.primary.withOpacity(0.1)
                            : ColorRes.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.check_circle : Icons.error,
                    size: 80,
                    color: isSuccess ? ColorRes.primary : ColorRes.error,
                  ),
                ),

                const SizedBox(height: 32),

                // Title
                Text(
                  isSuccess ? 'Payment Successful!' : 'Payment Failed',
                  style: TextStyle(
                    fontSize: AppFontSizes.heading,
                    fontWeight: AppFontWeights.bold,
                    color: ColorRes.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // Message
                if (message != null)
                  Text(
                    message!,
                    style: TextStyle(
                      fontSize: AppFontSizes.body,
                      color: ColorRes.leadGreyColor[600],
                    ),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 32),

                // Payment Details
                if (isSuccess && (orderId != null || paymentId != null))
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColorRes.leadGreyColor.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        if (orderId != null)
                          _buildDetailRow('Order ID', orderId!),
                        if (orderId != null && paymentId != null)
                          const SizedBox(height: 8),
                        if (paymentId != null)
                          _buildDetailRow('Payment ID', paymentId!),
                      ],
                    ),
                  ),

                const SizedBox(height: 32),

                // Action Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate back to home or subscription screen
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.primary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isSuccess ? 'Go to Dashboard' : 'Try Again',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.white,
                      ),
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

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.bodySmall,
            color: ColorRes.leadGreyColor[600],
            fontWeight: AppFontWeights.medium,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppFontSizes.bodySmall,
              color: ColorRes.textPrimary,
              fontWeight: AppFontWeights.semiBold,
            ),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
