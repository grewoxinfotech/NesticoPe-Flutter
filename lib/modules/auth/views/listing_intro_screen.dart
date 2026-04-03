import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/app/constants/enum.dart';
import 'package:nesticope_app/app/utils/formater/formater.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/app/widgets/texts/headline_text.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/data/network/history/model/success_story_model.dart';
import 'package:nesticope_app/modules/home/views/home_screen/home_screen.dart';

import 'package:nesticope_app/modules/subscription/controller/subscription_controller.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/subscription_plan_widget.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/subscription_plan_widget_for_buyer_side.dart';
import 'package:nesticope_app/widgets/New%20folder/inputs/text_field.dart';
import 'package:nesticope_app/widgets/button/button.dart';
import 'package:nesticope_app/modules/hire_contractor/controller/hire_contractor_controller.dart';
import 'package:nesticope_app/data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import 'package:nesticope_app/modules/hire_contractor/view/widget/category_service_explorer.dart';
import 'package:nesticope_app/modules/property/controllers/property_controller.dart';
import 'package:nesticope_app/modules/property/views/widgets/property_card.dart';
import 'package:nesticope_app/modules/builder/controller/builder_form_controller.dart';
import 'package:nesticope_app/modules/builder/view/builder_property_listing.dart';
import 'package:nesticope_app/modules/builder/view/project_detail/project_detail.dart';
import 'package:nesticope_app/modules/home/widgets/partner_success_stories_detail_screen.dart';
import 'package:nesticope_app/modules/history/controller/search_history_controller.dart';
import 'package:intl/intl.dart';
import 'package:nesticope_app/modules/home/controllers/home_controller/platform_review-controller.dart';
import 'package:nesticope_app/data/network/platform_review/model/platform_review_model.dart';

class ListingIntroConfig {
  final String logoAsset;
  final String appBarBrand;
  final String badgeText;
  final String headline;
  final String highlightWord;
  final String subHeadline;
  final String primaryCta;
  final String sellWithTitle;
  final String sellWithSubtitle;
  final String manageTitle;
  final String manageSubtitle;
  final String manageButtonText;
  final String premiumTitle;
  final String premiumActionText;
  final String stepsTitle;
  final String viewPlansTitle;
  final String viewPlansSubtitle;
  final String viewPlansButtonText;
  final List<StatItemData> stats;
  final List<FeatureItemData> features;

  final List<PremiumListingItem> premiumListings;
  final List<HowStep> steps;
  final PlansFormConfig plansForm;
  final FinalCalloutConfig finalCallout;

  // Contractor Specific
  final String? contractorStrategyTitle;
  final String? contractorStrategySubtitle;
  final List<FeatureItemData>? contractorStrategySteps;
  final String? contractorBenefitsTitle;
  final String? contractorBenefitsSubtitle;
  final List<FeatureItemData>? contractorBenefits;

  const ListingIntroConfig({
    required this.logoAsset,
    required this.appBarBrand,
    required this.badgeText,
    required this.headline,
    required this.highlightWord,
    required this.subHeadline,
    required this.primaryCta,
    required this.sellWithTitle,
    required this.sellWithSubtitle,
    required this.manageTitle,

    required this.manageSubtitle,
    required this.manageButtonText,
    required this.premiumTitle,
    required this.premiumActionText,
    required this.stepsTitle,
    required this.viewPlansTitle,
    required this.viewPlansSubtitle,
    required this.viewPlansButtonText,
    required this.stats,
    required this.features,
    required this.premiumListings,
    required this.steps,
    required this.plansForm,
    required this.finalCallout,
    this.contractorStrategyTitle,
    this.contractorStrategySubtitle,
    this.contractorStrategySteps,
    this.contractorBenefitsTitle,
    this.contractorBenefitsSubtitle,
    this.contractorBenefits,
  });
}

class StatItemData {
  final String value;
  final String label;
  const StatItemData(this.value, this.label);
}

class FeatureItemData {
  final IconData icon;
  final String title;
  final String subtitle;
  const FeatureItemData(this.icon, this.title, this.subtitle);
}

class PremiumListingItem {
  final String imageAsset;
  final String title;
  final String subtitle;
  final String priceText;
  const PremiumListingItem({
    required this.imageAsset,
    required this.title,
    required this.subtitle,
    required this.priceText,
  });
}

class HowStep {
  final String title;
  final String subtitle;
  const HowStep(this.title, this.subtitle);
}

