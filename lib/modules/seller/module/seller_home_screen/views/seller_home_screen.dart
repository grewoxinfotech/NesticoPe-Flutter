import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/dashboard/views/dashboard_screen.dart';
import 'package:housing_flutter_app/modules/home/views/home_screen.dart';
import 'package:housing_flutter_app/modules/seller/module/seller_home_screen/views/property_overview_screen.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/widgets/texts/headline_text.dart';
import '../../../../profile/views/profile_screen.dart';

final List<Map<String, dynamic>> addonData = [
  {
    "title": "Extended Warranty",
    "description": "Get 2 extra years of warranty for your plan.",
    "price": 49.99,
    "isPopular": true,
  },
  {
    "title": "Priority Support",
    "description": "24/7 dedicated support for faster resolutions.",
    "price": 29.99,
  },
  {
    "title": "Cloud Backup",
    "description": "Secure cloud storage for all your data.",
    "price": 19.99,
  },
  {
    "title": "Premium Themes",
    "description": "Access exclusive themes and templates.",
    "price": 9.99,
  },
  {
    "title": "Advanced Analytics",
    "description": "Get detailed reports and insights.",
    "price": 39.99,
  },
  {
    "title": "Custom Domain",
    "description": "Use your own domain for branding.",
    "price": 14.99,
  },
  {
    "title": "Marketing Tools",
    "description": "Boost your visibility with built-in tools.",
    "price": 24.99,
  },
  {
    "title": "Team Collaboration",
    "description": "Add team members and collaborate easily.",
    "price": 34.99,
  },
  {
    "title": "Security Package",
    "description": "Extra security features for your plan.",
    "price": 19.99,
  },
  {
    "title": "VIP Access",
    "description": "Early access to new features and updates.",
    "price": 59.99,
    "isPopular": true,
  },
];

// final List<Map<String, String>> propertiesOverview = [
//   {
//     "title": "Luxury Villa",
//     "location": "Beverly Hills",
//     "price": "\$1,200,000",
//     "views": "3.2K",
//     "likes": "800",
//     "inquiries": "45",
//   },
//   {
//     "title": "Modern Apartment",
//     "location": "Downtown",
//     "price": "\$450,000",
//     "views": "2.1K",
//     "likes": "600",
//     "inquiries": "30",
//   },
//   {
//     "title": "Cozy Cottage",
//     "location": "Countryside",
//     "price": "\$320,000",
//     "views": "1.5K",
//     "likes": "300",
//     "inquiries": "15",
//   },
// ];

final List<Map<String, dynamic>> propertiesOverview = [
  {
    'id': '1',
    'title': 'Modern Luxury Villa',
    'location': 'Beverly Hills, CA',
    'price': '\$2,500,000',
    'image':
        'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400',
    'type': 'Villa',
    'bedrooms': 5,
    'bathrooms': 4,
    'area': '3,500 sq ft',
    'views': 15420,
    'likes': 892,
    'shares': 234,
    'visits': 1250,
    'totalLeads': 45,
    'status': 'Available',
    'featured': true,
  },
  {
    'id': '2',
    'title': 'Downtown Penthouse',
    'location': 'Manhattan, NY',
    'price': '\$4,200,000',
    'image': 'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=400',
    'type': 'Penthouse',
    'bedrooms': 3,
    'bathrooms': 3,
    'area': '2,800 sq ft',
    'views': 23150,
    'likes': 1456,
    'shares': 567,
    'visits': 2100,
    'totalLeads': 78,
    'status': 'Available',
    'featured': true,
  },
  {
    'id': '3',
    'title': 'Cozy Family Home',
    'location': 'Austin, TX',
    'price': '\$650,000',
    'image':
        'https://images.unsplash.com/photo-1572120360610-d971b9d7767c?w=400',
    'type': 'House',
    'bedrooms': 4,
    'bathrooms': 3,
    'area': '2,200 sq ft',
    'views': 8750,
    'likes': 421,
    'shares': 156,
    'visits': 890,
    'totalLeads': 32,
    'status': 'Available',
    'featured': false,
  },
  {
    'id': '4',
    'title': 'Beachfront Condo',
    'location': 'Miami Beach, FL',
    'price': '\$1,800,000',
    'image':
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400',
    'type': 'Condo',
    'bedrooms': 2,
    'bathrooms': 2,
    'area': '1,600 sq ft',
    'views': 19200,
    'likes': 1123,
    'shares': 445,
    'visits': 1680,
    'totalLeads': 67,
    'status': 'Sold',
    'featured': true,
  },
  {
    'id': '5',
    'title': 'Mountain Retreat',
    'location': 'Aspen, CO',
    'price': '\$3,100,000',
    'image':
        'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    'type': 'Cabin',
    'bedrooms': 6,
    'bathrooms': 5,
    'area': '4,200 sq ft',
    'views': 12890,
    'likes': 734,
    'shares': 298,
    'visits': 1020,
    'totalLeads': 38,
    'status': 'Available',
    'featured': false,
  },
];

