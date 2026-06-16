import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/app_font_sizes.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/verification/mou_verification/controllers/mou_controller.dart';
import 'dart:math';
// import 'level_card_motion.dart';

class ResellerCommissionModal extends StatefulWidget {
  final double clientCommission;
  final double builderCommission;

  const ResellerCommissionModal({
    Key? key,
    this.clientCommission = 3,
    this.builderCommission = 5,
  }) : super(key: key);

  @override
  State<ResellerCommissionModal> createState() =>
      _ResellerCommissionModalState();
}

class _ResellerCommissionModalState extends State<ResellerCommissionModal>
    with SingleTickerProviderStateMixin {
  bool agreed = false;
  late AnimationController _controller;
  PlatformFeeController platformFeeController = Get.put(
    PlatformFeeController(),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,

      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with subtle animation (handshake icon + floating stars + badge)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
              decoration: BoxDecoration(
                color: ColorRes.primary, // adjust to your theme primary
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  // Animated handshake icon
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      final double dy =
                          sin(_controller.value * 2 * pi) * 4; // vertical
                      final double dx =
                          cos(_controller.value * 1 * pi) *
                          1; // horizontal (slightly increased)
                      return Transform.translate(
                        offset: Offset(dx, dy),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade700,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.handshake,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  // Floating stars
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     AnimatedBuilder(
                  //       animation: _controller,
                  //       builder: (_, __) {
                  //         final double dy = sin(_controller.value * 2 * pi) * 8;
                  //         return Transform.translate(
                  //           offset: Offset(0, dy),
                  //           child: const Icon(
                  //             Icons.star,
                  //             color: Colors.amberAccent,
                  //             size: 18,
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //     const SizedBox(width: 8),
                  //     AnimatedBuilder(
                  //       animation: _controller,
                  //       builder: (_, __) {
                  //         final double dy = sin(_controller.value * 2 * pi + pi / 2) * 7;
                  //         return Transform.translate(
                  //           offset: Offset(0, dy),
                  //           child: const Icon(
                  //             Icons.star,
                  //             color: Colors.amber,
                  //             size: 16,
                  //           ),
                  //         );
                  //       },
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 12),

                  // Reuse level badge helper for a nice label

                  // const SizedBox(height: 12),
                  Text(
                    'Welcome to NesticoPe Partner\nProgram!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: FontWeight.w700,
                      color: ColorRes.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "We are thrilled to partner with you. Let's make every deal count!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.white.withOpacity(0.95),
                    ),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'Here are your configured commission payout percentages for successful deals:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppFontSizes.small,
                      color: ColorRes.textColor,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Obx(() {
                    if (platformFeeController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    return Column(
                      children: [
                        _buildCommissionCard(
                          title: 'Client Property Commission',
                          subtitle:
                              'Your earning on every direct client property deal',
                          percent:
                              getPlatformFeeForPropertyCommissionPercentage(
                                platformFeeController,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _buildCommissionCard(
                          title: 'Builder Project Commission',
                          subtitle:
                              'Your earning on facilitating project sales',
                          percent: getPlatformFeeForProjectCommissionPercentage(
                            platformFeeController,
                          ),
                        ),
                      ],
                    );
                  }),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Checkbox(
                        value: agreed,
                        onChanged: (v) => setState(() => agreed = v ?? false),
                      ),
                      Expanded(
                        child: Text(
                          'I agree to the commission policy rates',
                          style: TextStyle(
                            fontSize: AppFontSizes.small,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          agreed
                              ? () {
                                Navigator.of(context).pop(true);
                              }
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor:
                            agreed ? ColorRes.primary : Colors.grey.shade300,
                        foregroundColor: agreed ? Colors.white : Colors.white70,
                      ),
                      child: Text(
                        "Got it, Let's Earn!",
                        style: TextStyle(
                          fontSize: AppFontSizes.medium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommissionCard({
    required String title,
    required String subtitle,
    required double percent,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.textPrimary.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: AppFontSizes.bodySmall,
                    color: ColorRes.black,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: ColorRes.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${percent.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: AppFontSizes.large,
                fontWeight: FontWeight.w700,
                color: ColorRes.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to display the modal. Returns `true` when user agrees and taps the button.
Future<bool?> showResellerCommissionModal(
  BuildContext context, {
  double client = 3,
  double builder = 5,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PopScope(
      canPop: false, // Prevents back navigation
      child: ResellerCommissionModal(
        clientCommission: client,
        builderCommission: builder,
      ),
    ),
  );
}

double getPlatformFeeForPropertyCommissionPercentage(
  PlatformFeeController platformFeeController,
) {
  try {
    final fee = platformFeeController.items.firstWhere(
      (e) => e.category == 'partner_property' && e.isActive == true,
    );
    print("Platform fees ${platformFeeController.items} ");
    return double.tryParse(fee.percentage ?? '0') ?? 0;
  } catch (_) {
    return 0;
  }
}

double getPlatformFeeForProjectCommissionPercentage(
  PlatformFeeController platformFeeController,
) {
  try {
    final fee = platformFeeController.items.firstWhere(
      (e) => e.category == 'partner_project' && e.isActive == true,
    );

    return double.tryParse(fee.percentage ?? '0') ?? 0;
  } catch (_) {
    return 0;
  }
}