class PlansFormConfig {
  final String pillText;
  final String title;
  final String subtitle;
  final String buttonText;
  const PlansFormConfig({
    required this.pillText,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

class FinalCalloutConfig {
  final String headline;
  final List<String> points;
  final String cta;
  const FinalCalloutConfig({
    required this.headline,
    required this.points,
    required this.cta,
  });
}

class ListingIntroScreen extends StatelessWidget {
  final ListingIntroConfig config;
  final bool isBulletPoint;
  final String planTitle;
  final String? role;
  final VoidCallback? onPrimaryCta;
  final VoidCallback? onManageListings;
  final VoidCallback? onUnlockPlans;
  final VoidCallback? onFinalCta;
  final bool showPropertySection;
  const ListingIntroScreen({
    super.key,
    required this.config,
    this.role,
    this.onPrimaryCta,
    this.onManageListings,
    required this.planTitle,
    this.onUnlockPlans,
    this.isBulletPoint = false,
    this.showPropertySection = true,
    this.onFinalCta,
  });

  @override
  Widget build(BuildContext context) {
    final controller =
        (Get.isRegistered<SubscriptionPlanController>())
            ? Get.find<SubscriptionPlanController>()
            : Get.put(SubscriptionPlanController(userRole: role ?? ''));
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ColorRes.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                (config.appBarBrand.isNotEmpty ? config.appBarBrand[0] : 'N')
                    .toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: AppFontWeights.bold,
                  fontSize: AppFontSizes.large,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              config.appBarBrand,
              style: const TextStyle(
                color: ColorRes.primary,
                fontWeight: AppFontWeights.bold,
                fontSize: AppFontSizes.title,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _HeroHeader(
                badgeText: config.badgeText,
                headline: config.headline,
                highlight: config.highlightWord,
                subHead: config.subHeadline,
                cta: config.primaryCta,
                onTap: onPrimaryCta,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _StatsCarousel(stats: config.stats),
              ),
              const SizedBox(height: 10),
              if (role == Roles.reseller.name) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _MultipleWaysToEarn(),
                ),
              ],
              if (role == Roles.contractor.name) ...[
                if (config.contractorStrategyTitle != null &&
                    config.contractorStrategySteps != null) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _ContractorStrategy(
                      title: config.contractorStrategyTitle!,
                      subtitle: config.contractorStrategySubtitle ?? '',
                      steps: config.contractorStrategySteps!,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                if (config.contractorBenefitsTitle != null &&
                    config.contractorBenefits != null) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _ContractorBenefitsGrid(
                      title: config.contractorBenefitsTitle!,
                      subtitle: config.contractorBenefitsSubtitle ?? '',
                      benefits: config.contractorBenefits!,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeader(
                        title: 'Top Construction Projects',
                        subtitle: 'Start earning commission from day one',
                      ),
                      const SizedBox(height: 10),
                      _ContractorServicesCarousel(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),

                child: _SellWith(
                  title: config.sellWithTitle,
                  subtitle: config.sellWithSubtitle,
                  features: config.features,
                  onManage: onManageListings,
                ),
              ),
              const SizedBox(height: 10),
              if (role == Roles.reseller.name) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ResellerAchievementsSection(),
                ),
                const SizedBox(height: 20),
              ],
              if (role == Roles.reseller.name) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PartnerProgramSection(
                    heading: 'What is NesticoPe Partner Program?',
                    description:
                        "NesticoPe is India's most advanced property ecosystem, designed to create a bridge between verified property inventory and potential buyers. Our Partner Program empowers real estate professionals, consultants, and individuals to build their own property business with zero investment and maximum support.",
                    leftPoints: const [
                      _Point(
                        icon: Icons.verified_user,
                        title: 'Assigned Property Access',
                        subtitle:
                            'Access only those properties that are assigned to you by our system or admin, giving you a focused and high-trust inventory to work with.',
                      ),
                      _Point(
                        icon: Icons.share_outlined,
                        title: 'Simplified Sharing & Lead Gen',
                        subtitle:
                            'Share assigned property links with your network. When a potential buyer clicks and inquires, a lead is automatically generated in your name.',
                      ),
                      _Point(
                        icon: Icons.handshake_outlined,
                        title: 'Direct Commission on Closures',
                        subtitle:
                            'Once your generated lead is confirmed and closed by the superadmin, you earn your guaranteed commission directly in your wallet.',
                      ),
                    ],
                    rightTitle: 'Why Join Us?',
                    rightSubtitle:
                        "Become part of India's fastest-growing property network. We don't just provide listings; we provide a complete business ecosystem that handles the entire buyer journey.",
                    rightBullets: const [
                      'Direct High-Percentage Commissions',
                      'Verified & Exclusive Property Inventory',
                      'Advanced Partner Sales Dashboard',
                      'Marketing & Branding Training Support',
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              if (role == Roles.contractor.name) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _PartnerProgramSection(
                    heading: 'What is NesticoPe Contractor Program?',
                    description:
                        "NesticoPe is India's most comprehensive property ecosystem designed to empower construction professionals. We provide contractors with a high-trust platform to showcase their expertise and connect with buyers who are looking for end-to-end property solutions.",
                    leftPoints: const [
                      _Point(
                        icon: Icons.business_outlined,
                        title: 'Complete Property Solutions',
                        subtitle:
                            'We offer buyers everything they need—from property searching and legal vetting to construction, interior design, and beyond.',
                      ),
                      _Point(
                        icon: Icons.construction_outlined,
                        title: 'Empowering Contractors',
                        subtitle:
                            'We provide you with digital tools, a verified professional profile, and a steady flow of high-quality leads to scale your business.',
                      ),
                      _Point(
                        icon: Icons.groups_outlined,
                        title: 'Opportunity for Everyone',
                        subtitle:
                            'Our platform is built for everyone in the ecosystem. Whether you are a specialized contractor or a large firm, there is an opportunity to grow with us.',
                      ),
                    ],
                    rightTitle: 'Why Join Us?',
                    rightSubtitle:
                        'Be part of an ecosystem that handles the entire buyer journey. When buyers find their dream property on NesticoPe, they trust our verified partners for their construction and legal needs.',
                    rightBullets: const [
                      'Verified Business Authority',
                      'Direct Buyer Connections',
                      'Premium Project Dashboard',
                      'Marketing & Branding Support',
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],

              if (showPropertySection) ...[
                if (role == Roles.sellerBuilder.name) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _PremiumProjectCarousel(),
                  ),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _PremiumPropertyCarousel(),
                  ),
                ],
                const SizedBox(height: 16),
              ],

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // if (UserHelper.isGuest) ...[
                    _ViewPlansCallout(
                      title: config.viewPlansTitle,
                      subtitle: config.viewPlansSubtitle,
                      buttonText: config.viewPlansButtonText,
                      onTap: onUnlockPlans,
                    ),

                    // ] else ...[
                    //   Text(
                    //     planTitle,
                    //     style: TextStyle(
                    //       fontSize: AppFontSizes.body,
                    //       fontWeight: AppFontWeights.semiBold,
                    //       color: ColorRes.textPrimary,
                    //     ),
                    //   ),
                    //   const SizedBox(height: 10),
                    //   SubscriptionPlansCarousel(controller: controller),
                    //   const SizedBox(height: 16),
                    // ],
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (config.steps.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: _HowItWorks(
                    steps: config.steps,
                    title: config.stepsTitle,
                    isBulletPoint: isBulletPoint,
                  ),
                ),
              if (config.steps.isNotEmpty) const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: _FinalCallout(
                  cfg: config.finalCallout,
                  onTap: onFinalCta ?? () {},
                ),
              ),
              const SizedBox(height: 10),
              if (role == Roles.sellerOwner.name ||
                  role == Roles.sellerBuilder.name ||
                  role == Roles.contractor.name ||
                  role == Roles.reseller.name) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ReviewsSection(
                    entityType:
                        role == Roles.sellerOwner.name
                            ? 'seller'
                            : role == Roles.sellerBuilder.name
                            ? 'seller'
                            : role == Roles.contractor.name
                            ? 'contractor'
                            : 'reseller',
                    newEntityType:
                        role == Roles.sellerOwner.name
                            ? 'seller'
                            : role == Roles.sellerBuilder.name
                            ? 'builder'
                            : role == Roles.contractor.name
                            ? 'contractor'
                            : 'reseller',
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ContractorServicesCarousel extends StatelessWidget {
  _ContractorServicesCarousel({super.key});
  final HireContractorController controller =
      Get.isRegistered<HireContractorController>()
          ? Get.find<HireContractorController>()
          : Get.put(HireContractorController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.items.isEmpty) {
        return SizedBox(height: 190);
      }
      if (controller.items.isEmpty) {
        return const SizedBox.shrink();
      }
      String norm(String s) => s
          .trim()
          .toLowerCase()
          .replaceAll('&', 'and')
          .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
      final order = <String, int>{
        'home_construction': 1,
        'building_material_supply': 2,
        'material_supply': 2,
        'home_services': 3,
        'interior_design': 4,
        'packers_and_movers': 5,
        'packers_movers': 5,
        'legal_services': 6,
      };
      final sorted = [...controller.items]..sort((a, b) {
        final ai = order[norm(a.name)] ?? 999;
        final bi = order[norm(b.name)] ?? 999;
        return ai.compareTo(bi);
      });
      return SizedBox(
        height: 210,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: sorted.length,
          clipBehavior: Clip.none, // ✅
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            final category = sorted[index];
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => CategoryServiceExplorer(
                    categoryId: category.id,
                    categoryName: category.name,
                  ),
                );
              },
              child: _ContractorServiceCard(category: category),
            );
          },
        ),
      );
    });
  }
}

