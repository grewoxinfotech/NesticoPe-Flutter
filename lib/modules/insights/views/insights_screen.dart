import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/img_res.dart';

import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../home/views/home_screen.dart';
import '../../property_rating/view/top_rated_property.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title: Text(
          "Insights in Mumbai",
          style: TextStyle(fontSize: AppFontSizes.bodyMedium, fontWeight: AppFontWeights.medium),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Personalized Insights Just for you",
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.blackShade87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Discover homes faster with tailored insights based on your prefrences",
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.regular,
                    color: ColorRes.blackShade54,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Top Localities",
                  style: TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.blackShade87,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Rediscover past areas and explore new ones tailored to you",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.blackShade54,
                    fontWeight:AppFontWeights.regular,
                  ),
                ),
              ),
              SizedBox(height: 12),
              InsightProperty(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Projects",
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.blackShade87,
                      ),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      child: Text(
                        "See all",
                        style: TextStyle(color: ColorRes.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Discover top-rated projects tailored to you interest",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.regular,
                    color: ColorRes.blackShade54,
                  ),
                ),
              ),
              SizedBox(height: 12),
              RatedProperty(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Rated Projects",
                      style: TextStyle(
                        fontSize: AppFontSizes.bodySmall,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.blackShade87,
                      ),
                    ),
                    SizedBox(height: 12),
                    GestureDetector(
                      child: Text(
                        "See all",
                        style: TextStyle(color: ColorRes.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  "Discover top-rated projects tailored to you interest",
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    fontWeight: AppFontWeights.regular,
                    color: ColorRes.blackShade54,
                  ),
                ),
              ),
              SizedBox(height: 12),
              PropertyListDemo(),
            ],
          ),
        ),
      ),
    );
  }
}

class InsightProperty extends StatelessWidget {
  InsightProperty({super.key});

  // Dummy data
  final List<Map<String, dynamic>> dummyProperties = [
    {
      "title": "Luxury Villa",
      "address": "Beverly Hills, LA",
      "totalViews": 1240,
      "price": "\$2,500,000",
      "image":
          "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg",
    },
    {
      "title": "Modern Apartment",
      "address": "Downtown, New York",
      "totalViews": 890,
      "price": "\$850,000",
      "image":
          "https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg",
    },
    {
      "title": "Beach House",
      "address": "Miami Beach, Florida",
      "totalViews": 1430,
      "price": "\$1,750,000",
      "image":
          "https://images.pexels.com/photos/261146/pexels-photo-261146.jpeg",
    },
    {
      "title": "Mountain Cabin",
      "address": "Aspen, Colorado",
      "totalViews": 560,
      "price": "\$650,000",
      "image":
          "https://images.pexels.com/photos/460695/pexels-photo-460695.jpeg",
    },
    {
      "title": "Penthouse Suite",
      "address": "Dubai Marina",
      "totalViews": 2100,
      "price": "\$4,200,000",
      "image":
          "https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dummyProperties.length,
        padding: const EdgeInsets.only(left: 10),
        itemBuilder: (context, index) {
          final property = dummyProperties[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PropertyHorizontalCard(
              imageHeight: double.infinity,
              titleFontWeight: AppFontWeights.semiBold,
              buttonText: 'View More',
              locationFontSize: AppFontSizes.caption,
              maxLineTitle: 1,
              buttonFontWeight: AppFontWeights.semiBold,
              buttonFontSize: AppFontSizes.extraSmall,
              buttonTextColor: ColorRes.primary,
              borderColor: ColorRes.grey,
              maxLine: 1,
              title: property["title"],
              imagePath: property["image"],
              location: 'Location : ${property["address"]}',
              rating: (property["totalViews"] as int).toDouble(),
              price: property["price"],
              priceFontSize: AppFontSizes.caption,
              priceFontWeight: AppFontWeights.semiBold,
              ratingColor: ColorRes.primary,
              accentColor: ColorRes.primary,
              onTap: () {
                // Get.to(() => RatingDetail(property: property));
              },
            ),
          );
        },
      ),
    );
  }
}

class RatedProperty extends StatelessWidget {
  RatedProperty({super.key});

