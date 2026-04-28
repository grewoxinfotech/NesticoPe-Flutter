import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/enum.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/modules/auth/views/listing_intro_screen.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import 'package:nesticope_app/modules/auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import 'package:nesticope_app/modules/builder/view/builder_main_screen.dart';
import 'package:nesticope_app/modules/contractor/view/contractor_main.dart';
import 'package:nesticope_app/modules/contractor/view/widget/convert_to_contractor.dart';
import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
import 'package:nesticope_app/modules/subscription/views/suscription_plan_screen.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class LoginAsPartnerOptionsFromSplashScreen extends StatefulWidget {
  const LoginAsPartnerOptionsFromSplashScreen({super.key});

  @override
  State<LoginAsPartnerOptionsFromSplashScreen> createState() =>
      _LoginAsPartnerOptionsFromSplashScreenState();
}

class _LoginAsPartnerOptionsFromSplashScreenState
    extends State<LoginAsPartnerOptionsFromSplashScreen> {
  @override
  Widget build(BuildContext context) {
    final items = [
      _ConversionItem(
        title: 'Register as Partner',
        subtitle: 'Earn commissions promoting properties',
        icon: Icons.handshake_outlined,
        color: const Color(0xFF4A6CF7),
        onTap: () async {
        
          Get.to(() => RegisterScreen(role: UserRole.reseller));
        },
      ),
      _ConversionItem(
        title: 'Register as Builder',
        subtitle: 'Promote projects and acquire buyers',
        icon: Icons.apartment_outlined,
        color: const Color(0xFFEA7A3B),
        onTap: () async {
          await SecureStorage.setAppLaunched();
          Get.to(() => RegisterScreen(role: UserRole.seller));
        },
      ),
      _ConversionItem(
        title: 'Register as Seller',
        subtitle: 'Start listing and selling properties',
        icon: Icons.storefront_outlined,
        color: const Color(0xFF6A5AE0),
        onTap: () async {
          await SecureStorage.setAppLaunched();
          Get.to(() => RegisterScreen(role: UserRole.seller));
        },
      ),
      _ConversionItem(
        title: 'Register as Contractor',
        subtitle: 'Offer renovation and construction services',
        icon: Icons.engineering_outlined,
        color: const Color(0xFF00A28A),
        onTap: () async {
          await SecureStorage.setAppLaunched();
          Get.to(() => RegisterScreen(role: UserRole.contractor));
        },
      ),
    ];

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        title: const Text(
          'Partner with Us',
          style: TextStyle(fontWeight: AppFontWeights.semiBold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FF), Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: ColorRes.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.verified_user,
                        color: ColorRes.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Choose the role you want to convert into. You can unlock tailored dashboards and benefits for each role.',
                        style: TextStyle(
                          fontSize: AppFontSizes.small,
                          fontWeight: AppFontWeights.medium,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _ConversionCard(item: item);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConversionItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _ConversionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

class _ConversionCard extends StatelessWidget {
  final _ConversionItem item;

  const _ConversionCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            // border: Border.all(color: ColorRes.leadGreyColor.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 36,
                width: 36,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.icon, color: item.color),
              ),
              const SizedBox(height: 10),
              Text(
                item.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: AppFontWeights.bold,
                  fontSize: AppFontSizes.body,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                item.subtitle,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: AppFontWeights.medium,
                  fontSize: AppFontSizes.small,
                  color: ColorRes.textSecondary,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: item.onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Proceed',
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
