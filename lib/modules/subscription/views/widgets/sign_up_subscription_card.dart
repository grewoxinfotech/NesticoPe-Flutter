// import 'package:flutter/material.dart';
//
// class SignUpSubscriptionScreen extends StatelessWidget {
//   final String title;
//   final VoidCallback onTap;
//   const SignUpSubscriptionScreen({
//     super.key,
//     required this.title,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(onPressed: onTap, child: Text('${title}'));
//   }
// }

import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

class SignUpSubscriptionScreen extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const SignUpSubscriptionScreen({
    super.key,
    required this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.storefront, color: ColorRes.primary, size: 24),
          ),

          const SizedBox(width: 12),

          // Title + Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: ColorRes.primary,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Start listing properties and earn more visibility',
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),

          // CTA Button
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              elevation: 0,
            ),
            child: Row(
              children: const [
                Text('Get Started', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