class _ContractorServiceCard extends StatelessWidget {
  final ContractorServiceCategory category;
  const _ContractorServiceCard({required this.category});
  @override
  Widget build(BuildContext context) {
    String norm(String s) => s
        .trim()
        .toLowerCase()
        .replaceAll('&', 'and')
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_');
    final key = norm(category.name);
    final isHomeConstruction = key == 'home_construction';
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.surface,
        borderRadius: BorderRadius.circular(12),
        border:
            isHomeConstruction
                ? Border.all(color: ColorRes.primary, width: 2.5)
                : null, // ✅ no border at all
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 2,

            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Visibility(
              visible: isHomeConstruction,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: Container(
                margin: const EdgeInsets.only(left: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ColorRes.primary.withOpacity(0.35)),
                ),
                child: const Text(
                  'MOST POPULAR',
                  style: TextStyle(
                    color: ColorRes.primary,
                    fontSize: 10,
                    fontWeight: AppFontWeights.semiBold,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              if ((category.icon ?? '').isNotEmpty)
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.network(
                    category.icon ?? '',
                    fit: BoxFit.contain,
                  ),
                )
              else
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: ColorRes.leadGreyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.category,
                    color: ColorRes.textSecondary,
                    size: 24,
                  ),
                ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...((category.description)
              .where((line) => line.trim().isNotEmpty)
              .take(3)
              .map((line) {
                final text =
                    line.trim().startsWith('•')
                        ? line.trim().substring(1).trim()
                        : line.trim();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.check_circle,
                          size: 14,
                          color: ColorRes.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 11,
                            color: ColorRes.leadGreyColor.shade700,
                            fontWeight: AppFontWeights.medium,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              })
              .toList()),
          const SizedBox(height: 10),
          Text(
            'Created on ${_formatDate(category.createdAt)}',
            style: const TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
              color: ColorRes.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }
}

class _HeroHeader extends StatelessWidget {
  final String badgeText;
  final String headline;
  final String highlight;
  final String subHead;
  final String cta;
  final VoidCallback? onTap;
  const _HeroHeader({
    required this.badgeText,
    required this.headline,
    required this.highlight,
    required this.subHead,
    required this.cta,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            headline,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorRes.textPrimary,
              fontSize: AppFontSizes.displayMedium,
              fontWeight: AppFontWeights.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            highlight,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontSize: AppFontSizes.displayMedium,
              fontWeight: AppFontWeights.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subHead,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorRes.leadGreyColor.shade700,
              fontSize: AppFontSizes.bodySmall,
              fontWeight: AppFontWeights.medium,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: onTap ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorRes.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                cta,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCarousel extends StatefulWidget {
  final List<StatItemData> stats;
  const _StatsCarousel({required this.stats});
  @override
  State<_StatsCarousel> createState() => _StatsCarouselState();
}

class _StatsCarouselState extends State<_StatsCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    // Show two stat cards side-by-side
    _controller = PageController(viewportFraction: 0.5);

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted || widget.stats.isEmpty) return;
      _index = (_index + 1) % widget.stats.length;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.stats.isEmpty) return const SizedBox.shrink();
    return SizedBox(
      height: 100,

      child: PageView.builder(
        controller: _controller,
        itemCount: widget.stats.length,
        clipBehavior: Clip.none, // ✅
        padEnds: false,
        itemBuilder: (context, i) {
          final s = widget.stats[i];
          return Padding(
            padding: EdgeInsets.only(
              right: i == widget.stats.length - 1 ? 0 : 10,
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
                // border: Border.all(color: ColorRes.leadGreyColor.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 28,
                      // fit: BoxFit.scaleDown,
                      child: Text(
                        s.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontWeight: AppFontWeights.bold,
                          fontSize: AppFontSizes.body,
                          color: ColorRes.primary,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 4),
                  Text(
                    s.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                      color: ColorRes.leadGreyColor.shade700,
                    ),
                  ),
                ],
              ),
            ),
        
        );
      }),
    );
  }
}

