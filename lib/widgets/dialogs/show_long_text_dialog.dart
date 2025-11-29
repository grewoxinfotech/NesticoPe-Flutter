import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

void showContentDialog({
  required BuildContext context,
  required String content,
}) {
  showDialog(
    context: context,
    builder:
        (_) => Dialog(
          backgroundColor: ColorRes.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              // Max height ensures scroll if text is too long
              constraints: const BoxConstraints(maxHeight: 450),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CONTENT (auto expands but scrolls when needed)
                  Flexible(
                    child: SingleChildScrollView(
                      child: Text(
                        content,
                        style: const TextStyle(fontSize: 15, height: 1.4),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // CLOSE BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        "Close",
                        style: TextStyle(fontWeight: FontWeight.bold),
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
