import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';

class BuilderProfile extends StatelessWidget {
  const BuilderProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         padding: const EdgeInsets.fromLTRB(16, 60, 16, 30),
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.7)],
      //             begin: Alignment.topLeft,
      //             end: Alignment.bottomRight,
      //           ),
      //         ),
      //         child: Column(
      //           children: [
      //             CircleAvatar(
      //               radius: 50,
      //               backgroundColor: Colors.white,
      //               child: Icon(Icons.person_rounded, size: 60, color: ColorRes.primary),
      //             ),
      //             const SizedBox(height: 16),
      //             const Text('Builder Company Ltd.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      //             const SizedBox(height: 4),
      //             Text('builder@company.com', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9))),
      //             const SizedBox(height: 20),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               children: [
      //                 _buildStatItem('24', 'Properties'),
      //                 Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
      //                 _buildStatItem('156', 'Leads'),
      //                 Container(width: 1, height: 40, color: Colors.white.withOpacity(0.3)),
      //                 _buildStatItem('18', 'Sold'),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(16),
      //         child: Column(
      //           children: [
      //             _buildMenuItem(Icons.business_rounded, 'Company Info', () {}),
      //             _buildMenuItem(Icons.settings_rounded, 'Settings', () {}),
      //             _buildMenuItem(Icons.notifications_rounded, 'Notifications', () {}),
      //             _buildMenuItem(Icons.help_rounded, 'Help & Support', () {}),
      //             _buildMenuItem(Icons.privacy_tip_rounded, 'Privacy Policy', () {}),
      //             _buildMenuItem(Icons.info_rounded, 'About', () {}),
      //             const SizedBox(height: 8),
      //             _buildMenuItem(Icons.logout_rounded, 'Logout', () {}, isDestructive: true),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.9))),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDestructive ? Colors.red.withOpacity(0.1) : ColorRes.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 22, color: isDestructive ? Colors.red : ColorRes.primary),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(title, style: TextStyle(fontSize: AppFontSizes.bodySmall, fontWeight: FontWeight.w600, color: isDestructive ? Colors.red : ColorRes.textPrimary)),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