class _SellWith extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FeatureItemData> features;
  final VoidCallback? onManage;
  const _SellWith({
    required this.title,
    required this.subtitle,
    required this.features,
    this.onManage,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor.shade700,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...features.map(
          (f) =>
              _FeatureCard(icon: f.icon, title: f.title, subtitle: f.subtitle),
        ),
        const SizedBox(height: 20),
        _ManageListingCallout(
          title:
              (context
                  .findAncestorWidgetOfExactType<ListingIntroScreen>()
                  ?.config
                  .manageTitle) ??
              'Already have a listing?',
          subtitle:
              (context
                  .findAncestorWidgetOfExactType<ListingIntroScreen>()
                  ?.config
                  .manageSubtitle) ??
              'Boost your listing to the top of search results and sell 3x faster.',
          buttonText:
              (context
                  .findAncestorWidgetOfExactType<ListingIntroScreen>()
                  ?.config
                  .manageButtonText) ??
              'Manage Listings',
          onTap: onManage,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.bold,
              color: ColorRes.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor.shade700,
              fontWeight: AppFontWeights.medium,
            ),
          ),
        ),
      ],
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        // border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: ColorRes.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade700,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManageListingCallout extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onTap;
  const _ManageListingCallout({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7E8FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          NesticoPeButton(
            title: buttonText,
            onTap: onTap ?? () {},
            height: 44,
            backgroundColor: ColorRes.primary,
            borderRadius: BorderRadius.circular(10),
            titleTextStyle: const TextStyle(
              fontSize: AppFontSizes.medium,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumListings extends StatelessWidget {
  final String title;
  final String actionText;
  final List<PremiumListingItem> items;
  const _PremiumListings({
    required this.items,
    this.title = 'Premium Listings',
    this.actionText = 'View All',
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            Text(
              actionText,
              style: const TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final it = items[index];
              return Container(
                width: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.asset(
                        it.imageAsset,
                        height: 110,
                        width: 260,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            it.title,
                            style: const TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            it.subtitle,
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.leadGreyColor.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.king_bed_outlined,
                                size: 14,
                                color: ColorRes.textPrimary,
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.aspect_ratio,
                                size: 14,
                                color: ColorRes.textPrimary,
                              ),
                              const Spacer(),
                              Text(
                                it.priceText,
                                style: const TextStyle(
                                  fontWeight: AppFontWeights.semiBold,
                                  color: ColorRes.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ResellerAchievementsSection extends StatefulWidget {
  const _ResellerAchievementsSection({super.key});
  @override
  State<_ResellerAchievementsSection> createState() =>
      _ResellerAchievementsSectionState();
}

class _ResellerAchievementsSectionState
    extends State<_ResellerAchievementsSection> {
  late final SearchHistoryController controller =
      Get.isRegistered<SearchHistoryController>()
          ? Get.find<SearchHistoryController>()
          : Get.put(SearchHistoryController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.items.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Our Partners' Achievements",
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            SizedBox(height: 6),
            ContractorCardShimmer(),
          ],
        );
      }
      if (controller.items.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Partners' Achievements",
            style: TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 400,
            child: ListView.separated(
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              scrollDirection: Axis.horizontal,
              itemCount: controller.items.length,
              itemBuilder: (context, index) {
                final data = controller.items[index];
                return _SuccessStoryCard(item: data);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _SuccessStoryCard extends StatelessWidget {
  final BuyerSideResellerSuccessStoryItem item;
  const _SuccessStoryCard({required this.item});
  @override
  Widget build(BuildContext context) {
    final month =
        item.monthYear != null
            ? DateFormat('MMMM yyyy').format(item.monthYear!)
            : '';
    final deals = item.totalDeals ?? 0;
    final valueStr = item.totalValue ?? '';
    final valueNum =
        int.tryParse(valueStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final valueFormatted = NumberFormat.decimalPattern(
      'en_IN',
    ).format(valueNum);
    final rating = item.rating?.toDouble() ?? 0.0;
    return GestureDetector(
      onTap:
          () => Get.to(() => ResellerSuccessDetailScreen(successStory: item)),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  item.image ?? '',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          Container(height: 120, color: Colors.grey.shade200),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title ?? '',
                style: const TextStyle(
                  fontSize: AppFontSizes.body,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...List.generate(
                    5,
                    (i) => const Icon(
                      Icons.star,
                      size: 16,
                      color: Color(0xFFFFB800),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if ((item.achievement ?? '').isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFFCF3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.achievement ?? '',
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      fontWeight: AppFontWeights.medium,
                      color: Color(0xFF16A34A),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F7FB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'DEALS',
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.textSecondary,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          Text(
                            Formatter.formatNumber(item.totalDeals ?? 0),

                            style: const TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VALUE',
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.textSecondary,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                          Text(
                            Formatter.formatPrice(
                              num.tryParse(item.totalValue ?? "0") ?? 0,
                            ),

                            style: const TextStyle(
                              fontSize: AppFontSizes.bodySmall,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              Text(
                item.description ?? '',
                style: const TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: Colors.black54,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Divider(color: ColorRes.leadGreyColor.shade300),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'By: ',
                            style: TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.textSecondary,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                          TextSpan(
                            text:
                                (item.reseller?.username ?? '').isNotEmpty
                                    ? item.reseller?.username ?? ''
                                    : '',
                            style: const TextStyle(
                              fontSize: AppFontSizes.caption,
                              color: ColorRes.primary,
                              fontWeight: AppFontWeights.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.textSecondary,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewsSection extends StatefulWidget {
  final String entityType; // seller | reseller | contractor

  final String newEntityType;
  const _ReviewsSection({super.key, required this.entityType,required this.newEntityType});


  @override
  State<_ReviewsSection> createState() => _ReviewsSectionState();
}

class _ReviewsSectionState extends State<_ReviewsSection> {
  late final PlatformReviewController controller =
      Get.isRegistered<PlatformReviewController>()
          ? Get.find<PlatformReviewController>()
          : Get.put(PlatformReviewController(type: [widget.entityType],filters: {}));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.filters = {
        'entity_type': [widget.entityType],
        'status': 'published',
      };
      await controller.fetchAllReviews(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value && controller.allReviews.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: CircularProgressIndicator(color: ColorRes.primary),
          ),
        );
      }
      if (controller.allReviews.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.newEntityType == 'seller'
                    ? 'What Our Property Owners Say'
                    : widget.newEntityType == 'builder'
                        ? 'What Our Developers Say'
                        : widget.newEntityType == 'contractor'
                            ? 'What Our Contractors Say'
                            : widget.newEntityType == 'reseller'
                                ? 'What Partners Say'
                                : 'What Our Customers Say',
                style: const TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.bold,
                  color: ColorRes.textPrimary,
                ),
              ),



              const SizedBox(height: 6),

              Text(
                widget.newEntityType == 'seller'
                    ? 'Real success stories from homeowners who sold faster with NesticoPe'
                    : widget.newEntityType == 'builder'
                        ? 'See how top builders scaled their project sales with NesticoPe'
                        : widget.newEntityType == 'contractor'
                            ? 'Success stories from top construction professionals on NesticoPe'
                            : widget.newEntityType == 'reseller'
                                ? 'Real experiences from our earning partners'
                                : 'Real experiences shared by our valued customers',
                                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: ColorRes.leadGreyColor.shade700,
                  fontWeight: AppFontWeights.medium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 185,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.allReviews.length,
              clipBehavior: Clip.none,

              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return _ReviewCard(review: controller.allReviews[index]);
              },
            ),
          ),
        ],
      );
    });
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewItem review;
  const _ReviewCard({required this.review});
  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final rating = review.rating ?? 0.0;
    final user = review.entityUser;
    final username = user?.username ?? '';
    final roleRaw = user?.userType ?? '';
    final role =
        roleRaw.isNotEmpty
            ? '${roleRaw[0].toUpperCase()}${roleRaw.substring(1).toLowerCase()}'
            : '';
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(AppRadius.mediumLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              review.title ?? '',
              style: const TextStyle(
                fontSize: AppFontSizes.bodySmall,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Stars + numeric rating
            Row(
              children: [
                ...List.generate(5, (i) {
                  final filled = i < rating.round();
                  return Padding(
                    padding: const EdgeInsets.only(right: 2),
                    child: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: const Color(0xFFFFB800),
                      size: 16,
                    ),
                  );
                }),
                const SizedBox(width: 6),
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Content with adaptive spacer to align divider across cards (target: 2 lines height)
            LayoutBuilder(
              builder: (context, constraints) {
                final contentText = review.content ?? '';
                const contentStyle = TextStyle(
                  fontSize: AppFontSizes.caption,
                  color: Colors.black54,
                );
                final painter = TextPainter(
                  text: TextSpan(text: contentText, style: contentStyle),
                  maxLines: 2,
                  textDirection: Directionality.of(context),
                )..layout(maxWidth: constraints.maxWidth);
                final metrics = painter.computeLineMetrics();
                int lines = metrics.length;
                if (lines > 2) lines = 2;
                final lineHeight =
                    metrics.isNotEmpty ? metrics.first.height : 0.0;
                final targetHeight =
                    lineHeight * 2; // aim to align as if 2 lines
                final actualHeight = lineHeight * lines;
                final extraSpacer = (targetHeight - actualHeight).clamp(
                  0.0,
                  double.infinity,
                );
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contentText,
                      style: contentStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6 + extraSpacer),
                    Divider(color: ColorRes.leadGreyColor.shade300),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
            // Footer: avatar, username, role, date
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2563EB).withOpacity(0.1),
                    border: Border.all(
                      color: const Color(0xFF2563EB).withOpacity(0.25),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (username.isNotEmpty ? username[0] : '?').toUpperCase(),
                    style: const TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: const TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.homeBlackFade,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (role.isNotEmpty) const SizedBox(height: 2),
                      if (role.isNotEmpty)
                        Text(
                          role,
                          style: const TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.primary,
                          ),
                        ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(DateTime.tryParse(review.createdAt ?? '')),
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.leadGreyColor.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PartnerProgramSection extends StatelessWidget {
  final String heading;
  final String description;
  final List<_Point> leftPoints;
  final String rightTitle;
  final String rightSubtitle;
  final List<String> rightBullets;
  const _PartnerProgramSection({
    super.key,
    required this.heading,
    required this.description,
    required this.leftPoints,
    required this.rightTitle,
    required this.rightSubtitle,
    required this.rightBullets,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          heading,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: AppFontSizes.caption,
            color: ColorRes.leadGreyColor.shade700,
            fontWeight: AppFontWeights.medium,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: icon points
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final p in leftPoints) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2563EB).withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            p.icon,
                            color: const Color(0xFF2563EB),
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: const TextStyle(
                                fontSize: AppFontSizes.medium,
                                fontWeight: AppFontWeights.semiBold,
                                color: ColorRes.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              p.subtitle,
                              style: TextStyle(
                                fontSize: AppFontSizes.caption,
                                color: ColorRes.leadGreyColor.shade700,
                                fontWeight: AppFontWeights.medium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            // Right: Why Join Us card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(AppRadius.large),
                border: Border.all(color: ColorRes.leadGreyColor.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rightTitle,
                    style: const TextStyle(
                      fontSize: AppFontSizes.body,
                      fontWeight: AppFontWeights.bold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    rightSubtitle,
                    style: TextStyle(
                      fontSize: AppFontSizes.caption,
                      color: ColorRes.leadGreyColor.shade700,
                      fontWeight: AppFontWeights.medium,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (final b in rightBullets) ...[
                    Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF16A34A),
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            b,
                            style: const TextStyle(
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.semiBold,
                              color: ColorRes.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Point {
  final IconData icon;
  final String title;
  final String subtitle;
  const _Point({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

class _PremiumPropertyCarousel extends StatefulWidget {
  const _PremiumPropertyCarousel({super.key});
  @override
  State<_PremiumPropertyCarousel> createState() =>
      _PremiumPropertyCarouselState();
}

class _PremiumPropertyCarouselState extends State<_PremiumPropertyCarousel> {
  late final PropertyController controller =
      Get.isRegistered<PropertyController>()
          ? Get.find<PropertyController>()
          : Get.put(PropertyController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.setPropertyLimit(4);
      controller.fetchCreatedBy(withoutCity: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Premium Listings',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          final items = controller.items;
          if (controller.isLoading.value && items.isEmpty) {
            return SizedBox(
              height: 320,
              child: Center(
                child: CircularProgressIndicator(color: ColorRes.primary),
              ),
            );
          }
          if (items.isEmpty) {
            return const SizedBox.shrink();
          }
          return SizedBox(
            height: 320,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length.clamp(0, 10),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final it = items[index];
                return PropertyCard(property: it);
              },
            ),
          );
        }),
      ],
    );
  }
}

class _PremiumProjectCarousel extends StatefulWidget {
  const _PremiumProjectCarousel({super.key});
  @override
  State<_PremiumProjectCarousel> createState() =>
      _PremiumProjectCarouselState();
}

class _PremiumProjectCarouselState extends State<_PremiumProjectCarousel> {
  late final ProjectWizardController controller =
      Get.isRegistered<ProjectWizardController>()
          ? Get.find<ProjectWizardController>()
          : Get.put(ProjectWizardController(isBuilderView: false));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.youWantWithoutCity.value = true;
      controller.filters = {'approval_status': 'approved', 'limit': '4'};
      controller.loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Premium Projects',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Obx(() {
          final items = controller.items;
          if (controller.isLoading.value && items.isEmpty) {
            return SizedBox(
              height: 320,
              child: Center(
                child: CircularProgressIndicator(color: ColorRes.primary),
              ),
            );
          }
          if (items.isEmpty) {
            return const SizedBox.shrink();
          }
          return SizedBox(
               height: 290,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length.clamp(0, 10),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final data = items[index];
                return GestureDetector(
                  onTap:
                      () =>
                          Get.to(() => ProjectDetailsScreen(projectItem: data)),
                  child: BuilderProjectCard(
                    forHome: true,
                    project: data,
                   width: MediaQuery.of(context).size.width * 0.85,
                    height: 150,
                    developersName: data.projectContactInfo?.name ?? 'Unknown',
                    imageUrl:
                        (data.mediaGallery?.images?.isNotEmpty ?? false)
                            ? data.mediaGallery!.images.first
                            : IMGRes.home3,
                    projectName:
                        data.projectName.isNotEmpty ? data.projectName : 'N/A',
                    location:
                        data.address.isNotEmpty
                            ? data.address
                            : 'Not specified',
                    price: data.getPriceRange(),
                    propertySize:
                        data.projectSize?.totalBuildings?.toString() ?? '—',
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _HowItWorks extends StatelessWidget {
  final String title;
  final List<HowStep> steps;
  final bool isBulletPoint;
  const _HowItWorks({
    required this.title,
    required this.steps,
    this.isBulletPoint = false,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: AppFontWeights.bold,
              fontSize: AppFontSizes.body,
              color: ColorRes.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ...List.generate(steps.length, (i) {
          final s = steps[i];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (isBulletPoint) ...[
                    Icon(Icons.check_circle, size: 20, color: ColorRes.primary),
                  ] else ...[
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: ColorRes.primary,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: ColorRes.white,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ],

                  if (i != steps.length - 1)
                    Container(
                      width: 2,
                      height: 32,
                      color: ColorRes.leadGreyColor.shade300,
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.title,
                        style: const TextStyle(
                          fontSize: AppFontSizes.bodySmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        s.subtitle,
                        style: TextStyle(
                          fontSize: AppFontSizes.caption,
                          fontWeight: AppFontWeights.medium,

                          color: ColorRes.leadGreyColor.shade700,
                        ),
                      ),
                      SizedBox(height: isBulletPoint ? 8 : 0),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

// class _PlansForm extends StatelessWidget {
//   final PlansFormConfig cfg;
//   final VoidCallback? onSubmit;
//   const _PlansForm({required this.cfg, this.onSubmit});
//   @override
//   Widget build(BuildContext context) {
//     final name = TextEditingController();
//     final email = TextEditingController();
//     final phone = TextEditingController();
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//             decoration: BoxDecoration(
//               color: const Color(0xFFEFF0FF),
//               borderRadius: BorderRadius.circular(20),
//               border: Border.all(color: const Color(0xFFE5E7EB)),
//             ),
//             child: Text(
//               cfg.pillText.toUpperCase(),
//               style: const TextStyle(
//                 fontSize: AppFontSizes.caption,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.primary,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             cfg.title,
//             style: const TextStyle(
//               fontSize: AppFontSizes.body,
//               fontWeight: AppFontWeights.semiBold,
//               color: ColorRes.textPrimary,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             cfg.subtitle,
//             style: TextStyle(
//               fontSize: AppFontSizes.caption,
//               color: ColorRes.leadGreyColor.shade700,
//             ),
//           ),
//           const SizedBox(height: 12),
//           NesticoPeTextField(
//             controller: name,
//             hintText: 'Your Name',
//             title: '',
//             prefixIcon: Icons.person_outline,
//           ),
//           const SizedBox(height: 10),
//           NesticoPeTextField(
//             controller: email,
//             hintText: 'Email Address',
//             title: '',
//             prefixIcon: Icons.mail_outline,
//           ),
//           const SizedBox(height: 10),
//           NesticoPeTextField(
//             controller: phone,
//             hintText: 'Phone Number',
//             title: '',
//             prefixIcon: Icons.phone_outlined,
//           ),
//           const SizedBox(height: 12),
//           NesticoPeButton(
//             title: cfg.buttonText,
//             onTap: onSubmit ?? () {},
//             width: double.infinity,
//             height: 44,
//             backgroundColor: ColorRes.primary,
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ],
//       ),
//     );
//   }
// }

class _ContractorStrategy extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FeatureItemData> steps;

  const _ContractorStrategy({
    required this.title,
    required this.subtitle,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,

            color: ColorRes.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: List.generate(steps.length, (index) {
            final step = steps[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
                // border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFF4F46E5).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      step.icon,
                      color: const Color(0xFF4F46E5),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Step ${index + 1}',
                            style: const TextStyle(
                              color: Color(0xFF4F46E5),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          step.title,
                          style: const TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.subtitle,
                          style: const TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ContractorBenefitsGrid extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<FeatureItemData> benefits;

  const _ContractorBenefitsGrid({
    required this.title,
    required this.subtitle,
    required this.benefits,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.bold,
            color: ColorRes.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: AppFontSizes.caption,
            fontWeight: AppFontWeights.medium,

            color: ColorRes.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),
        Column(
          children: List.generate(benefits.length, (index) {
            final benefit = benefits[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ColorRes.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      benefit.icon,
                      color: ColorRes.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          benefit.title,
                          style: TextStyle(
                            fontSize: AppFontSizes.medium,
                            fontWeight: AppFontWeights.semiBold,
                            color: ColorRes.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          benefit.subtitle,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.textSecondary,

                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _MultipleWaysToEarn extends StatelessWidget {
  const _MultipleWaysToEarn();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Blue Header Card
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'Multiple Ways to Earn',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Unlock multiple revenue streams and maximize your income through our partner rewards program.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: AppFontWeights.medium,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Earning Items
        _buildEarnCard(
          icon: Icons.monetization_on_outlined,
          iconColor: const Color(0xFF2563EB),
          bgColor: const Color(0xFFE0E7FF),
          title: 'Direct Commission',
          subtitle: 'Earn a high percentage on every successful property deal.',
        ),
        _buildEarnCard(
          icon: Icons.people_outline,
          iconColor: const Color(0xFF7C3AED),
          bgColor: const Color(0xFFEDE9FE),
          title: 'Referral Bonus',
          subtitle: 'Get rewarded for growing our partner network.',
        ),
        _buildEarnCard(
          icon: Icons.calendar_today_outlined,
          iconColor: const Color(0xFF10B981),
          bgColor: const Color(0xFFD1FAE5),
          title: 'Monthly Bonus',
          subtitle: 'Extra rewards based on your monthly performance.',
        ),
        _buildEarnCard(
          icon: Icons.auto_awesome_outlined,
          iconColor: const Color(0xFFF59E0B),
          bgColor: const Color(0xFFFEF3C7),
          title: 'Milestone Rewards',
          subtitle: 'Special incentives as you reach new business milestones.',
        ),
      ],
    );
  }

  Widget _buildEarnCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: AppFontWeights.semiBold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade700,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewPlansCallout extends StatelessWidget {
  final String title;
  final String subtitle;

  final String buttonText;
  final VoidCallback? onTap;
  const _ViewPlansCallout({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: AppFontSizes.body,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppFontSizes.caption,
              color: ColorRes.leadGreyColor.shade700,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: NesticoPeButton(
              title: buttonText,
              onTap: onTap ?? () {},
              height: 44,
              backgroundColor: ColorRes.primary,
              borderRadius: BorderRadius.circular(10),
              titleTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: AppFontWeights.semiBold,
                fontSize: AppFontSizes.small,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FinalCallout extends StatelessWidget {
  final FinalCalloutConfig cfg;
  final VoidCallback? onTap;
  const _FinalCallout({required this.cfg, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            cfg.headline,
            style: const TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.semiBold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          ...cfg.points.map(
            (p) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(
                    Icons.fiber_manual_record,
                    size: 8,
                    color: ColorRes.success,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      p,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: AppFontWeights.medium,
                        fontSize: AppFontSizes.caption,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          NesticoPeButton(
            title: cfg.cta,
            onTap: onTap ?? () {},
            width: double.infinity,
            height: 44,
            backgroundColor: Colors.white,
            titleTextStyle: const TextStyle(
              color: ColorRes.primary,
              fontWeight: AppFontWeights.semiBold,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }
}
