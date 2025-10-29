import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import 'package:housing_flutter_app/modules/home/views/home_screen/home_screen.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/property_price_trend.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/widget/price_property_card.dart';
import 'package:housing_flutter_app/modules/property_rating/view/widget/feedback.dart';
import 'package:housing_flutter_app/modules/property_rating/view/widget/rating.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

class RatingDetail extends StatefulWidget {
  final Items property;
  RatingDetail({super.key, required this.property});
  final PropertyController propertyController = Get.put(PropertyController());

  @override
  State<RatingDetail> createState() => _RatingDetailState();
}

class _RatingDetailState extends State<RatingDetail> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarDividerColor: ColorRes.transparentColor,
        systemNavigationBarColor: Theme.of(context).secondaryHeaderColor,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: ColorRes.transparentColor,
      ),
      child: Scaffold(
        backgroundColor: ColorRes.white,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              BlurredHeader(
                imagePath:
                    widget.property.propertyMedia?.images?.isNotEmpty ?? false
                        ? widget.property.propertyMedia!.images![0]
                        : 'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?...',
                height: 200,
                onBack: () => Navigator.pop(context),
              ),

              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                color: ColorRes.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /// Property image
                          Container(
                            height: 65,
                            width: 70,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: ColorRes.primary,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  widget
                                              .property
                                              .propertyMedia
                                              ?.images
                                              ?.isNotEmpty ??
                                          false
                                      ? widget
                                          .property
                                          .propertyMedia!
                                          .images![0]
                                      : 'https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?cs=srgb&dl=pexels-binyaminmellish-186077.jpg&fm=jpg',
                                ),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                buildCommonText(
                                  '${widget.property.title}',
                                  AppFontSizes.bodySmall,
                                  AppFontWeights.semiBold,
                                  ColorRes.textPrimary,
                                  1,
                                ),
                                const SizedBox(height: 4),
                                buildCommonText(
                                  'Location : ${widget.property.address ?? "City"}',
                                  AppFontSizes.extraSmall,
                                  AppFontWeights.regular,
                                  ColorRes.grey.withOpacity(0.7),
                                  1,
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: ColorRes.primary,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    buildCommonText(
                                      ' ${widget.property.performanceScore} ',
                                      AppFontSizes.caption,
                                      AppFontWeights.semiBold,
                                      ColorRes.leadGreyColor,
                                      1,
                                    ),
                                    const SizedBox(width: 6),
                                    buildCommonText(
                                      '| Rating',
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

                    const SizedBox(height: 16),

                    /// Stats cards
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        spacing: 5,
                        children:
                            stats.take(2).map((stat) {
                              return Expanded(
                                child: StatCard(
                                  title: stat["title"] as String,
                                  value: stat["value"] as String,
                                  subText: stat["subText"] as String?,
                                  icon: stat["icon"] as IconData?,
                                  iconColor: stat["iconColor"] as Color?,
                                ),
                              );
                            }).toList(),
                      ),
                    ),

                    const SizedBox(height: 20),
                    ReviewHighlights(
                      goodThings:
                          propertyList[0]['good_things'] as List<String>,
                      improvements:
                          propertyList[0]['needs_improvement'] as List<String>,
                    ),
                    const SizedBox(width: 12),

                    /// Rating
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: buildHeading(context, 'Rating'),
                    ),
                    const SizedBox(height: 8),
                    RatingWidget(
                      averageRating: propertyList[0]['rating'],
                      ratingCounts: const {5: 30, 4: 15, 3: 8, 2: 4, 1: 3},
                    ),

                    const SizedBox(height: 20),

                    /// Reviews
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: buildHeading(context, 'Reviews'),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: FeedbackCard(
                          date: '20-Aug-2025',
                          rating: propertyList[index]['rating'],
                          userName: propertyList[index]['seller']['name'],
                          feedback:
                              propertyList[index]['seller']['description'],
                          profileUrl: propertyList[index]['seller']['image'],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: buildButton(
                              title: 'Read More Reviews',
                              context: context,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: buildButton(
                              title: 'View other properties',
                              context: context,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Similar trending section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildHeading(context, 'Similar result of trending '),
                          buildCommonText(
                            'See all',
                            AppFontSizes.small,
                            AppFontWeights.medium,
                            ColorRes.primary,
                            1,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// Property cards
                    // ...List.generate(widget.propertyController.items.length, (
                    //   index,
                    // ) {
                    //   final property = widget.propertyController.items[index];
                    //   print("Property: ${property.propertyDetails}");
                    //
                    //   return Padding(
                    //     padding: const EdgeInsets.only(bottom: 12),
                    //     child: PricePropertyCard(
                    //       title: property.title ?? 'Unknown Property',
                    //       address: property.address ?? "City",
                    //       imagePath:
                    //           property.propertyMedia?.images?.isNotEmpty == true
                    //               ? property.propertyMedia!.images!.first
                    //               : 'assets/logo/Avant.jpg',
                    //       rating: 4.2,
                    //       pricePerSqft:
                    //           property
                    //                       .propertyDetails
                    //                       ?.financialInfo
                    //                       ?.pricePerSqft !=
                    //                   null
                    //               ? int.tryParse(
                    //                 property
                    //                     .propertyDetails!
                    //                     .financialInfo!
                    //                     .pricePerSqft
                    //                     .toString(),
                    //               )
                    //               : null,
                    //       showPercentage: true,
                    //       onTap: () {
                    //         print(
                    //           "Tapped on ${int.tryParse(property.propertyDetails!.financialInfo!.pricePerSqft.toString())}",
                    //         );
                    //       },
                    //     ),
                    //   );
                    // }),
                    ...List.generate(widget.propertyController.items.length, (
                      index,
                    ) {
                      final property = widget.propertyController.items[index];
                      print("Property: ${property.propertyDetails}");

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PricePropertyCard(
                          title: property.title ?? 'Unknown Property',
                          address: property.address ?? "City",
                          imagePath:
                              property.propertyMedia?.images?.isNotEmpty == true
                                  ? property.propertyMedia!.images!.first
                                  : 'assets/logo/Avant.jpg',
                          rating: 4.2,
                          pricePerSqft:
                              property
                                          .propertyDetails
                                          ?.financialInfo
                                          ?.pricePerSqft !=
                                      null
                                  ? int.tryParse(
                                    property
                                        .propertyDetails!
                                        .financialInfo!
                                        .pricePerSqft
                                        .toString(),
                                  )
                                  : null,
                          showPercentage: true,
                          onTap: () {
                            print(
                              "Tapped on ${int.tryParse(property.propertyDetails!.financialInfo!.pricePerSqft.toString())}",
                            );
                          },
                        ),
                      );
                    }),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildStars(double rating, double size) {
  //   List<Widget> stars = [];
  //   int fullStars = rating.floor();
  //   bool hasHalf = (rating - fullStars) >= 0.5;

  //   for (int i = 0; i < 5; i++) {
  //     if (i < fullStars) {
  //       stars.add(Icon(Icons.star, color: ColorRes.primary, size: size));
  //     } else if (i == fullStars && hasHalf) {
  //       stars.add(Icon(Icons.star_half, color: ColorRes.primary, size: size));
  //     } else {
  //       stars.add(Icon(Icons.star_border, color: ColorRes.primary, size: size));
  //     }
  //   }
  //   return Row(children: stars);
  // }
}
