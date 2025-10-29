import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/reseller/view/property_reseller.dart';
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/utils/helper_function/contact_helper.dart';
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

        // ✅ Always show default UI, even if referral data is empty
        final referralData = controller.dummyReferral.value?.data;
        if (referralData == null || referralData.isEmpty) {
          controller.isGenerated.value =
              false; // ensure "Generate Code" button shows
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: 150),
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildStatsGrid(),
            const SizedBox(height: 16),
            _buildBonusCard(),
            const SizedBox(height: 16),
            // _buildHowWork(),
            _buildHowItWorks(),
          ],
        );
      }),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: ColorRes.primary,
  //       borderRadius: BorderRadius.circular(16),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           children: [
  //             Container(
  //               padding: const EdgeInsets.all(12),
  //               decoration: BoxDecoration(
  //                 color: ColorRes.white.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: Text(
  //                 '🎁',
  //                 style: TextStyle(fontSize: AppFontSizes.displaySmall),
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     'Referral Program Overview',
  //                     style: TextStyle(
  //                       color: ColorRes.white,
  //                       fontSize: AppFontSizes.medium,
  //                       fontWeight: AppFontWeights.semiBold,
  //                     ),
  //                   ),
  //                   SizedBox(height: 4),
  //                   Text(
  //                     'Track your referrals and earn rewards',
  //                     style: TextStyle(
  //                       color: ColorRes.white.withOpacity(0.9),
  //                       fontSize: AppFontSizes.small,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           decoration: BoxDecoration(
  //             color: ColorRes.white.withOpacity(0.08),
  //             borderRadius: BorderRadius.circular(12),
  //             border: Border.all(
  //               color: ColorRes.white.withOpacity(0.3),
  //               width: 1,
  //             ),
  //           ),
  //           child: Obx(() {
  //             if (!controller.isGenerated.value) {
  //               return InkWell(
  //                 onTap:
  //                     controller.isGenerate.value
  //                         ? null
  //                         : () => controller.referralCodeGenerator(),
  //                 child: Center(
  //                   child: Text(
  //                     controller.isGenerate.value
  //                         ? "Generating..."
  //                         : 'Generate Referral Code',
  //                     style: TextStyle(
  //                       color:
  //                           controller.isGenerate.value
  //                               ? ColorRes.grey
  //                               : ColorRes.white,
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             } else {
  //               final referral = controller.dummyReferral.value?.data?.first;
  //               return Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         'ACTIVE REFERRAL CODE',
  //                         style: TextStyle(
  //                           color: ColorRes.white.withOpacity(0.8),
  //                           fontSize: 10,
  //                           fontWeight: AppFontWeights.semiBold,
  //                           letterSpacing: 0.5,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 6),
  //                       Text(
  //                         referral?.referralCode ?? '',
  //                         style: const TextStyle(
  //                           color: ColorRes.white,
  //                           fontSize: AppFontSizes.large,
  //                           fontWeight: AppFontWeights.extraBold,
  //                           letterSpacing: 1.5,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const Spacer(),
  //                   // InkWell(
  //                   //   onTap: () {
  //                   //     ContactHelper.shareFeature(
  //                   //       referral?.referralLink ?? '',
  //                   //       'Share Referral Link',
  //                   //     );
  //                   //   },
  //                   //   child: _buildHeaderIcon(Icons.share),
  //                   // ),
  //                   // const SizedBox(width: 10),
  //                   InkWell(
  //                     onTap: () {
  //                       FlutterClipboard.copy(
  //                         referral?.referralCode ?? '',
  //                       ).then((_) {
  //                         Get.snackbar(
  //                           'Copied!',
  //                           'Referral code copied to clipboard',
  //                           snackPosition: SnackPosition.BOTTOM,
  //                           backgroundColor: Colors.black87,
  //                           colorText: Colors.white,
  //                         );
  //                       });
  //                     },
  //                     child: _buildHeaderIcon(Icons.copy),
  //                   ),
  //                 ],
  //               );
  //             }
  //           }),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildHeaderIcon(IconData icon) => Container(
  //   padding: const EdgeInsets.all(8),
  //   decoration: BoxDecoration(
  //     color: ColorRes.white.withOpacity(0.2),
  //     borderRadius: BorderRadius.circular(8),
  //   ),
  //   child: Icon(icon, color: ColorRes.white, size: 20),
  // );

  Widget _buildHeader() {
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
                final referral = controller.dummyReferral.value?.data?.first;
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
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            FlutterClipboard.copy(
                              referral?.referralCode ?? '',
                            ).then((_) {
                              Get.snackbar(
                                'Copied!',
                                'Referral code copied to clipboard',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black87,
                                colorText: Colors.white,
                              );
                            });
                          },
                          child: _buildHeaderIcon(Icons.copy),
                        ),
                      ],
                    ),
                  ],
                );
              }
            }),
          ),
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

  Widget _buildStatsGrid() {
    final referralList = controller.dummyReferral.value?.data;
    final referral =
        (referralList != null && referralList.isNotEmpty)
            ? referralList.first
            : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: buildMetricCard(
                  'Referral Code',
                  referral?.referralCode ?? '-',
                  Icons.card_giftcard,
                  ColorRes.purpleColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildMetricCard(
                  'Earn Per Referral',
                  '${referral?.referrerReward ?? 0} coins',
                  Icons.account_balance_wallet,
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
                  'Referred',
                  '${referral?.totalReferrals ?? 0}',
                  Icons.people,
                  ColorRes.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: buildMetricCard(
                  'Points Earned',
                  '${referral?.totalRewards ?? 0}',
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF3E5F5), Color(0xFFE8EAF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFF9B59B6).withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorRes.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '🚀',
              style: TextStyle(fontSize: AppFontSizes.displaySmall),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Obx(
              () => RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: ColorRes.blackShade87,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(text: 'Refer '),
                    TextSpan(
                      text:
                          '${controller.requiredResellers.value} more active resellers',
                      style: TextStyle(
                        fontWeight: AppFontWeights.extraBold,
                        color: Color(0xFF9B59B6),
                      ),
                    ),
                    const TextSpan(text: 'to unlock your next '),
                    const TextSpan(
                      text: 'BONUS REWARD!',
                      style: TextStyle(
                        fontWeight: AppFontWeights.extraBold,
                        color: Color(0xFF9B59B6),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHowWork() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     padding: const EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: ColorRes.white,
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: const [
  //         _StepHeader(),
  //         SizedBox(height: 24),
  //         _Step(
  //           number: '1',
  //           title: 'Share Your Code',
  //           description: 'Share your unique referral code or link with others.',
  //         ),
  //         SizedBox(height: 16),
  //         _Step(
  //           number: '2',
  //           title: 'They Register',
  //           description:
  //               'When they register using your code, they become your referral.',
  //         ),
  //         SizedBox(height: 16),
  //         _Step(
  //           number: '3',
  //           title: 'Earn Rewards',
  //           description:
  //               'You earn rewards when your referrals complete their activities.',
  //           isLast: true,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: ColorRes.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.lightbulb_outline,
            color: ColorRes.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'How it Works',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ColorRes.primary,
          ),
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  final String number, title, description;
  final bool isLast;

  const _Step({
    required this.number,
    required this.title,
    required this.description,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [ColorRes.primary, ColorRes.primary.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                number,
                style: const TextStyle(
                  color: ColorRes.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (!isLast)
              Container(
                height: 40,
                width: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [ColorRes.primary, ColorRes.primary],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorRes.primary, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
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
              // ↓ removed extra vertical space
              margin: EdgeInsets.zero,
            ),
        ],
      ),
      SizedBox(width: 16),
      Expanded(
        child: Container(
          // ↓ removed bottom padding space between steps
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

Widget _buildConnector() {
  return Container(
    margin: const EdgeInsets.only(left: 28, top: 8, bottom: 8),
    height: 30,
    width: 2,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          ColorRes.primary.withOpacity(0.3),
          ColorRes.primary.withOpacity(0.1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}