  // Dummy data
  final List<Map<String, dynamic>> ratedProperties = [
    {
      "title": "Luxury Villa",
      "address": "Beverly Hills, LA",
      "totalViews": 1240,
      "price": "\$2,500,000",
      "image":
          "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg",
    },
    {
      "title": "Modern Apartment",
      "address": "Downtown, New York",
      "totalViews": 890,
      "price": "\$850,000",
      "image":
          "https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg",
    },
    {
      "title": "Beach House",
      "address": "Miami Beach, Florida",
      "totalViews": 1430,
      "price": "\$1,750,000",
      "image":
          "https://images.pexels.com/photos/261146/pexels-photo-261146.jpeg",
    },
    {
      "title": "Mountain Cabin",
      "address": "Aspen, Colorado",
      "totalViews": 560,
      "price": "\$650,000",
      "image":
          "https://images.pexels.com/photos/460695/pexels-photo-460695.jpeg",
    },
    {
      "title": "Penthouse Suite",
      "address": "Dubai Marina",
      "totalViews": 2100,
      "price": "\$4,200,000",
      "image":
          "https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: ratedProperties.length,
        padding: const EdgeInsets.only(left: 10),
        itemBuilder: (context, index) {
          final property = ratedProperties[index];
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PropertyHorizontalCard(
              imageHeight: double.infinity,
              titleFontWeight: AppFontWeights.semiBold,
              buttonText: 'View More',
              locationFontSize: AppFontSizes.caption,
              maxLineTitle: 1,
              buttonFontWeight: AppFontWeights.semiBold,
              buttonFontSize: AppFontSizes.extraSmall,
              buttonTextColor: ColorRes.primary,
              borderColor: ColorRes.grey,
              maxLine: 1,
              title: property["title"],
              imagePath: property["image"],
              location: 'Location : ${property["address"]}',
              rating: (property["totalViews"] as int).toDouble(),
              price: property["price"],
              priceFontSize: AppFontSizes.caption,
              priceFontWeight: AppFontWeights.semiBold,
              ratingColor: ColorRes.primary,
              accentColor: ColorRes.primary,
              onTap: () {
                // Get.to(() => RatingDetail(property: property));
              },
            ),
          );
        },
      ),
    );
  }
}

