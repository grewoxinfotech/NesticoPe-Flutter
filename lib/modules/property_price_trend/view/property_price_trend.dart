

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';

import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/modules/home/views/home_screen.dart';
import 'package:housing_flutter_app/modules/home/widgets/home_header.dart';
import 'package:housing_flutter_app/modules/property/controllers/property_controller.dart';
import 'package:housing_flutter_app/modules/property/views/property_detail_screen.dart';
import 'package:housing_flutter_app/modules/property_price_trend/controller/price_trend_controller.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/widget/filter_type.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/widget/line_chart.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/widget/price_property_card.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

enum FilterType { Locality, Projects }

class PriceDetails extends StatefulWidget {
  const PriceDetails({super.key});

  @override
  State<PriceDetails> createState() => _PriceDetailsState();
}

class _PriceDetailsState extends State<PriceDetails> {
  final PriceTrendController controller = Get.put(PriceTrendController());
  final PropertyController propertyController = Get.put(PropertyController());

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> priceTrend = [
      {"year": 2018, "price": 18000},
      {"year": 2019, "price": 20000},
      {"year": 2020, "price": 22000},
      {"year": 2021, "price": 17000},
      {"year": 2023, "price": 16000},
      {"year": 2024, "price": 19000},
    ];
    final List<FlSpot> spots =
        priceTrend
            .asMap()
            .entries
            .map(
              (entry) => FlSpot(
                entry.key.toDouble(),
                (entry.value['price'] as num).toDouble(),
              ),
            )
            .toList();
    final List<String> years =
        priceTrend.map((e) => e['year'].toString()).toList();

    double minY = spots.map((e) => e.y).reduce((a, b) => a < b ? a : b);
    double maxY = spots.map((e) => e.y).reduce((a, b) => a > b ? a : b);
    minY = (minY ~/ 1000) * 1000 - 1000;
    maxY = ((maxY / 1000).ceil() * 1000) + 1000;
    minY -= 1000;
    maxY += 1000;
    double range = maxY - minY;
    double interval = (range / 5).roundToDouble();
    if (interval == 0) interval = 1;