class SellerHomeScreen extends StatelessWidget {
  const SellerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // 🔹 Background (header)
                Container(
                  width: double.infinity,
                  // color: const Color(0xff091F48),
                  color: ColorRes.primary,
                  padding: const EdgeInsets.only(
                    top: 30,
                    left: 12,
                    right: 12,
                    bottom: 80, // extra space so overlap looks smooth
                  ),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Welcome, Seller",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const Text(
                                    "Sell or rent your property faster",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () {
                                      Get.offAll(() => DashboardScreen());
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                        ),
                                      ),
                                      child: Text(
                                        "Home",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => ProfileScreen(
                                      imageUrl:
                                          "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: ColorRes.grey.withOpacity(0.2),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4866.jpg",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                // 🔹 Foreground (overlapping form card)
                Positioned(
                  top: 130,
                  // adjust overlap distance
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(28),
                        topRight: Radius.circular(28),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: SizedBox(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: TitleWithViewAll(
                                title: "Overview",
                                showViewAll: false,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: OverViewCard(),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: TitleWithViewAll(
                                title: "Choose Your Plan",
                                showViewAll: false,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: PricingWidgetDemo(),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: TitleWithViewAll(
                                title: "Add-ons to attract more buyers",
                                showViewAll: false,
                              ),
                            ),
                            const SizedBox(height: 12),
                            AddOnsForBuyer(),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: TitleWithViewAll(
                                title: "Customer Support",
                                showViewAll: false,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: const CustomerSupportCard(
                                email: "abc@support.com",
                                phone: "+1 234 567 890",
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OverViewCard extends StatelessWidget {
  const OverViewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> overviewData = const [
      {
        "title": "Views",
        "value": "12.4K",
        "icon": Icons.remove_red_eye_outlined,
      },
      {"title": "Likes", "value": "2.3K", "icon": Icons.favorite_border},
      {"title": "Shares", "value": "540", "icon": Icons.share_outlined},
      {"title": "Visits", "value": "8.9K", "icon": Icons.travel_explore},
      {"title": "Total Leads", "value": "1.1K", "icon": Icons.people_alt},
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.dashboard_customize,
                      color: Colors.blue.shade700,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Overview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => PropertyOverviewScreen(
                        properties: propertiesOverview,
                      ),
                    );
                  },
                  child: Text(
                    "Explore>",
                    style: TextStyle(
                      color: ColorRes.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 120 / 50,
              ),
              itemCount: overviewData.length,
              itemBuilder: (context, index) {
                final item = overviewData[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        item["icon"] as IconData,
                        size: 20,
                        color: ColorRes.primary,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item["title"]!,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          Text(
                            item["value"]!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddOnsForBuyer extends StatelessWidget {
  const AddOnsForBuyer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 175, // set fixed height for all cards
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: addonData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 2),
        itemBuilder: (context, index) {
          final addon = addonData[index];
          return SizedBox(
            width: 250,
            child: AddonCard(
              title: addon['title'],
              description: addon['description'],
              price: addon['price'],
              isPopular: addon['isPopular'] ?? false,
              onTap: () {
                print('${addon['title']} added!');
              },
            ),
          );
        },
      ),
    );
  }
}

class AddonCard extends StatelessWidget {
  final String title;
  final String description;
  final double price;
  final Color backgroundColor;
  final VoidCallback? onTap;
  final bool isPopular;

  const AddonCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    this.backgroundColor = Colors.white,
    this.onTap,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular ? ColorRes.primary : Colors.grey[300]!,
            width: isPopular ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // if (isPopular)
            //   Container(
            //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            //     decoration: BoxDecoration(
            //       color: Colors.orange,
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //     child: const Text(
            //       'POPULAR',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 10,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorRes.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PricingComparisonWidget extends StatefulWidget {
  final List<PricingPlan> plans;
  final Function(PricingPlan)? onPlanSelected;
  final Duration animationDuration;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  const PricingComparisonWidget({
    Key? key,
    required this.plans,
    this.onPlanSelected,
    this.animationDuration = const Duration(milliseconds: 800),
    this.primaryColor = const Color(0xFF6366F1),
    this.secondaryColor = const Color(0xFF10B981),
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  State<PricingComparisonWidget> createState() =>
      _PricingComparisonWidgetState();
}

class _PricingComparisonWidgetState extends State<PricingComparisonWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int? selectedPlanIndex;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(),
              _buildComparisonTable(),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            // border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Plans",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
              ),
              const Expanded(child: Text("", style: TextStyle(fontSize: 14))),
              ...widget.plans.map((plan) {
                return Expanded(
                  child: Text(
                    plan.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color:
                          plan.isPopular
                              ? widget.primaryColor
                              : const Color(0xFF4A4A4A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
        Divider(height: 1, color: Colors.grey[200]!),
      ],
    );
  }

  Widget _buildComparisonTable() {
    final allFeatures = _getAllUniqueFeatures();

    return Column(
      children:
          allFeatures.map((featureName) {
            return _buildFeatureRow(featureName);
          }).toList(),
    );
  }

  List<String> _getAllUniqueFeatures() {
    Set<String> features = {};
    for (var plan in widget.plans) {
      features.addAll(plan.features.keys);
    }
    return features.toList();
  }

  Widget _buildFeatureRow(String featureName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1), // Reduced margin
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              featureName,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF4A4A4A),
              ),
            ),
          ),
          ...widget.plans.map((plan) {
            final feature = plan.features[featureName];
            return Expanded(child: _buildFeatureValue(feature));
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFeatureValue(PlanFeature? feature) {
    if (feature == null) {
      return const Text(
        "-",
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      );
    }

    switch (feature.type) {
      case FeatureType.boolean:
        return Icon(
          feature.value == true ? Icons.check_circle : Icons.cancel,
          color: feature.value == true ? widget.secondaryColor : Colors.red,
          size: 20,
        );
      case FeatureType.percentage:
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: feature.value / 100),
                duration: widget.animationDuration,
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    value: value,
                    strokeWidth: 4,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      feature.value >= 90
                          ? widget.secondaryColor
                          : widget.primaryColor,
                    ),
                  );
                },
              ),
            ),
            Text(
              '${feature.value.toInt()}%',
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        );
      case FeatureType.text:
        return Text(
          feature.value.toString(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:
                feature.isHighlight
                    ? widget.primaryColor
                    : const Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        );
      case FeatureType.number:
        return Text(
          feature.value.toString(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color:
                feature.isHighlight
                    ? widget.primaryColor
                    : const Color(0xFF4A4A4A),
          ),
          textAlign: TextAlign.center,
        );
    }
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
      child: Row(
        children:
            widget.plans.map((plan) {
              int index = widget.plans.indexOf(plan);
              bool isSelected = selectedPlanIndex == index;

              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: index > 0 ? 8 : 0),
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedPlanIndex = index;
                            });
                            widget.onPlanSelected?.call(plan);
                            _showPlanDetails(plan);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                plan.isPopular
                                    ? widget.primaryColor
                                    : Colors.grey[200],
                            foregroundColor:
                                plan.isPopular
                                    ? Colors.white
                                    : Colors.grey[700],
                            elevation: isSelected ? 8 : 2,
                            // shadowColor: (plan.isPopular
                            //         ? widget.primaryColor
                            //         : widget.secondaryColor)
                            //     .withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            plan.buttonText,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      // const SizedBox(height: 8),
                      // TextButton(
                      //   onPressed: () {
                      //     _showPlanDetails(plan);
                      //   },
                      //   child: Text(
                      //     'Know More',
                      //     style: TextStyle(
                      //       color: widget.primaryColor,
                      //       fontSize: 12,
                      //       decoration: TextDecoration.underline,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  void _showPlanDetails(PricingPlan plan) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    plan.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: widget.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children:
                          plan.features.entries.map((entry) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  _buildFeatureValue(entry.value),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}

// Data Models
class PricingPlan {
  final String name;
  final String buttonText;
  final bool isPopular;
  final Map<String, PlanFeature> features;

  PricingPlan({
    required this.name,
    required this.buttonText,
    this.isPopular = false,
    required this.features,
  });
}

class PlanFeature {
  final dynamic value;
  final FeatureType type;
  final bool isHighlight;

  PlanFeature({
    required this.value,
    required this.type,
    this.isHighlight = false,
  });
}

enum FeatureType { boolean, text, number, percentage }

// Example Usage
class PricingWidgetDemo extends StatelessWidget {
  const PricingWidgetDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final plans = [
      PricingPlan(
        name: 'Free',
        buttonText: 'Know More',
        features: {
          'Visibility': PlanFeature(value: 15.0, type: FeatureType.percentage),
          'Leads': PlanFeature(value: 'Only 3', type: FeatureType.text),
          'Listing expiry': PlanFeature(
            value: '15 Days',
            type: FeatureType.text,
          ),
          'Matching buyers': PlanFeature(
            value: false,
            type: FeatureType.boolean,
          ),
          'Relationship Manager': PlanFeature(
            value: false,
            type: FeatureType.boolean,
          ),
          'Field Visit Assistance': PlanFeature(
            value: false,
            type: FeatureType.boolean,
          ),
          'PhotoShoot': PlanFeature(value: false, type: FeatureType.boolean),
        },
      ),
      PricingPlan(
        name: 'Owner',
        buttonText: 'Explore',
        isPopular: true,
        features: {
          'Visibility': PlanFeature(
            value: 98.0,
            type: FeatureType.percentage,
            isHighlight: true,
          ),
          'Leads': PlanFeature(
            value: 'Unlimited',
            type: FeatureType.text,
            isHighlight: true,
          ),
          'Listing expiry': PlanFeature(
            value: '120 Days',
            type: FeatureType.text,
            isHighlight: true,
          ),
          'Matching buyers': PlanFeature(
            value: true,
            type: FeatureType.boolean,
          ),
          'Relationship Manager': PlanFeature(
            value: true,
            type: FeatureType.boolean,
          ),
          'Field Visit Assistance': PlanFeature(
            value: true,
            type: FeatureType.boolean,
          ),
          'PhotoShoot': PlanFeature(value: true, type: FeatureType.boolean),
        },
      ),
    ];

    return PricingComparisonWidget(
      plans: plans,
      primaryColor: ColorRes.primary,
      onPlanSelected: (plan) {
        print('Selected: ${plan.name}');
      },
    );
  }
}

class CustomerSupportCard extends StatelessWidget {
  final String email;
  final String phone;

  const CustomerSupportCard({
    super.key,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      // margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.support_agent, color: ColorRes.primary),
                const SizedBox(width: 8),
                const Text(
                  "Customer Support",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),

              child: Row(
                children: [
                  Icon(Icons.email_outlined, color: ColorRes.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(email, style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Row(
                children: [
                  Icon(Icons.phone_outlined, color: ColorRes.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(phone, style: const TextStyle(fontSize: 16)),
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