// class RatedPropertyCard extends StatelessWidget {
//   final String name;
//   final String address;
//   final String price;
//   final String imagePath;
//
//   const RatedPropertyCard({
//     super.key,
//     required this.name,
//     required this.address,
//     required this.price,
//     required this.imagePath,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 350,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[200]!),
//         // color: ColorRes.white,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min, // ✅ prevent vertical overflow
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   IMGRes.home1,
//                   height: 80,
//                   width: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 // ✅ prevents horizontal overflow
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis, // ✅ avoids overflow
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       address,
//                       style: const TextStyle(
//                         fontSize: 11,
//                         color: Colors.black54,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis, // ✅ wraps address
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           child: Text(
//                             price,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//
//                         Row(
//                           children: [
//                             Icon(Icons.star, color: ColorRes.primary, size: 12),
//                             SizedBox(width: 4),
//                             const Text(
//                               "4.5 Ratings",
//                               style: TextStyle(
//                                 fontWeight: AppFontWeights.medium,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//
//                     SizedBox(height: 8),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {},
//                         child: Text("View Property"),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: ColorRes.primary.withOpacity(0.1),
//                           foregroundColor: ColorRes.primary,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

class AnimatedImageCarousel extends StatefulWidget {
  const AnimatedImageCarousel({super.key});

  @override
  State<AnimatedImageCarousel> createState() => _AnimatedImageCarouselState();
}

class _AnimatedImageCarouselState extends State<AnimatedImageCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.7);
  int _currentPage = 0;

  final List<String> images = [
    IMGRes.home4,
    IMGRes.home3,
    IMGRes.home1,
    IMGRes.home2,
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        controller: _pageController,
        itemCount: images.length,
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
        itemBuilder: (context, index) {
          final isActive = index == _currentPage;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isActive ? 1.0 : 0.5,
              child: AnimatedScale(
                scale: isActive ? 1.0 : 0.85,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.leadGreyColor[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          SizedBox(
            height: 130,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        IMGRes.home4,
                        height: 130,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 8), // spacing between images
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        IMGRes.home3,
                        height: 130,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Location
                Text(
                  property.name,
                  style: const TextStyle(
                    fontSize: AppFontSizes.bodySmall,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.blackShade87,
                  ),
                ),
                Text(
                  property.location,
                  style: TextStyle(fontSize: AppFontSizes.caption, color: ColorRes.leadGreyColor.shade600),
                ),
                // Rating
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${property.pricePerSqFt}/sq.ft.',
                      style: const TextStyle(
                        fontSize: AppFontSizes.small,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.blackShade87,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: ColorRes.primary, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          property.rating.toString(),
                          style: const TextStyle(
                            fontWeight: AppFontWeights.medium,
                            fontSize: AppFontSizes.small,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Price Trend Section
                Column(
                  children: [
                    // Price change indicator
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.trending_up_outlined,
                                color: ColorRes.white,
                                size: 12,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '${property.priceChangePercent}%',
                                style: const TextStyle(
                                  color: ColorRes.white,
                                  fontSize: AppFontSizes.extraSmall,
                                  fontWeight: AppFontWeights.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'in ${property.priceChangePeriod}',
                          style: TextStyle(
                            fontSize: AppFontSizes.extraSmall,
                            color: ColorRes.leadGreyColor.shade600,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          child: Text(
                            'View price trend',
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.primary,
                              fontWeight: AppFontWeights.medium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Price Chart
                    SizedBox(
                      height: 60,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: property.priceData,
                              isCurved: true,
                              color: ColorRes.primary,
                              barWidth: 2,
                              isStrokeCapRound: true,
                              dotData: FlDotData(show: false),
                              belowBarData: BarAreaData(
                                show: true,
                                color: ColorRes.primary.withOpacity(0.1),
                              ),
                            ),
                          ],
                          minX: 0,
                          maxX: property.priceData.length.toDouble() - 1,
                          minY:
                              property.priceData
                                  .map((e) => e.y)
                                  .reduce((a, b) => a < b ? a : b) -
                              1,
                          maxY:
                              property.priceData
                                  .map((e) => e.y)
                                  .reduce((a, b) => a > b ? a : b) +
                              1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Price per sq ft

                // View Property Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorRes.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'View Property',
                      style: TextStyle(
                        fontSize: AppFontSizes.extraSmall,
                        color: ColorRes.primary,
                        fontWeight: AppFontWeights.semiBold,
                      ),
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

// Custom painter for building illustration
class BuildingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = ColorRes.leadGreyColor.shade300
          ..style = PaintingStyle.fill;

    final windowPaint =
        Paint()
          ..color = ColorRes.leadGreyColor.shade500
          ..style = PaintingStyle.fill;

    // Draw building outline
    final buildingRect = Rect.fromLTWH(
      size.width * 0.3,
      size.height * 0.2,
      size.width * 0.4,
      size.height * 0.6,
    );
    canvas.drawRect(buildingRect, paint);

    // Draw windows in a grid pattern
    for (int row = 0; row < 6; row++) {
      for (int col = 0; col < 4; col++) {
        final windowRect = Rect.fromLTWH(
          buildingRect.left + (col + 0.5) * buildingRect.width / 5,
          buildingRect.top + (row + 1) * buildingRect.height / 8,
          buildingRect.width / 8,
          buildingRect.height / 12,
        );
        canvas.drawRect(windowRect, windowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Property model
class Property {
  final String name;
  final String location;
  final double rating;
  final double priceChangePercent;
  final String priceChangePeriod;
  final String pricePerSqFt;
  final List<FlSpot> priceData;

  Property({
    required this.name,
    required this.location,
    required this.rating,
    required this.priceChangePercent,
    required this.priceChangePeriod,
    required this.pricePerSqFt,
    required this.priceData,
  });
}

// Demo widget with dummy data
class PropertyListDemo extends StatelessWidget {
  const PropertyListDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Property> properties = [
      Property(
        name: 'Platinum Heights',
        location: 'By Patel Nagar, Andheri West Mumbai',
        rating: 3.7,
        priceChangePercent: 8.06,
        priceChangePeriod: '1 yrs',
        pricePerSqFt: '24,000',
        priceData: [
          const FlSpot(0, 20),
          const FlSpot(1, 19),
          const FlSpot(2, 21),
          const FlSpot(3, 20),
          const FlSpot(4, 22),
          const FlSpot(5, 24),
          const FlSpot(6, 26),
          const FlSpot(7, 25),
          const FlSpot(8, 27),
          const FlSpot(9, 28),
        ],
      ),
      Property(
        name: 'Golden Residency',
        location: 'Bandra East, Mumbai',
        rating: 4.2,
        priceChangePercent: 12.5,
        priceChangePeriod: '2 yrs',
        pricePerSqFt: '35,000',
        priceData: [
          const FlSpot(0, 28),
          const FlSpot(1, 29),
          const FlSpot(2, 31),
          const FlSpot(3, 30),
          const FlSpot(4, 32),
          const FlSpot(5, 33),
          const FlSpot(6, 35),
          const FlSpot(7, 34),
          const FlSpot(8, 36),
          const FlSpot(9, 37),
        ],
      ),
      Property(
        name: 'Silver Heights',
        location: 'Powai, Mumbai',
        rating: 4.0,
        priceChangePercent: 6.8,
        priceChangePeriod: '6 months',
        pricePerSqFt: '28,500',
        priceData: [
          const FlSpot(0, 25),
          const FlSpot(1, 26),
          const FlSpot(2, 25),
          const FlSpot(3, 27),
          const FlSpot(4, 28),
          const FlSpot(5, 27),
          const FlSpot(6, 29),
          const FlSpot(7, 28),
          const FlSpot(8, 30),
          const FlSpot(9, 31),
        ],
      ),
    ];

    return SizedBox(
      height: 370,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10),
        itemCount: properties.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 270,
            child: PropertyCard(property: properties[index]),
          );
        },
      ),
    );
  }
}
