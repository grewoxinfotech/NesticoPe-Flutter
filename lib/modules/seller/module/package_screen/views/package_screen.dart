import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/enum.dart';

import '../../../../subscription/views/suscription_plan_screen.dart';

class SellerSubscriptionPlanScreen extends StatelessWidget {
  const SellerSubscriptionPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubscriptionPlansScreen(
      role: Roles.sellerOwner.name,
      isShowCurrentPlan: true,
      isNotFromBuyerSide: true,
      showArrow: false,
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/app/constants/ic_res.dart';
// import 'package:nesticope_app/widgets/display/ic.dart';
//
// import '../../../../../app/constants/app_font_sizes.dart';
//
// final List<SubscriptionPlan> plans = [
//   SubscriptionPlan(
//     id: 'basic',
//     name: 'Basic',
//     price: '₹3325',
//     originalPrice: '₹4500',
//     duration: 'per month',
//     color: ColorRes.leadGreyColor,
//     isPopular: false,
//     features: [
//       PlanFeature('List up to 5 properties', true),
//       PlanFeature('Basic property search', true),
//       PlanFeature('Standard support', true),
//       PlanFeature('Property photos (up to 10)', true),
//       PlanFeature('Advanced analytics', false),
//       PlanFeature('Priority listing', false),
//       PlanFeature('Featured properties', false),
//     ],
//   ),
//   SubscriptionPlan(
//     id: 'premium_plus',
//     name: 'Premium',
//     price: '₹7725',
//     originalPrice: '₹10500',
//     duration: 'per month',
//     color: const Color(0xFF7C3AED),
//     isPopular: true,
//     features: [
//       PlanFeature('List unlimited properties', true),
//       PlanFeature('Advanced property search', true),
//       PlanFeature('Priority support', true),
//       PlanFeature('Unlimited property photos', true),
//       PlanFeature('Advanced analytics', true),
//       PlanFeature('Priority listing', true),
//       PlanFeature('Featured properties', true),
//       PlanFeature('Lead management', true),
//       PlanFeature('Custom branding', true),
//     ],
//   ),
//   SubscriptionPlan(
//     id: 'assist',
//     name: 'Assist',
//     price: '₹10450',
//     originalPrice: '₹14200',
//     duration: 'per month',
//     color: const Color(0xFF10B981),
//     isPopular: false,
//     features: [
//       PlanFeature('Everything in Premium+', true),
//       PlanFeature('Dedicated account manager', true),
//       PlanFeature('Professional photography', true),
//       PlanFeature('Marketing support', true),
//       PlanFeature('Property consultation', true),
//       PlanFeature('Custom website integration', true),
//       PlanFeature('API access', true),
//     ],
//   ),
//   SubscriptionPlan(
//     id: 'super_assist',
//     name: 'Super Assist',
//     price: '₹14725',
//     originalPrice: '₹19900',
//     duration: 'per month',
//     color: const Color(0xFFF59E0B),
//     isPopular: false,
//     features: [
//       PlanFeature('Everything in Assist', true),
//       PlanFeature('White-label solution', true),
//       PlanFeature('Custom mobile app', true),
//       PlanFeature('Advanced integrations', true),
//       PlanFeature('Dedicated server resources', true),
//       PlanFeature('24/7 premium support', true),
//       PlanFeature('Custom reporting', true),
//       PlanFeature('Multi-location management', true),
//     ],
//   ),
// ];
//
// class SubscriptionPlansScreen extends StatefulWidget {
//   const SubscriptionPlansScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SubscriptionPlansScreen> createState() =>
//       _SubscriptionPlansScreenState();
// }
//
// class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
//   int selectedPlanIndex = 1; // Premium+ is selected by default
//
//   // Dynamic plan data structure
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       top: false,
//       child: Scaffold(
//         backgroundColor: ColorRes.white,
//         appBar: AppBar(
//           // backgroundColor: ColorRes.white,
//           elevation: 0,
//           title:  Text(
//             'Choose a Package',
//             style: TextStyle(
//               color: ColorRes.black,
//               fontSize: AppFontSizes.large,
//               fontWeight: AppFontWeights.semiBold,
//             ),
//           ),
//           // centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header Section
//               _buildHeaderSection(),
//               const SizedBox(height: 24),
//
//               // Plans Grid
//               _buildPlansList(),
//               const SizedBox(height: 32),
//
//               // Features Comparison
//               _buildFeaturesComparison(),
//               const SizedBox(height: 32),
//
//               // Benefits Section
//               _buildBenefitsSection(),
//               const SizedBox(height: 16),
//
//               // FAQ Section
//               _buildFAQSection(),
//               const SizedBox(height: 32),
//
//               // Subscribe Button
//               _buildSubscribeButton(selectedPlanIndex),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildHeaderSection() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [ColorRes.builderGridLightSky, ColorRes.builderGridLightBlue],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         // color: ColorRes.primary,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//            Text(
//             'Unlock Premium Features',
//             style: TextStyle(
//               color: ColorRes.white,
//               fontSize: AppFontSizes.subtitle,
//               fontWeight: AppFontWeights.extraBold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           const Text(
//             'Boost your property business with our advanced tools and features',
//             style: TextStyle(color: ColorRes.white, fontSize: AppFontSizes.bodySmall),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: ColorRes.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child:  Text(
//               '30-day money-back guarantee',
//               style: TextStyle(
//                 color: ColorRes.white,
//                 fontSize: AppFontSizes.mini,
//                 fontWeight: AppFontWeights.medium,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPlansList() {
//     return ListView.separated(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       separatorBuilder: (context, index) => const SizedBox(height: 16),
//       itemCount: plans.length,
//       itemBuilder: (context, index) {
//         return SizedBox(
//           height: 300,
//           child: _buildPlanCard(plans[index], index),
//         );
//       },
//     );
//   }
//
//   Widget _buildPlanCard(SubscriptionPlan plan, int index) {
//     final bool isSelected = selectedPlanIndex == index;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPlanIndex = index;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? plan.color : ColorRes.leadGreyColor.withOpacity(0.2),
//             width: isSelected ? 2 : 1,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with popular badge
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         plan.name,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.large,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: plan.color,
//                         ),
//                       ),
//                       if (plan.isPopular) ...[
//                         SizedBox(width: 2),
//                         NesticoPeIc(
//                           iconPath: ICRes.geminiSvg,
//                           height: 12,
//                           width: 12,
//                         ),
//                       ],
//                       Spacer(),
//                       if (plan.isPopular) ...[
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: plan.color,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child:  Text(
//                             'POPULAR',
//                             style: TextStyle(
//                               color: ColorRes.white,
//                               fontSize: AppFontSizes.extraSmall,
//                               fontWeight: AppFontWeights.extraBold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         plan.price,
//                         style:  TextStyle(
//                           fontSize: AppFontSizes.heading,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: ColorRes.black,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       if (plan.originalPrice != null) ...[
//                         Text(
//                           plan.originalPrice!,
//                           style: TextStyle(
//                             fontSize: AppFontSizes.medium,
//                             color: ColorRes.leadGreyColor[500],
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                   Text(
//                     plan.duration,
//                     style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.leadGreyColor[600]),
//                   ),
//                 ],
//               ),
//             ),
//
//             // Features list
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children:
//                       plan.features.take(3).map((feature) {
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 8),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 feature.isIncluded
//                                     ? Icons.check_circle
//                                     : Icons.cancel,
//                                 size: 16,
//                                 color:
//                                     feature.isIncluded
//                                         ? ColorRes.success
//                                         : ColorRes.leadGreyColor,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   feature.name,
//                                   style: TextStyle(
//                                     fontSize: AppFontSizes.caption,
//                                     color:
//                                         feature.isIncluded
//                                             ? ColorRes.textPrimary
//                                             : ColorRes.leadGreyColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ),
//             ),
//
//             GestureDetector(
//               onTap: () {
//                 Get.bottomSheet(_buildPlanCard2(plan, selectedPlanIndex));
//               },
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18),
//                 child: Row(
//                   children: [
//                     Text(
//                       "Show more",
//                       style: TextStyle(
//                         color: plan.color,
//                         fontSize: AppFontSizes.small,
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                     ),
//                     Icon(
//                       Icons.keyboard_arrow_down,
//                       color: plan.color,
//                       size: 16,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // Select button
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedPlanIndex = index;
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isSelected ? plan.color : ColorRes.leadGreyColor.shade100,
//                     foregroundColor: isSelected ? ColorRes.white : ColorRes.black,
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     isSelected ? 'Selected' : 'Select Plan',
//                     style:  TextStyle(
//                       fontWeight: AppFontWeights.semiBold,
//                       fontSize: AppFontSizes.bodySmall,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPlanCard2(SubscriptionPlan plan, int index) {
//     final bool isSelected = selectedPlanIndex == index;
//
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedPlanIndex = index;
//         });
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isSelected ? plan.color : ColorRes.leadGreyColor.withOpacity(0.2),
//             width: isSelected ? 2 : 1,
//           ),
//           boxShadow: [
//             BoxShadow(
//               color:
//                   isSelected
//                       ? plan.color.withOpacity(0.2)
//                       : ColorRes.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Header with popular badge
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Text(
//                         plan.name,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.large,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: plan.color,
//                         ),
//                       ),
//                       Spacer(),
//                       if (plan.isPopular) ...[
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 8,
//                             vertical: 4,
//                           ),
//                           decoration: BoxDecoration(
//                             color: plan.color,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child:  Text(
//                             'POPULAR',
//                             style: TextStyle(
//                               color: ColorRes.white,
//                               fontSize: AppFontSizes.extraSmall,
//                               fontWeight: AppFontWeights.extraBold,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                       ],
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         plan.price,
//                         style:  TextStyle(
//                           fontSize: AppFontSizes.heading,
//                           fontWeight: AppFontWeights.extraBold,
//                           color: ColorRes.black,
//                         ),
//                       ),
//                       const SizedBox(width: 4),
//                       if (plan.originalPrice != null) ...[
//                         Text(
//                           plan.originalPrice!,
//                           style: TextStyle(
//                             color: ColorRes.leadGreyColor[500],
//                             fontSize: AppFontSizes.medium,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//
//                   Text(
//                     plan.duration,
//                     style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.leadGreyColor[600]),
//                   ),
//                 ],
//               ),
//             ),
//             // Features list
//             Expanded(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children:
//                       plan.features.map((feature) {
//                         return Padding(
//                           padding: const EdgeInsets.only(bottom: 8),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 feature.isIncluded
//                                     ? Icons.check_circle
//                                     : Icons.cancel,
//                                 size: 16,
//                                 color:
//                                     feature.isIncluded
//                                         ? ColorRes.success
//                                         : ColorRes.leadGreyColor,
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: Text(
//                                   feature.name,
//                                   style: TextStyle(
//                                     fontSize: AppFontSizes.bodySmall,
//                                     color:
//                                         feature.isIncluded
//                                             ? ColorRes.textPrimary
//                                             : ColorRes.leadGreyColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       }).toList(),
//                 ),
//               ),
//             ),
//             // Select button
//             Container(
//               padding: const EdgeInsets.all(16),
//               child: SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       selectedPlanIndex = index;
//                     });
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: isSelected ? plan.color : ColorRes.leadGreyColor.shade100,
//                     foregroundColor: isSelected ? ColorRes.white : ColorRes.black,
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: Text(
//                     isSelected ? 'Selected' : 'Select Plan',
//                     style:  TextStyle(
//                       fontWeight: AppFontWeights.semiBold,
//                       fontSize: AppFontSizes.bodySmall,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFeaturesComparison() {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: ColorRes.transparentColor,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor[300]!),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.05),
//         //     blurRadius: 8,
//         //     offset: const Offset(0, 2),
//         //   ),
//         // ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//  Text(
//             'Feature Comparison',
//             style: TextStyle(fontSize: AppFontSizes.large, fontWeight: AppFontWeights.extraBold),
//           ),
//           const SizedBox(height: 8),
//           // You can add a detailed comparison table here
//            Text(
//             'Compare all features across different plans to choose the best fit for your business needs.',
//             style: TextStyle(color: ColorRes.leadGreyColor, fontSize: AppFontSizes.bodySmall),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBenefitsSection() {
//     final benefits = [
//       BenefitItem(
//         icon: Icons.trending_up,
//         title: 'Boost Your Sales',
//         description:
//             'Increase property inquiries by up to 300% with premium listings',
//         color: ColorRes.homeGreenDarkFade,
//       ),
//       BenefitItem(
//         icon: Icons.analytics,
//         title: 'Advanced Analytics',
//         description:
//             'Track performance and optimize your listings with detailed insights',
//         color: ColorRes.builderGridLightSky,
//       ),
//       BenefitItem(
//         icon: Icons.support_agent,
//         title: 'Priority Support',
//         description: 'Get instant help from our dedicated support team',
//         color: ColorRes.purpleColor,
//       ),
//       BenefitItem(
//         icon: Icons.security,
//         title: 'Verified Listings',
//         description: 'Build trust with verified badges on all your properties',
//         color:  ColorRes.builderGridLightYellow,
//       ),
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Why Choose Premium?',
//           style: TextStyle(
//             fontSize: AppFontSizes.body,
//             fontWeight: AppFontWeights.semiBold,
//             color: ColorRes.textPrimary,
//           ),
//         ),
//         const SizedBox(height: 16),
//         ...benefits.map((benefit) => _buildBenefitItem(benefit)),
//       ],
//     );
//   }
//
//   Widget _buildBenefitItem(BenefitItem benefit) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor[200]!),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.05),
//         //     blurRadius: 8,
//         //     offset: const Offset(0, 2),
//         //   ),
//         // ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: benefit.color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(benefit.icon, color: benefit.color, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   benefit.title,
//                   style:  TextStyle(
//                     fontSize: AppFontSizes.body,
//                     fontWeight: AppFontWeights.semiBold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   benefit.description,
//                   style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.leadGreyColor[600]),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFAQSection() {
//     final faqs = [
//       FAQItem(
//         question: 'Can I change my plan anytime?',
//         answer:
//             'Yes, you can upgrade or downgrade your plan at any time. Changes will be reflected in your next billing cycle.',
//       ),
//       FAQItem(
//         question: 'Do you offer refunds?',
//         answer:
//             'We offer a 30-day money-back guarantee for all our premium plans. No questions asked.',
//       ),
//       FAQItem(
//         question: 'What payment methods do you accept?',
//         answer:
//             'We accept all major credit cards, debit cards, UPI, and net banking.',
//       ),
//     ];
//
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: ColorRes.leadGreyColor[200]!),
//         // boxShadow: [
//         //   BoxShadow(
//         //     color: Colors.black.withOpacity(0.05),
//         //     blurRadius: 8,
//         //     offset: const Offset(0, 2),
//         //   ),
//         // ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//            Text(
//             'Frequently Asked Questions',
//             style: TextStyle(fontSize: AppFontSizes.large, fontWeight: AppFontWeights.extraBold),
//           ),
//           const SizedBox(height: 16),
//           ...faqs.map((faq) => _buildFAQItem(faq)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFAQItem(FAQItem faq) {
//     return ExpansionTile(
//       title: Text(
//         faq.question,
//         style:  TextStyle(fontSize: AppFontSizes.medium, fontWeight: AppFontWeights.medium),
//       ),
//       children: [
//         Padding(
//           padding:  EdgeInsets.all(16),
//           child: Text(
//             faq.answer,
//             style: TextStyle(fontSize: AppFontSizes.small, color: ColorRes.leadGreyColor[600]),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSubscribeButton(int index) {
//     final selectedPlan = plans[index];
//
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         // gradient: LinearGradient(
//         //   colors: [selectedPlan.color, selectedPlan.color.withOpacity(0.8)],
//         //   begin: Alignment.topLeft,
//         //   end: Alignment.bottomRight,
//         // ),
//         color: ColorRes.primary,
//         borderRadius: BorderRadius.circular(16),
//       ),
//       child: Column(
//         children: [
//           Text(
//             'Subscribe to ${selectedPlan.name}',
//             style:  TextStyle(
//               color: ColorRes.white,
//               fontSize: AppFontSizes.large,
//               fontWeight: AppFontWeights.extraBold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             selectedPlan.price + ' ' + selectedPlan.duration,
//             style:  TextStyle(color: ColorRes.white, fontSize: AppFontSizes.medium),
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 _handleSubscribe(selectedPlan);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorRes.white,
//                 foregroundColor: ColorRes.primary,
//                 padding: const EdgeInsets.symmetric(vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child:  Text(
//                 'Subscribe Now',
//                 style: TextStyle(fontSize: AppFontSizes.body, fontWeight: AppFontWeights.extraBold),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _handleSubscribe(SubscriptionPlan plan) {
//     // Handle subscription logic here
//     Get.dialog(
//       Container(
//         color: ColorRes.transparentColor,
//         child: AlertDialog(
//           title: const Text('Subscription'),
//           content: Text('You selected ${plan.name} plan for ${plan.price}'),
//           backgroundColor: ColorRes.white,
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // Data Models
// class SubscriptionPlan {
//   final String id;
//   final String name;
//   final String price;
//   final String? originalPrice;
//   final String duration;
//   final Color color;
//   final bool isPopular;
//   final List<PlanFeature> features;
//
//   SubscriptionPlan({
//     required this.id,
//     required this.name,
//     required this.price,
//     this.originalPrice,
//     required this.duration,
//     required this.color,
//     required this.isPopular,
//     required this.features,
//   });
// }
//
// class PlanFeature {
//   final String name;
//   final bool isIncluded;
//
//   PlanFeature(this.name, this.isIncluded);
// }
//
// class BenefitItem {
//   final IconData icon;
//   final String title;
//   final String description;
//   final Color color;
//
//   BenefitItem({
//     required this.icon,
//     required this.title,
//     required this.description,
//     required this.color,
//   });
// }
//
// class FAQItem {
//   final String question;
//   final String answer;
//
//   FAQItem({required this.question, required this.answer});
// }