    return Obx(
      () => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarDividerColor: ColorRes.transparentColor,
          systemNavigationBarColor: Theme.of(context).secondaryHeaderColor,
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor:ColorRes.transparentColor,
        ),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(() {
                    if (propertyController.items.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return BlurredHeader(
                      imagePath:
                          propertyController
                              .items
                              .first
                              .propertyMedia
                              ?.images
                              ?.first ??
                          '',
                      height: 200,
                      onBack: () => Navigator.pop(context),
                    );
                  }),

                  // const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: ColorRes.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  context: context,
                                  builder: (context) => buildFilter(context),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 12.0,
                                ),
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: const Icon(
                                  Icons.filter_list_rounded,
                                  color: ColorRes.white,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(
                                    controller.filterList.length,
                                    (index) => Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 3.0,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 6.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          20.0,
                                        ),
                                        color: ColorRes.white,
                                        border: Border.all(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: buildCommonText(
                                        controller.filterList[index],
                                        12,
                                        FontWeight.w500,
                                        Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color ??
                                            Colors.black,
                                        1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 65.0,
                                width: 70.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: ColorRes.primary,
                                    width: 2,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      propertyController
                                              .items
                                              .first
                                              .propertyMedia
                                              ?.images
                                              ?.first ??
                                          '',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                              const SizedBox(width: 8),
                              SizedBox(
                                height: 65,
                                child: VerticalDivider(
                                  color: Colors.grey.shade300.withOpacity(0.8),
                                  indent: 6,
                                  endIndent: 6,
                                  thickness: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildCommonText(
                                      '${propertyController.items[0].title}',
                                      AppFontSizes.bodySmall,
                                      FontWeight.w600,
                                      ColorRes.textPrimary,
                                      1,
                                    ),
                                    const SizedBox(height: 4),
                                    buildCommonText(
                                      'Location : ${propertyController.items[0].address ?? "City"}',
                                      AppFontSizes.extraSmall,
                                      FontWeight.w500,
                                      ColorRes.grey,
                                      1,
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: ColorRes.primary,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 2),
                                        buildCommonText(
                                          ' ${propertyList[0]['rating']} ',
                                          10,
                                          FontWeight.bold,
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          1,
                                        ),
                                        const SizedBox(width: 4),
                                        buildCommonText(
                                          'Rating',
                                          AppFontSizes.extraSmall,
                                          FontWeight.w500,
                                          Colors.grey,
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

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 5.0,
                                runSpacing: 5.0,
                                children:
                                    stats
                                        .map(
                                          (stat) => StatCard(
                                            title: stat["title"] as String,
                                            value: stat["value"] as String,
                                            subText: stat["subText"] as String?,
                                            icon: stat["icon"] as IconData?,
                                            iconColor:
                                                stat["iconColor"] as Color?,
                                          ),
                                        )
                                        .toList(),
                              ),
                              const SizedBox(height: 16),
                              buildPriceTrendingChart(
                                spots,
                                minY,
                                maxY,
                                years,
                                interval,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: buildButton(
                                      context: context,
                                      title: 'View price trends',
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: buildButton(
                                      context: context,
                                      title: 'View properties',
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildHeading(
                                context,
                                'Similar result of trending ',
                              ),
                              buildCommonText(
                                'See all',
                                12,
                                FontWeight.w500,
                                Theme.of(context).colorScheme.secondary,
                                1,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        Obx(() {
                          if (propertyController.items.isEmpty) {
                            return const Center(
                              child: Text("No properties found"),
                            );
                          }
                          return Column(
                            children: List.generate(
                              propertyController.items.length,
                              (index) {
                                final property =
                                    propertyController.items[index];
                                final percentage =
                                    index < propertyPercentage.length
                                        ? double.tryParse(
                                              propertyPercentage[index],
                                            ) ??
                                            0.0
                                        : 0.0;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: PricePropertyCard(
                                    title: property.title ?? '',
                                    address: property.address ?? "City",
                                    imagePath:
                                        property
                                                    .propertyMedia
                                                    ?.images
                                                    ?.isNotEmpty ==
                                                true
                                            ? property
                                                .propertyMedia!
                                                .images!
                                                .first
                                            : 'assets/logo/Avant.jpg',
                                    percentageIncrease: percentage,
                                    onTap:
                                        () => print(
                                          "Tapped on ${property.title}",
                                        ),
                                  ),
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
        ),
      ),
    );
  }
}

Text buildHeading(BuildContext context, String title) {
  return buildCommonText(
    title,
    AppFontSizes.small,
    FontWeight.w600,
    ColorRes.textColor,
    1,
  );
}

Widget buildButton({required BuildContext context, required String title}) {
  return GestureDetector(
    onTap: () {},
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 8.0),
      alignment: Alignment.center,
      child: buildCommonText(
        title,
        12,
        FontWeight.w600,
        Theme.of(context).colorScheme.secondary,
        1,
      ),
    ),
  );
}

class BlurredHeader extends StatelessWidget {
  final String imagePath;
  final double height;
  final Widget? child; // for dynamic overlay widgets (textfield, buttons, etc.)
  final bool showBackButton;

  final VoidCallback? onBack;
  final Color overlayColor;
  final double blurSigma;

  const BlurredHeader({
    super.key,
    required this.imagePath,
    this.height = 150,
    this.child,
    this.showBackButton = true,
    this.onBack,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 0.3),
    this.blurSigma = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: ColorRes.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// ✅ Background Image (handle both asset & network gracefully)
          if (imagePath.startsWith('http'))
            Image.network(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(color: Colors.grey.shade200),
            )
          else
            Image.asset(imagePath, fit: BoxFit.cover),

          /// ✅ Blur overlay
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: overlayColor),
          ),

          /// ✅ Back button
          if (showBackButton)
            Positioned(
              top: 40,
              left: 10,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey.shade300,
                ),
                alignment: Alignment.center,
                child: IconButton(
                  onPressed: onBack ?? () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),
          if (child != null)
            Positioned.fill(child: child!)
          else
            Positioned(
              top: 110,
              left: 10,
              right: 10, // 👈 added so TextField has width
              child: Row(
                children: [
                  Expanded(
                    child: buildPositionedTextField(context, () {
                      Get.to(() => const CommonSearchField());
                    }),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      print("Mic tapped");
                      Get.to(() => const CommonSearchField());
                    },
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 15,
                      ),
                      decoration: BoxDecoration(
                        color: ColorRes.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: ColorRes.grey.withOpacity(0.2),
                        ),
                      ),
                      child: const Icon(
                        Icons.category_outlined,
                        color: ColorRes.primary,
                        size: 24,
                      ),
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
