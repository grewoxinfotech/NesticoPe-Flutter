import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/utils/helper_function/contact_helper.dart';
import '../controller/referral_controller.dart';

class ReferralProgramScreen extends StatelessWidget {
  final ReferralController controller = Get.put(ReferralController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Referral Program',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 6),
            _buildStatsGrid(),
            SizedBox(height: 16),
            _buildBonusCard(),
            SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorRes.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('🎁', style: TextStyle(fontSize: 28)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Referral Program Overview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Track your referrals and earn rewards',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Obx(() {
              if (!controller.isGenerate.value) {
                return InkWell(
                  onTap: () {
                    controller.referralCodeGenerator(true);
                    print('Referral Code: ${controller.isGenerate.value}');
                    controller.fetchReferralService();
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Generate Referral Code',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ACTIVE REFERRAL CODE',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          controller.dummyReferral.data?[0].referralCode ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        ContactHelper.shareFeature(
                          controller.dummyReferral.data?[0].referralLink ?? '',
                          'Share Referral Link',
                          // 'Share your referral link with your friends and family to earn rewards.',
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.share, color: Colors.white, size: 20),
                      ),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        FlutterClipboard.copy(
                          controller.dummyReferral.data?[0].referralCode ?? '',
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.copy, color: Colors.white, size: 20),
                      ),
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

  Widget _buildStatsGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.card_giftcard,
                  iconColor: Color(0xFF9B59B6),
                  iconBg: Color(0xFFEDE7F6),
                  title: 'Referral Codes',
                  value: controller.dummyReferral.data?[0].referralCode ?? '0',
                  subtitle: 'Generated by you',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.account_balance_wallet,
                  iconColor: Color(0xFF0075D4),
                  iconBg: Color(0xFFE0F7FA),
                  title: 'Earn Per Referral',
                  value:
                      '${controller.dummyReferral.data?[0].referrerReward.toString() ?? '0'}',
                  subtitle:
                      '${controller.rewardsEarned.value} x rewards earned',
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  iconColor: Color(0xFF4C964D),
                  iconBg: Color(0xFFEDE7F6),
                  title: 'Resellers Referred',
                  value:
                      controller.dummyReferral.data?[0].referredUsers?.length
                          .toString() ??
                      '0',
                  subtitle:
                      '${controller.activeResellers.value} active, ${controller.pendingResellers.value} pending',
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star,
                  iconColor: Color(0xFFFF9800),
                  iconBg: Color(0xFFFFF3E0),
                  title: 'Points Earned',
                  value:
                      controller.dummyReferral.data?[0].totalRewards
                          .toString() ??
                      '0',
                  subtitle: 'From referrals',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.02),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    color: Colors.grey[600],
                    fontWeight: AppFontWeights.medium,
                    height: 1.2,
                  ),
                ),
              ),

              SizedBox(width: 10),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ColorRes.textColor,
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildBonusCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('🚀', style: TextStyle(fontSize: 28)),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Obx(
              () => RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: 'Refer '),
                    TextSpan(
                      text:
                          '${controller.requiredResellers.value} more active resellers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF9B59B6),
                      ),
                    ),
                    TextSpan(text: ' to unlock '),
                    TextSpan(
                      text: 'BONUS REWARDS!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
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
}

Widget _buildReferralCode() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.purple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.purple.withOpacity(0.08),
                  // border: Border.all(width: 1,color: Colors.purple.withOpacity(0.3))
                ),
                child: Text('🧾', style: TextStyle()),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 180,
                    child: Text(
                      'Your Referral Code',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ColorRes.textColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: Text(
                      'Share this code with other resellers to earn rewards',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
