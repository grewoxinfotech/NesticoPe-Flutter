import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/widgets/image/custom_image.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';

class CancelSubscriptionDialog extends StatefulWidget {
  final Function(String reason) onSubmit;

  const CancelSubscriptionDialog({Key? key, required this.onSubmit})
    : super(key: key);

  @override
  State<CancelSubscriptionDialog> createState() =>
      _CancelSubscriptionDialogState();
}

class _CancelSubscriptionDialogState extends State<CancelSubscriptionDialog> {
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 500,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE53935),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Request to Cancel Subscription',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Confirmation text
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: 'Are you sure you want to cancel your ',
                          ),
                          TextSpan(
                            text: 'Premium Plan',
                            style: TextStyle(
                              color: Color(0xFFE53935),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(text: ' subscription?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Note
                    const Text(
                      'Note: This will create a support ticket. Our team will process your request and get back to you.',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                    const SizedBox(height: 20),

                    // Reason label
                    RichText(
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                        children: [
                          TextSpan(
                            text: '* ',
                            style: TextStyle(color: Color(0xFFE53935)),
                          ),
                          TextSpan(text: 'Reason for Cancellation'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Text field
                    NesticoPeTextField(
                      controller: _reasonController,
                      maxLines: 5,
                      hintText: 'Enter reason for cancellation',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Reason is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Close button
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            side: const BorderSide(color: Colors.black26),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Submit button
                        ElevatedButton(
                          onPressed: () {
                            // Handle submission

                            final reason = _reasonController.text;
                            if (reason.isNotEmpty) {
                              widget.onSubmit(reason);
                              // Show confirmation or process the request
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE53935),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Submit Request',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // Example usage:
// void showCancelSubscriptionDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return const CancelSubscriptionDialog();
//     },
//   ).then((reason) {
//     if (reason != null) {
//       // Handle the cancellation reason
//       print('Cancellation reason: $reason');
//     }
//   });
// }
