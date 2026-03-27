import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/enum.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/modules/auth/controllers/auth_controller.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
// import 'package:nesticope_app/modules/auth/views/seller_registration_screen.dart';
import 'package:nesticope_app/modules/subscription/views/suscription_plan_screen.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/intro_common.dart';

class OwnerPlansIntroScreen extends StatelessWidget {
  const OwnerPlansIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorRes.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Seller Plans',
          style: TextStyle(
            fontWeight: AppFontWeights.semiBold,
            color: ColorRes.white,
          ),
        ),
        backgroundColor: ColorRes.primary,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _HeroSection(
                onViewPlans: () async {
                  try {
                    var userType = UserHelper.userType;

                    if (userType == null) {
                      final user = await SecureStorage.getUserData();
                      final role = user?.user?.userType?.toLowerCase() ?? '';
                      UserHelper.setUserType(role);
                    }

                    /// Guest → Register
                    if (UserHelper.isGuest) {
                      if (!Get.isRegistered<AuthController>()) {
                        Get.put(AuthController());
                      }

                  
                      return;
                    }
                  } catch (e, stackTrace) {
                    /// Print error in debug
                    debugPrint("Error in onViewPlans: $e");
                    debugPrint("StackTrace: $stackTrace");

                    /// Show user message
                    Get.snackbar(
                      "Error",
                      "Something went wrong. Please try again.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'Sell With NesticoPe',
                subtitle:
                    'We provide the tools and reach you need to sell your property at the best price',
              ),
              const SizedBox(height: 16),
              _FeaturesGrid(
                children: const [
                  _FeatureCard(
                    icon: Icons.local_offer_outlined,
                    title: 'Free Listing',
                    subtitle:
                        'List your property for free and reach thousands of buyers without any cost.',
                  ),
                  _FeatureCard(
                    icon: Icons.visibility_outlined,
                    title: 'More Visibility',
                    subtitle:
                        'Get your property in front of thousands of active buyers every day.',
                  ),
                  _FeatureCard(
                    icon: Icons.campaign_outlined,
                    title: 'NesticoPe Support',
                    subtitle:
                        'Dedicated relationship managers to help you list and sell.',
                  ),
                  _FeatureCard(
                    icon: Icons.group_outlined,
                    title: 'Serious Enquiries',
                    subtitle:
                        'Build trust and receive enquiries from verified buyers.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'Premium Owner Listings',
                subtitle:
                    'See how your property will look to thousands of verified buyers',
              ),
              const SizedBox(height: 12),
              const _PropertyList(),
              const SizedBox(height: 24),
              _SectionTitle(
                title: 'How It Works?',
                subtitle:
                    'Selling your property is now as easy as ordering food online',
              ),
              const SizedBox(height: 16),
              _StepsGrid(
                children: [
                  _StepCard(
                    step: '1',
                    icon: Icons.phone_iphone,
                    title: 'Post Property',
                    subtitle: 'Enter details and upload photos in 2 minutes.',
                  ),
                  _StepCard(
                    step: '2',
                    icon: Icons.verified_outlined,
                    title: 'Get Verified',
                    subtitle: 'We verify your listing to build trust.',
                  ),
                  _StepCard(
                    step: '3',
                    icon: Icons.link_outlined,
                    title: 'Receive Inquiries',
                    subtitle:
                        'Buyers contact you directly via call or message.',
                  ),
                  _StepCard(
                    step: '4',
                    icon: Icons.handshake_outlined,
                    title: 'Close the Deal',
                    subtitle:
                        'Negotiate directly and sell with zero brokerage.',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _CtaSection(onViewPlans: _openPlans),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPlans() async {
    
    Get.to(
      () => SubscriptionPlansScreen(
        role: Roles.sellerOwner.name,
     
        origin: 'buyer',
        isNotFromBuyerSide: false,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionTitle({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor[600],
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final VoidCallback onViewPlans;
  const _HeroSection({required this.onViewPlans});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(color: ColorRes.primary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sell Your Property Faster',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Post your property for FREE and reach verified buyers directly.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.bodyMedium,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          _PrimaryButton(
            text: 'Post Property Free',
            onTap: onViewPlans,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _StatItem(value: '10k+', label: 'Active Buyers'),
              _StatItem(value: '5k+', label: 'Properties Sold'),
              _StatItem(value: '0%', label: 'Commission Fee'),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const _PrimaryButton({
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: backgroundColor ?? ColorRes.primary,

          boxShadow: [
            BoxShadow(
              color:
                  backgroundColor?.withOpacity(0.4) ??
                  Colors.black.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 6,
              offset: const Offset(0, 4), // shadow position
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor ?? ColorRes.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _FeaturesGrid extends StatelessWidget {
  final List<Widget> children;
  const _FeaturesGrid({required this.children});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(width: 210, child: children[index]);
        },
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ColorRes.primary),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.leadGreyColor[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _PropertyList extends StatelessWidget {
  const _PropertyList();
  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'image': IMGRes.home2,
        'title': 'Modern 3BHK Apartment',
        'subtitle': 'Adajan, Surat',
        'price': '₹85 Lakh',
        'engagement': '1.2k views',
        'tag': 'Verified Owner',
        'tagColor': const Color(0xFF2563EB),
      },
      {
        'image': IMGRes.project_2,
        'title': 'Luxury Row House',
        'subtitle': 'Vesu, Surat',
        'price': '₹2.1 Cr',
        'engagement': '2.5k views',
        'tag': 'Premium Listing',
        'tagColor': const Color(0xFFF59E0B),
      },
      {
        'image': IMGRes.home3,
        'title': 'Spacious Penthouse',
        'subtitle': 'Piplod, Surat',
        'price': '₹3.5 Cr',
        'engagement': '3.1k views',
        'tag': 'Premium Listing',
        'tagColor': const Color(0xFF7C3AED),
      },
      {
        'image': IMGRes.home4,
        'title': 'Comfortable 2BHK',
        'subtitle': 'Pal, Surat',
        'price': '₹45 Lakh',
        'engagement': '800 views',
        'tag': 'Quick Sell',
        'tagColor': const Color(0xFF2563EB),
      },
    ];
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _PropertyCard(
            image: item['image'] as String,
            title: item['title'] as String,
            subtitle: item['subtitle'] as String,
            price: item['price'] as String,
            engagement: item['engagement'] as String,
            tag: item['tag'] as String,
            tagColor: item['tagColor'] as Color,
          );
        },
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final String engagement;
  final String? tag;
  final Color? tagColor;
  const _PropertyCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.engagement,
    this.tag,
    this.tagColor,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ColorRes.leadGreyColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.asset(image, height: 140, width: 280, fit: BoxFit.cover),
                if (tag != null && tag!.isNotEmpty)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: TagChip(
                      text: tag!,
                      color: tagColor ?? ColorRes.primary,
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.leadGreyColor[900],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          color: ColorRes.leadGreyColor[600],
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Divider(
                  height: 16,
                  thickness: 1,
                  color: ColorRes.leadGreyColor.shade200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Expected Price',
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.leadGreyColor[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Engagement',
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            color: ColorRes.leadGreyColor[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          engagement,
                          style: TextStyle(
                            fontSize: AppFontSizes.body,
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepsGrid extends StatelessWidget {
  final List<Widget> children;
  const _StepsGrid({required this.children});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: children.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(width: 200, child: children[index]);
        },
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;
  final String subtitle;
  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: ColorRes.primary.withOpacity(0.12),
                child: Text(
                  step,
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Icon(icon, color: ColorRes.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.leadGreyColor[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _CtaSection extends StatelessWidget {
  final VoidCallback onViewPlans;
  const _CtaSection({required this.onViewPlans});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 22,
            backgroundColor: ColorRes.leadGreyColor.withOpacity(0.12),
            child: Icon(Icons.bolt, color: ColorRes.homeAmber),
          ),
          const SizedBox(height: 12),
          Text(
            "Still Waiting? Your Buyer Isn't!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Every day, buyers look for properties exactly like yours.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor[600],
            ),
          ),
          const SizedBox(height: 16),
          const _MetricsRow(),
          const SizedBox(height: 16),
          _PrimaryButton(
            text: 'View Plans',
            onTap: onViewPlans,
            textColor: Colors.white,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _MetricItem(value: '2 Min', label: 'FAST POSTING'),
        _MetricDivider(),
        _MetricItem(value: '0%', label: 'BROKERAGE'),
        _MetricDivider(),
        _MetricItem(value: 'Unlimited', label: 'VISIBILITY'),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String label;
  const _MetricItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.leadGreyColor[900],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 1,
      color: ColorRes.leadGreyColor.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String text;
  final Color color;
  const _TagChip({required this.text, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: AppFontSizes.caption,
          fontWeight: AppFontWeights.semiBold,
        ),
      ),
    );
  }
}
