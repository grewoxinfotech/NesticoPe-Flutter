// import 'package:flutter/material.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
//
// void showContentDialog({
//   required BuildContext context,
//   required String content,
// }) {
//   showDialog(
//     context: context,
//     builder:
//         (_) => Dialog(
//           backgroundColor: ColorRes.white,
//           insetPadding: const EdgeInsets.symmetric(
//             horizontal: 24,
//             vertical: 24,
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: ConstrainedBox(
//               // Max height ensures scroll if text is too long
//               constraints: const BoxConstraints(maxHeight: 450),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // CONTENT (auto expands but scrolls when needed)
//                   Flexible(
//                     child: SingleChildScrollView(
//                       child: Text(
//                         content,
//                         style: const TextStyle(fontSize: 15, height: 1.4),
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   // CLOSE BUTTON
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () => Navigator.of(context).pop(),
//                       child: const Text(
//                         "Close",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

void showContentDialog({
  required BuildContext context,
  required String content,
  String? title,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 500),
        decoration: BoxDecoration(
          color: ColorRes.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER with optional title
            if (title != null) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 16, 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                    ),
                    // Close icon button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.grey.shade200),
            ],

            // SCROLLABLE CONTENT
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  24,
                  title != null ? 20 : 24,
                  24,
                  16,
                ),
                child: SelectableText(
                  content,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: Colors.grey.shade800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),

            // FOOTER with action button
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Primary action button
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
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
  );
}
