// import 'package:clipboard/clipboard.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nesticope_app/app/constants/color_res.dart';
// import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../app/utils/helper_function/contact_helper.dart';
// import '../controller/referral_controller.dart';
//
// class ReferralProgramScreen extends StatelessWidget {
//   final ReferralController controller = Get.put(ReferralController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorRes.white,
//       appBar: AppBar(
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Get.back(result: controller.isGenerated.value);
//           },
//           icon: Icon(Icons.arrow_back),
//         ),
//         title: const Text(
//           'Referral Program',
//           style: TextStyle(
//             color: Colors.black87,
//             fontSize: AppFontSizes.large,
//             fontWeight: AppFontWeights.semiBold,
//           ),
//         ),
//         centerTitle: false,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         // ✅ Always show default UI, even if referral data is empty
//         final referralData = controller.dummyReferral.value?.data;
//         if (referralData == null || referralData.isEmpty) {
//           controller.isGenerated.value =
//               false; // ensure "Generate Code" button shows
//         }
//
//         return ListView(
//           padding: const EdgeInsets.only(bottom: 150),
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 12),
//             _buildStatsGrid(),
//             const SizedBox(height: 16),
//             _buildBonusCard(),
//             const SizedBox(height: 16),
//             // _buildHowWork(),
//             _buildHowItWorks(),
//           ],
//         );
//       }),
//     );
//   }
//
//
//   Widget _buildHeader() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.8)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(14),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.15),
//                   borderRadius: BorderRadius.circular(14),
//                 ),
//                 child: Text(
//                   '🎁',
//                   style: TextStyle(fontSize: AppFontSizes.displaySmall),
//                 ),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Referral Program',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: AppFontSizes.body,
//                         fontWeight: AppFontWeights.bold,
//                         letterSpacing: 0.3,
//                       ),
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       'Invite friends, track your progress, and earn rewards effortlessly.',
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: AppFontSizes.small,
//                         height: 1.4,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 18),
//
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.08),
//               borderRadius: BorderRadius.circular(14),
//               border: Border.all(color: Colors.white.withOpacity(0.25)),
//             ),
//             child: Obx(() {
//               if (!controller.isGenerated.value) {
//                 return GestureDetector(
//                   onTap:
//                       controller.isGenerate.value
//                           ? null
//                           : () => controller.referralCodeGenerator(),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 12,
//                       horizontal: 20,
//                     ),
//                     decoration: BoxDecoration(
//                       color:
//                           controller.isGenerate.value
//                               ? Colors.grey.withOpacity(0.3)
//                               : Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Center(
//                       child: Text(
//                         controller.isGenerate.value
//                             ? 'Generating...'
//                             : 'Generate Referral Code',
//                         style: TextStyle(
//                           color:
//                               controller.isGenerate.value
//                                   ? Colors.white70
//                                   : ColorRes.primary,
//                           fontWeight: AppFontWeights.semiBold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               } else {
//                 final referral = controller.dummyReferral.value?.data?.first;
//                 return Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Active Referral Code',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.7),
//                               fontSize: 11,
//                               letterSpacing: 0.8,
//                             ),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             referral?.referralCode ?? '',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: AppFontSizes.large,
//                               fontWeight: AppFontWeights.bold,
//                               letterSpacing: 1.5,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Row(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             FlutterClipboard.copy(referral?.referralCode ?? '');
//                           },
//                           child: _buildHeaderIcon(Icons.copy),
//                         ),
//                       ],
//                     ),
//                   ],
//                 );
//               }
//             }),
//           ),
//           SizedBox(height: 12),
//           Obx(() {
//             if (controller.isGenerated.value) {
//               final referral = controller.dummyReferral.value?.data?.first;
//               return Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 18,
//                   vertical: 14,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.08),
//                   borderRadius: BorderRadius.circular(14),
//                   border: Border.all(color: Colors.white.withOpacity(0.25)),
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             referral?.referralLink ?? '',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: AppFontSizes.small,
//                               fontWeight: AppFontWeights.regular,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Row(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             FlutterClipboard.copy(referral?.referralLink ?? '');
//                           },
//                           child: _buildHeaderIcon(Icons.copy),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return SizedBox.shrink();
//             }
//           }),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildHeaderIcon(IconData icon) => Container(
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: Colors.white.withOpacity(0.2),
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Icon(icon, color: Colors.white, size: 20),
//   );
//
//   Widget _buildStatsGrid() {
//     final referralList = controller.dummyReferral.value?.data;
//     final referral =
//         (referralList != null && referralList.isNotEmpty)
//             ? referralList.first
//             : null;
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: buildMetricCard(
//                   'Referral Code',
//                   referral?.referralCode ?? '-',
//                   Icons.card_giftcard,
//                   ColorRes.purpleColor,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: buildMetricCard(
//                   'Earn Per Referral',
//                   '${referral?.referrerReward ?? 0} coins',
//                   Icons.account_balance_wallet,
//                   ColorRes.blueColor,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: buildMetricCard(
//                   'Referred',
//                   '${referral?.totalReferrals ?? 0}',
//                   Icons.people,
//                   ColorRes.green,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: buildMetricCard(
//                   'Points Earned',
//                   '${referral?.totalRewards ?? 0}',
//                   Icons.currency_exchange,
//                   ColorRes.orangeColor,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBonusCard() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [Color(0xFFF3E5F5), Color(0xFFE8EAF6)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: Color(0xFF9B59B6).withOpacity(0.2), width: 1),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: ColorRes.white,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               '🚀',
//               style: TextStyle(fontSize: AppFontSizes.displaySmall),
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Obx(
//               () => RichText(
//                 text: TextSpan(
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: ColorRes.blackShade87,
//                     height: 1.4,
//                   ),
//                   children: [
//                     const TextSpan(text: 'Refer '),
//                     TextSpan(
//                       text:
//                           '${controller.requiredResellers.value} more active resellers',
//                       style: TextStyle(
//                         fontWeight: AppFontWeights.extraBold,
//                         color: Color(0xFF9B59B6),
//                       ),
//                     ),
//                     const TextSpan(text: 'to unlock your next '),
//                     const TextSpan(
//                       text: 'BONUS REWARD!',
//                       style: TextStyle(
//                         fontWeight: AppFontWeights.extraBold,
//                         color: Color(0xFF9B59B6),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//
// }
//
//
// Widget _buildHowItWorks() {
//   return Container(
//     margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
//     decoration: BoxDecoration(
//       color: ColorRes.leadGreyColor.shade50,
//       borderRadius: BorderRadius.circular(16),
//       border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//               decoration: BoxDecoration(
//                 color: ColorRes.primary.withOpacity(0.08),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(
//                 Icons.lightbulb_outline,
//                 color: ColorRes.primary,
//                 size: 24,
//               ),
//             ),
//             SizedBox(width: 16),
//             Text(
//               'How it works?',
//               style: TextStyle(
//                 fontSize: AppFontSizes.large,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textColor,
//               ),
//             ),
//           ],
//         ),
//         SizedBox(height: 12),
//         _buildStep(
//           'Share Your Code',
//           'Share your unique referral code with friends and family',
//           '1',
//           const Color(0xFF2196F3),
//           true,
//           false,
//         ),
//         _buildStep(
//           'They Sign Up',
//           'New users register using your referral code',
//           '2',
//           const Color(0xFF2196F3),
//           false,
//           false,
//         ),
//         _buildStep(
//           'Earn Rewards',
//           'Get instant rewards when they complete activities',
//           '3',
//           const Color(0xFF2196F3),
//           false,
//           true,
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildStep(
//   String title,
//   String subtitle,
//   String number,
//   Color color,
//   bool isFirst,
//   bool isLast,
// ) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: ColorRes.white,
//               shape: BoxShape.circle,
//               border: Border.all(color: color, width: 2.5),
//             ),
//             child: Text(
//               number,
//               style: TextStyle(fontSize: AppFontSizes.large, color: color),
//             ),
//           ),
//           if (!isLast)
//             Container(
//               width: 2,
//               height: 30,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     ColorRes.primary.withOpacity(0.6),
//                     ColorRes.primary.withOpacity(0.4),
//                   ],
//                 ),
//               ),
//               // ↓ removed extra vertical space
//               margin: EdgeInsets.zero,
//             ),
//         ],
//       ),
//       SizedBox(width: 16),
//       Expanded(
//         child: Container(
//           // ↓ removed bottom padding space between steps
//           padding: EdgeInsets.zero,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//             decoration: BoxDecoration(
//               color: ColorRes.white,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: ColorRes.leadGreyColor.shade300,
//                 width: 1,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.bodySmall,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textColor,
//                   ),
//                 ),
//                 SizedBox(height: 6),
//                 Row(
//                   children: [
//                     SizedBox(width: 4),
//                     Expanded(
//                       child: Text(
//                         subtitle,
//                         maxLines: 1,
//                         style: TextStyle(
//                           fontSize: AppFontSizes.extraSmall,
//                           color: ColorRes.leadGreyColor[600],
//                           fontWeight: AppFontWeights.medium,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ],
//   );
// }
//
// Widget _buildConnector() {
//   return Container(
//     margin: const EdgeInsets.only(left: 28, top: 8, bottom: 8),
//     height: 30,
//     width: 2,
//     decoration: BoxDecoration(
//       gradient: LinearGradient(
//         colors: [
//           ColorRes.primary.withOpacity(0.3),
//           ColorRes.primary.withOpacity(0.1),
//         ],
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//       ),
//     ),
//   );
// }

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/utils/helper_function/contact_helper.dart';
import '../../../data/network/referral/model/referrel_model.dart';
import '../controller/referral_controller.dart';

  class ReferralProgramScreen extends StatelessWidget {
  final ReferralController controller = Get.put(ReferralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        backgroundColor: ColorRes.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back(result: controller.isGenerated.value);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Referral Program',
          style: TextStyle(
            color: Colors.black87,
            fontSize: AppFontSizes.large,
            fontWeight: AppFontWeights.semiBold,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final referrals = controller.dummyReferral.value?.data?.referrals;
        final hasReferrals = referrals != null && referrals.isNotEmpty;

        // Update isGenerated based on actual referrals
        controller.isGenerated.value = hasReferrals;

        final firstReferral = hasReferrals ? referrals!.first : null;

        return ListView(
          padding: const EdgeInsets.only(bottom: 50),
          children: [
            /*jkmmdnjdik ndjnzajedfn nfjnr kdiumen cbdhb shwub dvcg sua nvj  */
            _buildHeader(firstReferral),
            const SizedBox(height: 12),
            _buildStatsGrid(controller.dummyReferral.value?.data),
            const SizedBox(height: 16),
            _buildBonusCard(),
            const SizedBox(height: 16),
            _buildHowItWorks(),
            if (hasReferrals &&
                referrals!.first.referredUsers != null &&
                referrals.first.referredUsers!.isNotEmpty) ...[
              const SizedBox(height: 16),
              UseYourPointsSection(),
              // _buildReferredSellersSection(),
            ],
          ],
        );
      }),
    );
  }

  Widget _buildHeader(Data? referral) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '🎁',
                  style: TextStyle(fontSize: AppFontSizes.displaySmall),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral Program',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Invite friends, track your progress, and earn rewards effortlessly.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: AppFontSizes.small,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Obx(() {
              if (!controller.isGenerated.value) {
                return GestureDetector(
                  onTap:
                      controller.isGenerate.value
                          ? null
                          : () => controller.referralCodeGenerator(),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color:
                          controller.isGenerate.value
                              ? Colors.grey.withOpacity(0.3)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        controller.isGenerate.value
                            ? 'Generating...'
                            : 'Generate Referral Code',
                        style: TextStyle(
                          color:
                              controller.isGenerate.value
                                  ? Colors.white70
                                  : ColorRes.primary,
                          fontWeight: AppFontWeights.semiBold,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Referral Code',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            referral?.referralCode ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.large,
                              fontWeight: AppFontWeights.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        FlutterClipboard.copy(referral?.referralCode ?? '');
                      },
                      child: _buildHeaderIcon(Icons.copy),
                    ),
                  ],
                );
              }
            }),
          ),
          SizedBox(height: 12),
          Obx(() {
            if (controller.isGenerated.value) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            referral?.referralLink ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppFontSizes.small,
                              fontWeight: AppFontWeights.regular,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        FlutterClipboard.copy(referral?.referralLink ?? '');
                      },
                      child: _buildHeaderIcon(Icons.copy),
                    ),
                  ],
                ),
              );
            } else {
              return SizedBox.shrink();
            }
          }),
          const SizedBox(height: 12),
          Obx(() {
            if (controller.isGenerated.value) {
              return Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.diamond_outlined,
                            color: ColorRes.white,
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Reward',
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '${referral?.referrerReward ?? 0} coins',
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 12,
                                  fontWeight: AppFontWeights.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            color: ColorRes.white,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                'Expires',
                                style: TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                DateFormat(
                                  'yyyy-MM-dd',
                                ).format(DateTime.parse(referral!.expiryDate!)),
                                style: const TextStyle(
                                  color: ColorRes.white,
                                  fontSize: 12,
                                  fontWeight: AppFontWeights.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Icon(icon, color: Colors.white, size: 20),
  );

  Widget _buildStatsGrid(DataWrapper? data) {
    final referrals = data?.referrals;
    final firstReferral =
        (referrals != null && referrals.isNotEmpty) ? referrals.first : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildMetricCard(
                  'Referral Codes',
                  '${referrals?.length ?? 0}',
                  Icons.card_giftcard,
                  ColorRes.purpleColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildMetricCard(
                  'Sellers Referred',
                  '${firstReferral?.totalReferrals ?? 0}',
                  Icons.person_add_alt_1,
                  ColorRes.blueColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: buildMetricCard(
                  'Available Points',
                  '${data?.points?.totalPoints ?? 0}',
                  Icons.star_border_outlined,
                  ColorRes.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildMetricCard(
                  'Points Redeemed',
                  '${firstReferral?.totalRewards ?? 0}',
                  Icons.currency_exchange,
                  ColorRes.orangeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBonusCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorRes.primary.withOpacity(0.05), // Light blue background
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_outlined, color: ColorRes.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColorRes.textColor,
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(text: 'Refer '),
                        TextSpan(
                          text:
                              '${controller.requiredResellers.value - referredUsers} more active sellers',
                          style: TextStyle(
                            fontWeight: AppFontWeights.extraBold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                        const TextSpan(text: ' to unlock '),
                        const TextSpan(
                          text: 'BONUS REWARDS!',
                          style: TextStyle(
                            fontWeight: AppFontWeights.extraBold,
                            color: Color(0xFF4A90E2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Obx(() {
            final int totalRequired = 10;
            final int referedUser = referredUsers;
            final int completed = 10 - (totalRequired - referedUser);
            final progress =
                totalRequired > 0
                    ? (completed / totalRequired).clamp(0.0, 1.0)
                    : 0.0;

            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(ColorRes.primary),
              ),
            );
          }),
        ],
      ),
    );
  }

  int get referredUsers {
    final referrals = controller.dummyReferral.value?.data?.referrals;
    if (referrals != null && referrals.isNotEmpty) {
      return referrals.first.totalReferrals ?? 0;
    }
    return 0;
  }

  Widget _buildHowItWorks() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: ColorRes.leadGreyColor.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: ColorRes.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: ColorRes.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Text(
                'How it works?',
                style: TextStyle(
                  fontSize: AppFontSizes.large,
                  fontWeight: AppFontWeights.semiBold,
                  color: ColorRes.textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildStep(
            'Share Your Code',
            'Share your unique referral code with friends and family',
            '1',
            const Color(0xFF2196F3),
            true,
            false,
          ),
          _buildStep(
            'They Sign Up',
            'New users register using your referral code',
            '2',
            const Color(0xFF2196F3),
            false,
            false,
          ),
          _buildStep(
            'Earn Rewards',
            'Get instant rewards when they complete activities',
            '3',
            const Color(0xFF2196F3),
            false,
            true,
          ),
        ],
      ),
    );
  }

  Widget _buildReferredSellersSection() {
    final referrals = controller.dummyReferral.value?.data?.referrals;
    if (referrals == null || referrals.isEmpty) {
      return SizedBox.shrink();
    }

    // Flatten all referred users from all referral codes
    final referredUsers =
        referrals.expand((r) => r.referredUsers ?? []).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Referred Sellers',
            style: TextStyle(
              fontSize: AppFontSizes.large,
              fontWeight: AppFontWeights.semiBold,
              color: ColorRes.textColor,
            ),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: referredUsers.length,
            itemBuilder: (context, index) {
              final user = referredUsers[index];
              final referral = referrals.firstWhere(
                (r) => r.referredUsers?.contains(user) ?? false,
                orElse: () => referrals.first,
              );

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ColorRes.leadGreyColor.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: ColorRes.leadGreyColor.shade300,
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade400,
                      child: Text(
                        user.username != null && user.username!.isNotEmpty
                            ? user.username![0].toUpperCase()
                            : 'S',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.username ?? '-',
                            style: TextStyle(
                              fontWeight: AppFontWeights.bold,
                              fontSize: AppFontSizes.bodySmall,
                            ),
                          ),
                          Text(
                            user.email ?? '-',
                            style: TextStyle(
                              color: ColorRes.leadGreyColor.shade600,
                              fontSize: AppFontSizes.extraSmall,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              _buildInfoCard(
                                '${referral?.referrerReward ?? 0} Points',
                                Icons.diamond_outlined,
                              ),
                              const SizedBox(width: 8),
                              _buildInfoCard(
                                referral?.referralCode ?? '-',
                                Icons.confirmation_num_outlined,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.registeredAt != null
                                    ? '${DateTime.parse(user.registeredAt!).day.toString().padLeft(2, '0')} '
                                        '${_monthString(DateTime.parse(user.registeredAt!).month)} '
                                        '${DateTime.parse(user.registeredAt!).year}'
                                    : '-',
                                style: TextStyle(
                                  fontSize: AppFontSizes.extraSmall,
                                  color: ColorRes.leadGreyColor.shade600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (user.userId != null &&
                                  user.userId!.isNotEmpty)
                                Text(
                                  'ID: ${user.userId.toString().substring(0, 8) ?? '-'}',
                                  style: TextStyle(
                                    fontSize: AppFontSizes.extraSmall,
                                    color: ColorRes.leadGreyColor.shade600,
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
        ],
      ),
    );
  }

  Widget _buildInfoCard(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: ColorRes.leadGreyColor.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: ColorRes.textColor),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: AppFontSizes.extraSmall)),
        ],
      ),
    );
  }

  // Helper to convert month number to string
  String _monthString(int month) {
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
    return months[month - 1];
  }

  Widget _buildStep(
    String title,
    String subtitle,
    String number,
    Color color,
    bool isFirst,
    bool isLast,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: ColorRes.white,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2.5),
              ),
              child: Text(
                number,
                style: TextStyle(fontSize: AppFontSizes.large, color: color),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      ColorRes.primary.withOpacity(0.6),
                      ColorRes.primary.withOpacity(0.4),
                    ],
                  ),
                ),
                margin: EdgeInsets.zero,
              ),
          ],
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: EdgeInsets.zero,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: ColorRes.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ColorRes.leadGreyColor.shade300,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppFontSizes.bodySmall,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.leadGreyColor[600],
                            fontWeight: AppFontWeights.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UseYourPointsSection extends StatelessWidget {
  const UseYourPointsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          // Star icon
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     color: Colors.amber.shade100,
          //     shape: BoxShape.circle,
          //   ),
          //   child: Icon(Icons.star, color: Colors.amber.shade600, size: 32),
          // ),
          // const SizedBox(height: 16),

          // How to Redeem Points section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ColorRes.leadGreyColor.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ColorRes.leadGreyColor.shade200,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How to Redeem Points',
                  style: TextStyle(
                    fontSize: AppFontSizes.bodyMedium,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.textColor,
                  ),
                ),
                const SizedBox(height: 16),

                // Point 1
                _buildRedemptionStep(
                  'Points are automatically applied when you create a contractor quotation',
                ),
                const SizedBox(height: 12),

                // Point 2
                _buildRedemptionStep(
                  'Your points are redeemed only when the quotation is accepted by the contractor',
                ),
                const SizedBox(height: 12),

                // Point 3
                _buildRedemptionStep(
                  'You save on service costs while contractors receive full commission',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedemptionStep(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: Icon(Icons.check, color: Colors.green.shade600, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppFontSizes.extraSmall,
              color: ColorRes.leadGreyColor.shade700,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
