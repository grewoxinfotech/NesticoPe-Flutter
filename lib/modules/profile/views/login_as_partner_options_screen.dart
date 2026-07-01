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

class LoginAsPartnerOptionsScreen extends StatelessWidget {
  const LoginAsPartnerOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ConversionItem(
        title: 'Convert to Partner',
        subtitle: 'Earn commissions promoting properties',
        icon: Icons.handshake_outlined,
        color: const Color(0xFF4A6CF7),
        onTap:
            () =>
            // (!UserHelper.isGuest)
            //     // ? Get.to(() => ResellerConversionScreen())
            Get.to(
              () => ListingIntroScreen(
                role: Roles.reseller.name,
                planTitle: "Partner Plans",
                isBulletPoint: true,
                config: ListingIntroConfig(
                  logoAsset: 'assets/images/NesticoPe_logo.png',
                  appBarBrand: 'NesticoPe',
                  badgeText: 'New Feature',

                  headline: '''Start Your Real Estate''',
                  highlightWord: 'Journey With Us',
                  subHeadline:
                      'Unlock endless possibilities in the property market with our advanced platform and verified inventory.',
                  primaryCta: 'Sign Up as Partner',
                  sellWithTitle: 'How You Can Earn?',
                  sellWithSubtitle:
                      'Simple 4-step process to start your real estate business with zero investment',
                  manageTitle: 'Already have a partner account?',
                  manageSubtitle:
                      'Boost visibility and manage leads from one place.',
                  manageButtonText: 'Manage Account',
                  premiumTitle: 'Featured Projects',
                  premiumActionText: 'View All',
                  stepsTitle: 'Why Become a NesticoPe Partner?',
                  viewPlansTitle: 'Find the Perfect Plan for You',
                  viewPlansSubtitle:
                      'Choose from premium plans to maximize your partner visibility.',

                  viewPlansButtonText: 'View Plans',
                  stats: const [
                    StatItemData('High', 'Commission Payouts'),
                    StatItemData('Rapidly Growing', 'Property Sales'),
                    StatItemData('Expanding', 'Partner Network'),
                  ],

                  features: const [
                    FeatureItemData(
                      Icons.person_add_outlined,
                      'Register & Join',
                      'Create your partner profile and get verified in minutes.',
                    ),
                    FeatureItemData(
                      Icons.search_off_sharp,
                      'Access Inventory',
                      'Browse thousands of verified properties and projects.',
                    ),
                    FeatureItemData(
                      Icons.share_outlined,
                      'Share & Connect',
                      'Share personalized property links with your potential buyers.',
                    ),
                    FeatureItemData(
                      Icons.attach_money_outlined,
                      'Earn Commission',
                      'Receive direct payouts when your clients close a deal.',
                    ),
                  ],
                  premiumListings: const [
                    PremiumListingItem(
                      imageAsset: IMGRes.home2,
                      title: 'Skyline Apartments',
                      subtitle: 'Downtown, NYC',
                      priceText: '₹45,00,000',
                    ),
                    PremiumListingItem(
                      imageAsset: IMGRes.project_2,
                      title: 'Greenview Residency',
                      subtitle: 'Udhna, Surat',
                      priceText: '₹1,20,00,000',
                    ),
                  ],
                  steps: const [
                    HowStep(
                      'High Commission',
                      'Earn up to 2% on every successful deal.',
                    ),
                    HowStep(
                      'Trusted Network',
                      'Partner with verified builders & owners.',
                    ),
                    HowStep('Premium Support', '24/7 dedicated support team.'),
                    HowStep(
                      'Quality Listings',
                      'Access to verified property listings.',
                    ),
                    HowStep(
                      'Gamified Dashboard',
                      'Track your earnings and progress seamlessly.',
                    ),
                    HowStep(
                      'Special Incentives',
                      'Earn bonuses and extra rewards for your performance.',
                    ),
                  ],
                  plansForm: const PlansFormConfig(
                    pillText: 'Pricing',
                    title: 'Owner Premium Plans',
                    subtitle:
                        'Get featured, sell 3x faster with priority support',
                    buttonText: 'Unlock Owner Plans',
                  ),
                  finalCallout: const FinalCalloutConfig(
                    headline: "Ready to Scale Your Earning?",
                    points: [
                      'Elite Active Partners',
                      'Huge Comm. Paid',
                      'Reliable Partner Support',
                    ],
                    cta: 'Start Your Journey Now',
                  ),
                ),
                onBecomeType: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(context).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.reseller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ResellerConversionScreen());
                  } else if (UserHelper.isReseller) {
                    Get.to(() => MainNavigationScreen());
                  }
                }, // Manage List
                onPrimaryCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.reseller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ResellerConversionScreen());
                  } else if (UserHelper.isReseller) {
                    Get.to(() => MainNavigationScreen());
                  }
                }, // Post Property Free
                onManageListings: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.reseller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ResellerConversionScreen());
                  } else if (UserHelper.isReseller) {
                    Get.to(() => MainNavigationScreen());
                  }
                }, // Manage Listings
                onUnlockPlans: () async {
                  final data =
                      await SecureStorage.hasSubscriptionInquiryForUser(
                        Roles.reseller.name,
                        userId: (await SecureStorage.getClientId()) ?? '',
                        role: Roles.reseller.name,
                      );
                  debugPrint("Has Subscription Inquiry For : $data");
                  Get.to(
                    () => SubscriptionPlansScreen(
                      isNotFromBuyerSide: false,
                      role: Roles.reseller.name,
                      isInquirySubmitted: data,
                      origin: 'buyer',
                    ),
                  );
                }, // Unlock Owner Plans
                onFinalCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.reseller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ResellerConversionScreen());
                  } else if (UserHelper.isReseller) {
                    Get.to(() => MainNavigationScreen());
                  }
                }, // Final CTA
              ),
            ),
      ),
      _ConversionItem(
        title: 'Convert to Seller',
        subtitle: 'Start listing and selling properties',
        icon: Icons.storefront_outlined,
        color: const Color(0xFF6A5AE0),
        onTap:
            () => Get.to(
              () => ListingIntroScreen(
                role: Roles.sellerOwner.name,
                planTitle: "Seller Plans",
                config: ListingIntroConfig(
                  logoAsset: 'assets/images/NesticoPe_logo.png',
                  appBarBrand: 'NesticoPe',
                  badgeText: 'New Feature',
                  headline: 'Sell Your Property',
                  highlightWord: 'Faster with NesticoPe',
                  subHeadline:
                      'Post your property for FREE and reach thousands of verified buyers directly. No brokers, no hidden fees, only pure success.',
                  primaryCta: 'Post Property Free',
                  sellWithTitle: 'Sell With NesticoPe',
                  sellWithSubtitle:
                      'We provide the tools and reach you need to sell your property at the best price.',
                  manageTitle: 'Already have a listing?',
                  manageSubtitle:
                      'Boost your listing to the top of search results and sell 3x faster.',
                  manageButtonText: 'Manage Listings',
                  premiumTitle: 'Premium Listings',
                  premiumActionText: 'View All',
                  stepsTitle: 'How It Works?',
                  viewPlansTitle: 'Find the Perfect Plan for You',
                  viewPlansSubtitle:
                      'Choose from our range of premium plans designed to get your property sold faster with maximum exposure.',
                  viewPlansButtonText: 'View Plans',
                  stats: [
                    StatItemData('Growing', 'Active Buyers'),
                    StatItemData('Massive', 'Monthly Leads'),
                    StatItemData('Trusted', 'Top Sellers'),
                  ],
                  features: [
                    FeatureItemData(
                      Icons.camera_alt_outlined,
                      'Free Listing',
                      'List your property for free and reach thousands of buyers without any cost .',
                    ),
                    FeatureItemData(
                      Icons.visibility_outlined,
                      'More Visibility',
                      'Get your property in front of thousands of active buyers every day.',
                    ),
                    FeatureItemData(
                      Icons.support_agent_outlined,
                      'NesticoPe Support',
                      'Dedicated relationship managers to help you list and sell.',
                    ),
                    FeatureItemData(
                      Icons.verified_outlined,
                      'Serious Inquiries',
                      'Build trust with buyers and receive inquiries from verified, serious buyers.',
                    ),
                  ],
                  premiumListings: [
                    PremiumListingItem(
                      imageAsset: IMGRes.home2,
                      title: 'Skyline Apartments',
                      subtitle: 'Downtown, NYC',
                      priceText: '₹45,00,000',
                    ),
                    PremiumListingItem(
                      imageAsset: IMGRes.project_2,
                      title: 'Greenview Residency',
                      subtitle: 'Udhna, Surat',
                      priceText: '₹1,20,00,000',
                    ),
                  ],
                  steps: [
                    HowStep(
                      'Post Property',
                      'Enter basic details and upload high-quality photos in just few minutes.',
                    ),
                    HowStep(
                      'Get Verified',
                      'Our team verifies your listing to build trust with potential buyers.',
                    ),
                    HowStep(
                      'Receive Inquiries',
                      'Buyers will contact you directly via call or message through our platform.',
                    ),
                    HowStep(
                      'Close the Deal',
                      'Negotiate directly and sell your property with zero brokerage fees.',
                    ),
                  ],
                  plansForm: const PlansFormConfig(
                    pillText: 'Pricing',
                    title: 'Owner Premium Plans',
                    subtitle:
                        'Get featured, sell 3x faster with priority support',
                    buttonText: 'Unlock Owner Plans',
                  ),
                  finalCallout: const FinalCalloutConfig(
                    headline: "Still Waiting? Your Buyer Isn’t!",
                    points: [
                      'Quick Fast Posting',
                      'Zero Brokerage',
                      'Unlimited Visibility',
                    ],
                    cta: 'Start Your Free Listing',
                  ),
                ),
                onPrimaryCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerOwner) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerDashboardScreen());
                  }
                }, // Post Property Free
                onManageListings: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerOwner) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerDashboardScreen());
                  }
                }, // Manage Listings
                onUnlockPlans: () async {
                  // Get.to(
                  //   () => SubscriptionPlansScreen(
                  //     role: Roles.sellerOwner.name,

                  //     origin: 'buyer',
                  //     isNotFromBuyerSide: false,
                  //   ),
                  // );
                  final data =
                      await SecureStorage.hasSubscriptionInquiryForUser(
                        Roles.sellerOwner.name,
                        userId: (await SecureStorage.getClientId()) ?? '',
                        role: Roles.sellerOwner.name,
                      );
                  debugPrint("Has Subscription Inquiry For : $data");
                  Get.to(
                    () => SubscriptionPlansScreen(
                      role: Roles.sellerOwner.name,
                      isInquirySubmitted: data,
                      origin: 'buyer',
                      isNotFromBuyerSide: false,
                    ),
                  );
                }, // Unlock Owner Plans
                onBecomeType: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(context).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerOwner) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerDashboardScreen());
                  }
                },
                onFinalCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerOwner) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerDashboardScreen());
                  }
                }, // Final CTA
              ),
            ),
      ),
      _ConversionItem(
        title: 'Convert to Contractor',
        subtitle: 'Offer renovation and construction services',
        icon: Icons.engineering_outlined,
        color: const Color(0xFF00A28A),
        onTap:
            () =>
            // (!UserHelper.isGuest)
            // ? Get.to(() => ConvertToContractorConversionScreen())
            Get.to(
              () => ListingIntroScreen(
                role: Roles.contractor.name,
                showPropertySection: false,
                planTitle: "Contractor Plans",

                config: ListingIntroConfig(
                  contractorStrategyTitle:
                      'Skyrocket Your Business as a NesticoPe Contractor',
                  contractorStrategySubtitle:
                      'Strategic steps to scale your construction business with our platform',
                  contractorStrategySteps: const [
                    FeatureItemData(
                      Icons.search,
                      'Identify Local Demand',
                      'Use our data insights to find high-demand localities in your expertise.',
                    ),
                    FeatureItemData(
                      Icons.bar_chart,
                      'Optimize Your Profile',
                      'Showcase your best projects and gather verified reviews for higher visibility.',
                    ),
                    FeatureItemData(
                      Icons.rocket_launch,
                      'Leverage Technology',
                      'Use our advanced management tools to streamline your operations and sales.',
                    ),
                  ],
                  contractorBenefitsTitle:
                      'Empowering Your Construction Business',
                  contractorBenefitsSubtitle:
                      'At NesticoPe, we provide a holistic platform for contractors. We offer buyers a complete property solution from initial searching and legal vetting to high-quality construction and interior design. This integrated approach ensures a steady flow of verified projects for our partners, creating a massive opportunity for everyone to scale their business with trust and technology.',
                  contractorBenefits: const [
                    FeatureItemData(
                      Icons.trending_up,
                      'Complete Project Ecosystem',
                      'We offer buyers everything—from property search and legal work to construction and interior design. You are part of a full-service journey.',
                    ),
                    FeatureItemData(
                      Icons.business,
                      'Verified High-Intent Leads',
                      'Access a steady stream of verified construction and renovation inquiries from buyers already engaged in our property ecosystem.',
                    ),
                    FeatureItemData(
                      Icons.verified,
                      'VBrand Authority',
                      'Build a verified professional contractor profile that establishes immediate trust with property owners and large-scale developers.',
                    ),
                    FeatureItemData(
                      Icons.construction,
                      'Advanced Digital Tools',
                      'Manage projects, track site visits, and showcase your portfolio with our enterprise-grade contractor dashboard.',
                    ),
                    FeatureItemData(
                      Icons.location_city,
                      'Premium Networking',
                      'Connect with top builders and developers for high-value commercial and residential construction opportunities.',
                    ),
                    FeatureItemData(
                      Icons.handshake,
                      'Unmatched Growth Support',
                      'Scale your construction business with 24/7 dedicated support and specialized marketing solutions for elite contractors.',
                    ),
                  ],
                  logoAsset: 'assets/images/NesticoPe_logo.png',
                  appBarBrand: 'NesticoPe',
                  badgeText: 'New Feature',

                  headline: 'Build Your Legacy',
                  highlightWord: 'With NesticoPe',
                  subHeadline:
                      'Grow your business with verified leads and professional tools.',
                  primaryCta: 'Sign Up as Contractor',
                  sellWithTitle: 'What NesticoPe Expects from You',
                  sellWithSubtitle:
                      'We maintain the highest standards to ensure quality and trust in our ecosystem.',
                  manageTitle: 'Already have services?',
                  manageSubtitle:
                      'Boost visibility and manage your services from one place.',
                  manageButtonText: 'Manage Services',
                  premiumTitle: 'Featured Contractors',
                  premiumActionText: 'View All',
                  stepsTitle: 'How It Works?',
                  viewPlansTitle: 'Find the Perfect Plan for You',
                  viewPlansSubtitle:
                      'Choose from premium plans to maximize your reach and brand visibility.',
                  viewPlansButtonText: 'View Plans',
                  stats: const [
                    StatItemData('₹100Cr+', 'Projects Completed'),
                    StatItemData('800+', 'Active Projects'),
                    StatItemData('300+', 'Verified Contractors'),
                  ],
                  features: const [
                    FeatureItemData(
                      Icons.security_outlined,
                      'No Spam Policy',
                      '''We value our buyers' privacy. Only meaningful interactions are encouraged.''',
                    ),
                    FeatureItemData(
                      Icons.high_quality_outlined,
                      'Quality Over Quantity',
                      'We prioritize exceptional craftsmanship over the number of projects handled.',
                    ),
                    FeatureItemData(
                      Icons.verified_outlined,
                      'Verified Professionals Only',
                      'Every contractor must pass a thorough verification process for trust.',
                    ),
                    // FeatureItemData(
                    //   Icons.support_agent_outlined,
                    //   'Direct Support',
                    //   'Dedicated support for project management and updates.',
                    // ),
                  ],

                  premiumListings: const [
                    PremiumListingItem(
                      imageAsset: IMGRes.home2,
                      title: 'Skyline Apartments',
                      subtitle: 'Downtown, NYC',
                      priceText: '₹45,00,000',
                    ),
                    PremiumListingItem(
                      imageAsset: IMGRes.project_2,
                      title: 'Greenview Residency',
                      subtitle: 'Udhna, Surat',
                      priceText: '₹1,20,00,000',
                    ),
                  ],
                  steps: const [
                    HowStep(
                      'Register & Profile',
                      'Complete your professional registration and get verified.',
                    ),
                    HowStep(
                      'Add Your Services',
                      'List your specialized construction services and expertise.',
                    ),
                    HowStep(
                      'Get Quality Leads',
                      'Receive inquiries from interested clients.',
                    ),
                    HowStep(
                      'Start Project',
                      'Connect with clients and start your construction work.',
                    ),
                    HowStep(
                      'High Earnings',
                      'Grow your business and maximize your revenue with us.',
                    ),
                  ],
                  plansForm: const PlansFormConfig(
                    pillText: 'Pricing',
                    title: 'Contractor Premium Plans',
                    subtitle: 'Get featured and grow your service business',
                    buttonText: 'Unlock Contractor Plans',
                  ),
                  finalCallout: const FinalCalloutConfig(
                    headline: "Ready to Build Your Legacy?",
                    points: [
                      '300+ Verified Contractors',
                      '₹100Cr+ Projects Value',
                      '24/7 Expert Support',
                    ],
                    cta: 'Start Your Journey Now',
                  ),
                ),
                onBecomeType: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(context).pop();
                    await Get.to(
                      () => RegisterScreen(role: UserRole.contractor),
                    );
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ConvertToContractorConversionScreen());
                  } else if (UserHelper.isContractor) {
                    Get.to(() => ContractorMainScreen());
                  }
                },
                onPrimaryCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(
                      () => RegisterScreen(role: UserRole.contractor),
                    );
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ConvertToContractorConversionScreen());
                  } else if (UserHelper.isContractor) {
                    Get.to(() => ContractorMainScreen());
                  }
                }, // Post Property Free
                onManageListings: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(
                      () => RegisterScreen(role: UserRole.contractor),
                    );
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ConvertToContractorConversionScreen());
                  } else if (UserHelper.isContractor) {
                    Get.to(() => ContractorMainScreen());
                  }
                }, // Manage Listings
                onUnlockPlans: () async {
                  // final data =
                  //     await SecureStorage.hasSubscriptionInquiryForUser(
                  //       Roles.contractor.name,
                  //       userId: (await SecureStorage.getClientId()) ?? '',

                  //       role: Roles.contractor.name,
                  //     );
                  // debugPrint("Has Subscription Inquiry For : $data");
                  // Get.to(
                  //   () => SubscriptionPlansScreen(
                  //     role: Roles.contractor.name,
                  //     isNotFromBuyerSide: false,

                  //     origin: 'buyer',
                  //   ),
                  // );
                  final data =
                      await SecureStorage.hasSubscriptionInquiryForUser(
                        Roles.contractor.name,
                        userId: (await SecureStorage.getClientId()) ?? '',
                        role: Roles.contractor.name,
                      );
                  debugPrint("Has Subscription Inquiry For : $data");
                  Get.to(
                    () => SubscriptionPlansScreen(
                      role: Roles.contractor.name,
                      isNotFromBuyerSide: true,
                      isInquirySubmitted: data,
                      origin: 'buyer',
                    ),
                  );
                }, // Unlock Owner Plans

                onFinalCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(
                      () => RegisterScreen(role: UserRole.contractor),
                    );
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => ConvertToContractorConversionScreen());
                  } else if (UserHelper.isContractor) {
                    Get.to(() => ContractorMainScreen());
                  }
                }, // Final CTA
              ),
            ),
      ),
      _ConversionItem(
        title: 'Convert to Builder',
        subtitle: 'Promote projects and acquire buyers',
        icon: Icons.apartment_outlined,
        color: const Color(0xFFEA7A3B),
        onTap:
            () =>
            // (!UserHelper.isGuest)
            //     // ? Get.to(() => SellerConversionScreen())
            Get.to(
              () => ListingIntroScreen(
                role: Roles.sellerBuilder.name,
                planTitle: "Builder Plans",
                isBulletPoint: true,
                config: ListingIntroConfig(
                  logoAsset: 'assets/images/NesticoPe_logo.png',
                  appBarBrand: 'NesticoPe',
                  badgeText: 'New Feature',

                  headline: 'Showcase Your Projects',
                  highlightWord: 'with NesticoPe',
                  subHeadline:
                      'Elevate your construction brand and reach thousands of verified property seekers with our specialized developer solutions.',
                  primaryCta: 'Register as Builder',
                  sellWithTitle: 'Developer Solutions',
                  sellWithSubtitle:
                      'Designed for large scale projects and high-volume sales management.',
                  manageTitle: 'Already have projects?',
                  manageSubtitle:
                      'Boost visibility and manage leads from one place.',
                  manageButtonText: 'Manage Projects',
                  premiumTitle: 'Featured Projects',
                  premiumActionText: 'View All',
                  stepsTitle: 'Sell with NesticoPe',
                  viewPlansTitle: 'Find the Perfect Plan for You',
                  viewPlansSubtitle:
                      'Choose from premium plans to maximize reach and brand visibility.',
                  viewPlansButtonText: 'View Plans',
                  stats: const [
                    StatItemData('Growing', 'Projects Listed'),
                    StatItemData('Massive', 'Monthly Leads'),
                    StatItemData('Trusted', 'Top Developers'),
                  ],
                  features: const [
                    FeatureItemData(
                      Icons.photo_library_outlined,
                      'Project Showcase',
                      'Feature your entire project portfolio with dedicated galleries and virtual tours.',
                    ),
                    FeatureItemData(
                      Icons.people_outlined,
                      'Bulk Lead Generation',
                      'Get high-intent corporate and individual leads specifically for your developments.',
                    ),
                    FeatureItemData(
                      Icons.verified_outlined,
                      'Developer Authority',
                      'Build brand presence with a premium verified builder profile and RERA badges.',
                    ),
                    FeatureItemData(
                      Icons.support_agent_outlined,
                      'Enterprise Support',
                      'Dedicated account managers for seamless project management and updates.',
                    ),
                  ],
                  premiumListings: const [
                    PremiumListingItem(
                      imageAsset: IMGRes.home2,
                      title: 'Skyline Apartments',
                      subtitle: 'Downtown, NYC',
                      priceText: '₹45,00,000',
                    ),
                    PremiumListingItem(
                      imageAsset: IMGRes.project_2,
                      title: 'Greenview Residency',
                      subtitle: 'Udhna, Surat',
                      priceText: '₹1,20,00,000',
                    ),
                  ],
                  steps: const [
                    HowStep(
                      'Massive Buyer Network',
                      'Instant access to over 10,000+ active property seekers.',
                    ),
                    HowStep(
                      'NesticoPe Premium Support',
                      'Get dedicated support for project promotion and strategic marketing to boost your sales.',
                    ),
                    HowStep(
                      'Advanced CRM Tools',
                      'Manage your leads, site visits, and inventory from a single dashboard.',
                    ),
                    HowStep(
                      'Brand Authority',
                      'Get a verified builder profile that builds immediate trust with investors.',
                    ),
                  ],
                  plansForm: const PlansFormConfig(
                    pillText: 'Pricing',
                    title: 'Owner Premium Plans',
                    subtitle:
                        'Get featured, sell 3x faster with priority support',
                    buttonText: 'Unlock Owner Plans',
                  ),
                  finalCallout: const FinalCalloutConfig(
                    headline: "Scale Your Construction Business Today!",
                    points: [
                      'Large Active Builders',
                      'Proven Units Sold',
                      'Constant Support',
                    ],
                    cta: 'Register Now',
                  ),
                ),
                onPrimaryCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerBuilder) {
                    Get.to(() => BuilderMainScreen());
                    // return;
                  }
                },
                onBecomeType: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(context).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerBuilder) {
                    Get.to(() => BuilderMainScreen());
                    // return;
                  }
                }, // Post Property Free
                onManageListings: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerBuilder) {
                    Get.to(() => BuilderMainScreen());
                    // return;
                  }
                }, // Manage Listings
                onUnlockPlans: () async {
                  // Get.to(
                  //   () => SubscriptionPlansScreen(
                  //     role: Roles.sellerBuilder.name,

                  //     isNotFromBuyerSide: false,
                  //     origin: 'buyer',
                  //   ),
                  // );
                  final data =
                      await SecureStorage.hasSubscriptionInquiryForUser(
                        Roles.sellerBuilder.name,
                        userId: (await SecureStorage.getClientId()) ?? '',
                        role: Roles.sellerBuilder.name,
                      );
                  debugPrint("Has Subscription Inquiry For : $data");
                  Get.to(
                    () => SubscriptionPlansScreen(
                      role: Roles.sellerBuilder.name,
                      isInquirySubmitted: data,
                      isNotFromBuyerSide: false,
                      origin: 'buyer',
                    ),
                  );
                }, // Unlock Owner Plans
                onFinalCta: () async {
                  if (UserHelper.isGuest) {
                    Navigator.of(Get.context!).pop();
                    await Get.to(() => RegisterScreen(role: UserRole.seller));
                  } else if (UserHelper.isBuyer) {
                    // Get.to(() => ManageListingsScreen());
                    Get.to(() => SellerConversionScreen());
                  } else if (UserHelper.isSellerBuilder) {
                    Get.to(() => BuilderMainScreen());
                    // return;
                  }
                }, // Final CTA
              ),
            ),
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
