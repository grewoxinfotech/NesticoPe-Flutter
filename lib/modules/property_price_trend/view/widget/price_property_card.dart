import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

class PricePropertyCard extends StatelessWidget {
  final String title;
  final String address;
  final String imagePath;
  final double? percentageIncrease; // now optional
  final double? rating; // optional rating
  final int? pricePerSqft; // optional price per sqft
  final bool showPercentage; // control visibility
  final VoidCallback? onTap;

  const PricePropertyCard({
    super.key,
    required this.title,
    required this.address,
    required this.imagePath,
    this.percentageIncrease,
    this.rating,
    this.pricePerSqft,
    this.showPercentage = true, // default true
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isPositive = (percentageIncrease ?? 0) >= 10.0;

    return GestureDetector(   
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: ColorRes.leadGreyColor.withOpacity(0.3), width: 0.8),
        ),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// Image
            Container(
              height: 60,
              width: 65,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      imagePath.isNotEmpty && imagePath.startsWith('http')
                          ? NetworkImage(imagePath)
                          : const AssetImage("assets/logo/Avant.jpg"),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),

            const SizedBox(width: 8),

            SizedBox(
              height: 60,
              child: VerticalDivider(
                color: ColorRes.leadGreyColor.withOpacity(0.3),
                indent: 5,
                endIndent: 5,
                thickness: 1.2,
              ),
            ),

            const SizedBox(width: 8),

            /// Text + Percentage + Rating/Price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCommonText(
                    title,
                    AppFontSizes.small,
                    AppFontWeights.semiBold,
                    ColorRes.textColor,
                    1,
                  ),
                  const SizedBox(height: 2),

                  /// Address
                  buildCommonText(
                    "Location: $address",
                    AppFontSizes.extraSmall,
                    AppFontWeights.regular,
                    ColorRes.grey.withOpacity(0.7),
                    1,
                  ),
                  const SizedBox(height: 6),

                  /// Percentage Change (optional)
                  if (showPercentage && percentageIncrease != null)
                    Row(
                      children: [
                        Icon(
                          isPositive
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: isPositive ? ColorRes.green : ColorRes.error,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        buildCommonText(
                          "${percentageIncrease!.toStringAsFixed(1)}%",
                          AppFontSizes.caption,
                          AppFontWeights.extraBold,
                          isPositive ? ColorRes.green : ColorRes.error,
                          1,
                        ),
                      ],
                    ),
                  if (rating != null || pricePerSqft != null)
                    Row(
                      children: [
                        if (rating != null) ...[
                          const Icon(
                            Icons.star,
                            color: ColorRes.primary,
                            size: 13,
                          ),
                          const SizedBox(width: 3),
                          buildCommonText(
                            rating!.toStringAsFixed(1),
                            AppFontSizes.extraSmall,
                            AppFontWeights.semiBold,
                            ColorRes.leadGreyColor,
                            1,
                          ),
                        ],
                        buildCommonText(
                          ' | Per sqft : ₹ ${pricePerSqft?.toStringAsFixed(0) ?? '2500'}',
                          AppFontSizes.extraSmall,
                          AppFontWeights.medium,
                          ColorRes.leadGreyColor,
                          1,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
