import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/helper_function/user_helper/user_helper.dart';

import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../reseller/view/profile/reseller_profile.dart';

class DashboardHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? image;

  // final IconData icon;

  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.image,
    // required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 📄 Text section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.large,
                    fontWeight: AppFontWeights.bold,
                    color: ColorRes.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: ColorRes.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),

          if (UserHelper.isReseller) ...[
            const SizedBox(width: 12),

            // 🖼️ Image section
            GestureDetector(
              onTap: () {
                Get.to(() => ResellerProfileScreen());
              },
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: ColorRes.white.withOpacity(0.2),
                  image: DecorationImage(
                    image: AssetImage('assets/images/reseller_dashboard.png'),
                    // 👈 replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
