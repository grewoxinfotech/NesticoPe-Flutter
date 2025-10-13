// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
//
// import '../../profile/views/profile_screen.dart';
// import '../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
// import '../controller/dashborad_controller/dashboard_controller.dart';
// import '../model/dashboard/dashboard_model.dart';
// import 'lead/lead_screen.dart';
// import 'listing/property_listing.dart';
//
//
// // Dashboard Screen
// class ResellerDashboardScreen extends StatelessWidget {
//   const ResellerDashboardScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(DashboardController());
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         title: const Text(
//             'Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
//         backgroundColor: ColorRes.white,
//         elevation: 0,
//         // actions: [
//         //   Obx(() => controller.isLoading.value
//         //       ? const Padding(
//         //     padding: EdgeInsets.all(16.0),
//         //     child: SizedBox(
//         //       width: 20,
//         //       height: 20,
//         //       child: CircularProgressIndicator(strokeWidth: 2),
//         //     ),
//         //   )
//         //       : IconButton(
//         //     icon: const Icon(Icons.refresh),
//         //     onPressed: controller.refreshDashboard,
//         //   )),
//         // ],
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value && controller.recentLeads.isEmpty) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         return RefreshIndicator(
//           onRefresh: controller.refreshDashboard,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Overview Cards
//                 _buildOverviewCards(controller),
//                 const SizedBox(height: 8),
//
//                 // Recent Leads
//                 _buildRecentLeads(controller),
//                 const SizedBox(height: 8),
//
//                 // Top Products
//                 _buildTopProducts(controller),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
//
//   Widget _buildOverviewCards(DashboardController controller) {
//     return Obx(() {
//       final metrics = controller.metrics.value;
//       return GridView.count(
//         shrinkWrap: true,
//         physics: const NeverScrollableScrollPhysics(),
//         crossAxisCount: 2,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 1.5,
//         children: [
//           _buildMetricCard(
//             'Property Sales',
//             '\$${(metrics.totalSales / 1000000).toStringAsFixed(2)}M',
//             Icons.home_work,
//             Colors.green,
//           ),
//           _buildMetricCard(
//             'Buyer Leads',
//             '${metrics.totalLeads}',
//             Icons.people_outline,
//             Colors.blue,
//           ),
//           _buildMetricCard(
//             'Listed Properties',
//             '${metrics.totalProducts}',
//             Icons.apartment,
//             Colors.orange,
//           ),
//           _buildMetricCard(
//             'Sales Growth',
//             '${metrics.growthPercentage.toStringAsFixed(1)}%',
//             Icons.trending_up,
//             Colors.purple,
//           ),
//         ],
//       );
//     });
//   }
//
//   Widget _buildMetricCard(String title, String value, IconData icon,
//       Color color) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         // Calculate responsive sizes based on available width
//         final cardWidth = constraints.maxWidth;
//         final isCompact = cardWidth < 150;
//
//         // Responsive sizing using AppFontSizes
//         final titleFontSize = isCompact ? AppFontSizes.extraSmall : AppFontSizes.small;
//         final valueFontSize = isCompact ? AppFontSizes.body : AppFontSizes.large;
//         final iconSize = isCompact ? 14.0 : 15.0;
//         final iconPadding = isCompact ? 6.0 : 8.0;
//         final cardPadding = isCompact ? 12.0 : 16.0;
//
//         return Container(
//           padding: EdgeInsets.all(cardPadding),
//           decoration: BoxDecoration(
//             color: ColorRes.white,
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(width: 1, color: Colors.grey.shade300),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Flexible(
//                     child: Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: titleFontSize,
//                         color: Colors.grey[600],
//                         fontWeight: AppFontWeights.medium,
//                       ),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 2,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   Container(
//                     padding: EdgeInsets.all(iconPadding),
//                     decoration: BoxDecoration(
//                       color: color.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Icon(icon, color: color, size: iconSize),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style:  TextStyle(
//                   fontSize: valueFontSize,
//                   fontWeight: AppFontWeights.bold,
//                   color: Colors.black87,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildRecentLeads(DashboardController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Recent Buyer Leads',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textPrimary,
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to full leads screen
//                 Get.to(() => ResellerLeadScreen());
//               },
//               child: const Text('View All',style: TextStyle(
//                 fontWeight: AppFontWeights.medium,
//                 color: ColorRes.primary,
//                 fontSize: 12
//               ),),
//             ),
//           ],
//         ),
//
//         Obx(() =>
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: controller.recentLeads
//                   .take(5)
//                   .length,
//               separatorBuilder: (context, index) => const SizedBox(height: 8),
//               itemBuilder: (context, index) {
//                 final lead = controller.recentLeads[index];
//                 return _buildLeadItem(lead);
//               },
//             )),
//       ],
//     );
//   }
//
//   Widget _buildLeadItem(Lead lead) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         side: BorderSide(color: Colors.grey.shade300, width: 1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         leading: CircleAvatar(
//           backgroundColor: _getStatusColor(lead.status).withOpacity(0.1),
//           child: Text(
//             lead.name.split(' ').map((e) => e[0]).join().toUpperCase(),
//             style: TextStyle(
//               color: _getStatusColor(lead.status),
//               fontWeight: AppFontWeights.bold,
//             ),
//           ),
//         ),
//         title: Text(
//           lead.name,
//           style: TextStyle(
//               fontWeight: AppFontWeights.semiBold, fontSize: AppFontSizes.bodySmall),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
//                 const SizedBox(width: 4),
//                 Expanded(
//                   child: Text(
//                     lead.company,
//                     style: TextStyle(fontSize: AppFontSizes.mini),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 2),
//                   decoration: BoxDecoration(
//                     color: _getStatusColor(lead.status).withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Text(
//                     _getStatusText(lead.status),
//                     style: TextStyle(
//                       fontSize: AppFontSizes.mini,
//                       color: _getStatusColor(lead.status),
//                       fontWeight: AppFontWeights.medium,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               'Budget',
//               style: TextStyle(
//                 fontSize: 9,
//                 color: Colors.grey[500],
//               ),
//             ),
//             Text(
//               '\$${(lead.estimatedValue / 1000).toStringAsFixed(0)}k',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14,
//                 color: Colors.green,
//               ),
//             ),
//             Text(
//               _formatTime(lead.createdAt),
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildTopProducts(DashboardController controller) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               'Top Property',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: AppFontWeights.semiBold,
//                 color: ColorRes.textPrimary,
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Navigate to full leads screen
//                 Get.to(() => ResellerLeadScreen());
//               },
//               child: const Text('View All',style: TextStyle(
//                   fontWeight: AppFontWeights.medium,
//                   color: ColorRes.primary,
//                   fontSize: 12
//               ),),
//             ),
//           ],
//         ),
//
//         Obx(() =>
//             SizedBox(
//               height: 230,
//               child: ListView.separated(
//
//                 scrollDirection: Axis.horizontal,
//                 itemCount: controller.topProducts.length,
//
//                 separatorBuilder: (context, index) => const SizedBox(width: 12),
//                 itemBuilder: (context, index) {
//                   final product = controller.topProducts[index];
//                   return _buildProductCard(product);
//                 },
//               ),
//             )),
//       ],
//     );
//   }
//
//   Widget _buildProductCard(Product product) {
//     return SizedBox(
//       width: 200, // <-- fixed width for horizontal scrolling
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         decoration: BoxDecoration(
//           color: ColorRes.white,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: Colors.grey.shade200, width: 1),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Property image with chip overlay
//             Stack(
//               children: [
//                 ClipRRect(
//                   borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(16)),
//                   child: Image.network(
//                     product.image,
//                     height: 100,
//                     width: double.infinity, // okay inside a fixed-width parent
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Positioned(
//                   top: 8,
//                   left: 8,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 8, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: ColorRes.white,
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     child: const Text(
//                       'Added Today',
//                       style: TextStyle(
//                         fontSize: 10,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const Positioned(
//                   top: 8,
//                   right: 8,
//                   child: Icon(
//                     Icons.favorite_border,
//                     color: ColorRes.white,
//                   ),
//                 ),
//               ],
//             ),
//
//             Padding(
//               padding: const EdgeInsets.all(8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     product.name,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     product.category,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 6),
//                   Row(
//                     children: [
//                       Text(
//                         'Used Property',
//                         style: TextStyle(
//                             fontSize: 11, color: Colors.grey.shade700),
//                       ),
//                       const SizedBox(width: 4),
//                       Icon(Icons.king_bed_outlined, size: 14,
//                           color: Colors.grey.shade700),
//                       const SizedBox(width: 2),
//                       Text('${product.beds}', style: TextStyle(fontSize: 11)),
//                       const SizedBox(width: 4),
//                       Icon(Icons.square_foot, size: 14,
//                           color: Colors.grey.shade700),
//                       const SizedBox(width: 2),
//                       Text(
//                           '${product.area} m²', style: TextStyle(fontSize: 11)),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     '\$${product.price.toStringAsFixed(0)}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2A5BD7),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Color _getStatusColor(LeadStatus status) {
//     switch (status) {
//       case LeadStatus.new_:
//         return Colors.blue;
//       case LeadStatus.contacted:
//         return Colors.orange;
//       case LeadStatus.qualified:
//         return Colors.purple;
//       case LeadStatus.proposal:
//         return Colors.indigo;
//       case LeadStatus.closed:
//         return Colors.green;
//       case LeadStatus.lost:
//         return Colors.red;
//     }
//   }
//
//   String _getStatusText(LeadStatus status) {
//     switch (status) {
//       case LeadStatus.new_:
//         return 'New';
//       case LeadStatus.contacted:
//         return 'Contacted';
//       case LeadStatus.qualified:
//         return 'Property Shown';
//       case LeadStatus.proposal:
//         return 'Negotiating';
//       case LeadStatus.closed:
//         return 'Sold';
//       case LeadStatus.lost:
//         return 'Lost';
//     }
//   }
//
//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);
//
//     if (difference.inDays > 0) {
//       return '${difference.inDays}d ago';
//     } else if (difference.inHours > 0) {
//       return '${difference.inHours}h ago';
//     } else {
//       return '${difference.inMinutes}m ago';
//     }
//   }
// }
// // Navigation Controller
// class ResellerNavigationController extends GetxController {
//   final RxInt currentIndex = 0.obs;
//
//   void changeTabIndex(int index) {
//     currentIndex.value = index;
//   }
// }
//
//
// class MainNavigationScreen extends StatelessWidget {
//   const MainNavigationScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final navigationController = Get.put(ResellerNavigationController());
//
//     final screens = [
//       const ResellerDashboardScreen(),
//        ProductListingScreen(),
//       ResellerLeadScreen(),
//       ProfileScreen(imageUrl: 'https://wallpapers.com/images/thumbnail/cool-profile-picture-awled9dwo4qq2yv2.jpg',),
//     ];
//
//     return Scaffold(
//       body: Obx(() => IndexedStack(
//         index: navigationController.currentIndex.value,
//         children: screens,
//       )),
//       bottomNavigationBar: Obx(() => SafeArea(
//         child: BottomNavigationBar(
//           currentIndex: navigationController.currentIndex.value,
//           onTap: navigationController.changeTabIndex,
//           type: BottomNavigationBarType.fixed,
//           selectedItemColor: Colors.blue,
//           unselectedItemColor: Colors.grey,
//           selectedLabelStyle: TextStyle(fontSize: AppFontSizes.caption,fontWeight: AppFontWeights.medium),
//           unselectedLabelStyle: TextStyle(fontSize: AppFontSizes.caption,fontWeight: AppFontWeights.medium),
//           backgroundColor: ColorRes.white,
//           elevation: 8,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.dashboard,size: 18,),
//               label: 'Dashboard',
//
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.apartment,size: 18,),
//               label: 'Property',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.people,size: 18,),
//               label: 'Leads',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person,size: 18,),
//               label: 'Profile',
//             ),
//           ],
//         ),
//       )),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/reseller/view/profile/reseller_profile.dart';

import '../../../app/constants/size_manager.dart';
import '../../../app/utils/formater/formater.dart';
import '../../../utils/global.dart';
import '../../dashboard/views/dashboard_screen.dart';
import '../../profile/views/profile_screen.dart';
import '../../seller/module/lead_screen/views/lead_screen_enhanced.dart';
import '../controller/dashborad_controller/dashboard_controller.dart';
import '../model/dashboard/dashboard_model.dart';
import 'lead/lead_screen.dart';
import 'lead_overview/lead_detail.dart';
import 'listing/property_listing.dart';

// Dashboard Screen
class ResellerDashboardScreen extends StatelessWidget {
  const ResellerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: ColorRes.white,
      appBar: AppBar(
        title:  Text(
          'Dashboard',
          style: TextStyle(fontWeight: AppFontWeights.extraBold),
        ),
        backgroundColor: ColorRes.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          TextButton(onPressed: () {
            Get.offAll(() => DashboardScreen());
          }, child: Text('Back')),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.recentLeads.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refreshDashboard,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Cards
                buildOverviewCards(controller),
                const SizedBox(height: 20),

                // Recent Leads
                _buildRecentLeads(controller),
                const SizedBox(height: 20),

                // Top Products
                _buildTopProducts(controller),
                // const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }),
    );
  }
}

Widget buildOverviewCards(DashboardController controller) {
  return Obx(() {
    final metrics = controller.metrics.value;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        buildMetricCard(
          'Property Sales',
          '\$${(metrics.totalSales / 1000000).toStringAsFixed(2)}M',
          Icons.home_work,
          ColorRes.success,
        ),
        buildMetricCard(
          'Buyer Leads',
          '${metrics.totalLeads}',
          Icons.people,
          ColorRes.blueColor,
        ),
        buildMetricCard(
          'Listed Properties',
          '${metrics.totalProducts}',
          Icons.apartment,
          ColorRes.orangeColor,
        ),
        buildMetricCard(
          'Sales Growth',
          '${metrics.growthPercentage.toStringAsFixed(1)}%',
          Icons.trending_up,
          ColorRes.purpleColor,
        ),
      ],
    );
  });
}



Widget _buildRecentLeads(DashboardController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              'Recent Buyer Leads',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => ResellerLeadScreen(isViewAll: true));
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child:  Text(
                'View All',
                style: TextStyle(
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ),
          ],
        ),
      ),
      Obx(
        () => ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.recentLeads.take(5).length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final lead = controller.recentLeads[index];
            return _buildLeadCard(context, lead, controller);
          },
        ),
      ),
    ],
  );
}

Widget _buildLeadCard(
  BuildContext context,
  Lead lead,
  DashboardController controller,
) {
  final isCompact = MediaQuery.of(context).size.width < 600;
  final cardPadding = isCompact ? 12.0 : 16.0;

  return Container(
    padding: EdgeInsets.all(cardPadding),
    decoration: BoxDecoration(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: ColorRes.leadGreyColor.withOpacity(0.3),
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row with Avatar and Basic Info
        Row(
          children: [
            // Column 1: Avatar
            CircleAvatar(
              radius: isCompact ? 18 : 20,
              backgroundColor: ColorRes.primary.withOpacity(0.2),
              child: Text(
                lead.name.split(' ').map((e) => e[0]).join().toUpperCase(),
                style: TextStyle(
                  color: ColorRes.primary,
                  fontWeight: AppFontWeights.bold,
                  fontSize:
                      isCompact ? AppFontSizes.small : AppFontSizes.medium,
                ),
              ),
            ),
            SizedBox(width: isCompact ? 8 : 12),

            // Column 2: Lead Details
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name
                  SizedBox(
                    width: 180,
                    child: Text(
                      lead.name,
                      style: TextStyle(
                        fontSize:
                            isCompact ? AppFontSizes.medium : AppFontSizes.body,
                        fontWeight: AppFontWeights.bold,
                        color: ColorRes.textColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2),

                  // Company with location icon
                  SizedBox(
                    width: 180,
                    child: Text(
                      '${lead.company}',
                      style: TextStyle(
                        fontSize:
                            isCompact
                                ? AppFontSizes.extraSmall
                                : AppFontSizes.small,
                        color: ColorRes.leadGreyColor.shade700,
                        fontWeight: AppFontWeights.regular,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 2),

                  // Email
                  if (lead.email.isNotEmpty) ...[
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lead.email,
                            style: TextStyle(
                              fontSize: AppFontSizes.extraSmall,
                              color: ColorRes.leadGreyColor.shade600,
                              fontWeight: AppFontWeights.regular,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Column 3: Budget & Time Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Budget',
                  style: TextStyle(
                    fontSize: AppFontSizes.extraSmall,
                    color: ColorRes.leadGreyColor.shade800,
                    fontWeight: AppFontWeights.regular,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${Formatter.formatPrice(lead.estimatedValue)}',
                  style: TextStyle(
                    fontSize:
                        isCompact ? AppFontSizes.medium : AppFontSizes.body,
                    fontWeight: AppFontWeights.semiBold,
                    color: ColorRes.green,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _formatTime(lead.createdAt),
                  style: TextStyle(
                    fontSize: AppFontSizes.caption,
                    color: ColorRes.leadGreyColor.shade600,
                    fontWeight: AppFontWeights.regular,
                  ),
                ),
              ],
            ),
          ],
        ),

        SizedBox(height: isCompact ? 8 : 12),
        Divider(color: ColorRes.leadGreyColor, thickness: 0.5),
        SizedBox(height: isCompact ? 8 : 12),

        // Bottom Row with Status and Actions
        Row(
          children: [
            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 10 : 14,
                vertical: isCompact ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: _getStatusColor(lead.status).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStatusColor(lead.status).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _getStatusText(lead.status),
                style: TextStyle(
                  fontSize:
                      isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
                  color: _getStatusColor(lead.status),
                  fontWeight: AppFontWeights.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: 8),
            // Stage Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isCompact ? 10 : 14,
                vertical: isCompact ? 6 : 8,
              ),
              decoration: BoxDecoration(
                color: _getStageColor(lead.stage).withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _getStageColor(lead.stage).withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                _getStageText(lead.stage),
                style: TextStyle(
                  fontSize:
                      isCompact ? AppFontSizes.extraSmall : AppFontSizes.small,
                  color: _getStageColor(lead.stage),
                  fontWeight: AppFontWeights.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Spacer(),
            Row(
              children: [
                buildActionButton(
                  icon: Icons.visibility,
                  color: ColorRes.blueColor,
                  onPressed: () {
                    Get.to(() => LeadDetailScreen(lead: dummyResellerLead));
                  },
                  tooltip: 'View Details',
                  isCompact: isCompact,
                ),
                SizedBox(width: 8),
                buildActionButton(
                  icon: Icons.edit,
                  color: ColorRes.orangeColor,
                  onPressed:
                      () => showLeadForm(context, controller, lead: lead),
                  tooltip: 'Edit Lead',
                  isCompact: isCompact,
                ),
                SizedBox(width: 8),
                buildActionButton(
                  icon: Icons.delete,
                  color: ColorRes.error,
                  onPressed:
                      () => showDeleteConfirmation(context, lead, controller),
                  tooltip: 'Delete Lead',
                  isCompact: isCompact,
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildTopProducts(DashboardController controller) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(
              'Top Property',
              style: TextStyle(
                fontSize: AppFontSizes.body,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(() => ResellerLeadScreen());
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'View All',
                style: TextStyle(
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.primary,
                  fontSize: AppFontSizes.caption,
                ),
              ),
            ),
          ],
        ),
      ),
      Obx(
        () => SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: controller.topProducts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final product = controller.topProducts[index];
              return _buildProductCard(product);
            },
          ),
        ),
      ),
    ],
  );
}

Widget _buildProductCard(Product product) {
  return SizedBox(
    width: 200,
    child: Container(
      decoration: BoxDecoration(
        color: ColorRes.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product.image,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColorRes.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: ColorRes.leadGreyColor.shade300,
                      width: 1,
                    ),
                  ),
                  child:  Text(
                    'Added Today',
                    style: TextStyle(
                      fontSize: AppFontSizes.tiny,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textPrimary,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: ColorRes.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    color: ColorRes.textPrimary,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 160,
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: AppFontSizes.medium,
                      fontWeight: AppFontWeights.semiBold,
                      color: ColorRes.textColor,
                      // height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 160,
                  child: Text(
                    product.category,
                    style: TextStyle(
                      fontSize: AppFontSizes.extraSmall,
                      color: ColorRes.leadGreyColor.shade700,
                      // height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 6,
                    // runSpacing: 4,
                    children: List.generate(
                      4,
                      (index) => _buildPropertyFeature(
                        Icons.square_foot,
                        '${product.area} m²',
                        isFirst: (index == 0) ? true : false,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${Formatter.formatPrice(product.price)}',
                      style: TextStyle(
                        fontSize: AppFontSizes.body,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                        // height: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorRes.primary,
                      ),
                      child:  Text(
                        'Contact ',
                        style: TextStyle(
                          fontSize: AppFontSizes.extraSmall,
                          fontWeight: AppFontWeights.semiBold,
                          color: ColorRes.white,
                        ),
                      ),
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

Widget _buildPropertyFeature(
  IconData icon,
  String text, {
  bool isFirst = false,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (!isFirst) ...[
         Text('-', style: TextStyle(fontSize: AppFontSizes.extraSmall)),
        // const Text('•', style: TextStyle(fontSize: 10)),
        const SizedBox(width: 2),
      ],
      Icon(icon, size: 14, color: ColorRes.primary),
      const SizedBox(width: 3),
      Text(
        text,
        style: TextStyle(
          fontSize: AppFontSizes.mini,
          color: ColorRes.leadGreyColor.shade800,
          height: 1.0,
        ),
      ),
    ],
  );
}

Color _getStatusColor(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_: // 'New'
      return ColorRes.blueColor;
    case LeadStatus.contacted:
      return ColorRes.orangeColor;
    case LeadStatus.qualified:
      return ColorRes.purpleColor;
    case LeadStatus.negotiation:
      return ColorRes.leadIndigoColor;
    case LeadStatus.lost:
      return ColorRes.error;
    case LeadStatus.convert:
      return ColorRes.leadTealColor;
    case LeadStatus.all:
    default:
      return ColorRes.leadGreyColor;
  }
}

String _getStatusText(LeadStatus status) {
  switch (status) {
    case LeadStatus.new_:
      return 'New';
    case LeadStatus.contacted:
      return 'Contacted';
    case LeadStatus.qualified:
      return 'Qualified';
    case LeadStatus.negotiation:
      return 'Negotiating';
    case LeadStatus.lost:
      return 'Lost';
    case LeadStatus.convert:
      return 'Converted';
    case LeadStatus.all:
    default:
      return 'All';
  }
}

Color _getStageColor(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead: // 'New Lead'
      return ColorRes.blueColor;
    // return Colors.blue;
    case LeadStage.contacted:
      return ColorRes.orangeColor;
    // return ;
    // return Colors.orange;
    case LeadStage.interested:
      return ColorRes.purpleColor;
    // return Colors.purple;
    case LeadStage.siteVisit:
      return ColorRes.leadIndigoColor;
    // return Colors.indigo;
    case LeadStage.sell:
      return ColorRes.success;
    // return Colors.green;
    case LeadStage.all:
    default:
      return ColorRes.leadGreyColor;
    // return Colors.grey;
  }
}

String _getStageText(LeadStage stage) {
  switch (stage) {
    case LeadStage.newLead:
      return 'New Lead';
    case LeadStage.contacted:
      return 'Contacted';
    case LeadStage.interested:
      return 'Interested';
    case LeadStage.siteVisit:
      return 'Site Visit';
    case LeadStage.sell:
      return 'Sell';
    case LeadStage.all:
    default:
      return 'All';
  }
}

String _formatTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays}d ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours}h ago';
  } else {
    return '${difference.inMinutes}m ago';
  }
}

// Navigation Controller
class ResellerNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationController = Get.put(ResellerNavigationController());

    final screens = [
      const ResellerDashboardScreen(),
      ProductListingScreen(),
      ResellerLeadScreen(),
      ResellerProfileScreen(),
    ];

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: navigationController.currentIndex.value,
          children: screens,
        ),
      ),
      bottomNavigationBar: Obx(
        () => SafeArea(
          child: BottomNavigationBar(
            currentIndex: navigationController.currentIndex.value,
            onTap: navigationController.changeTabIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: ColorRes.blueColor,
            unselectedItemColor: ColorRes.leadGreyColor,
            selectedLabelStyle: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.semiBold,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: AppFontSizes.caption,
              fontWeight: AppFontWeights.medium,
            ),
            backgroundColor: ColorRes.white,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.dashboard, size: 22),
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.inventory, size: 22),
                ),
                label: 'Property',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.people, size: 22),
                ),
                label: 'Leads',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.person, size: 22),
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Widget buildMetricCard(String title, String value, IconData icon, Color color) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final cardWidth = constraints.maxWidth;
      final isCompact = cardWidth < 150;

      final titleFontSize =
      isCompact ? AppFontSizes.extraSmall : AppFontSizes.small;
      final valueFontSize = isCompact ? AppFontSizes.body : AppFontSizes.large;
      final iconSize = isCompact ? 16.0 : 18.0;
      final iconPadding = isCompact ? 6.0 : 8.0;
      final cardPadding = isCompact ? 12.0 : 16.0;

      return Container(
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.02),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1, color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: ColorRes.leadGreyColor[600],
                      fontWeight: AppFontWeights.medium,
                      height: 1.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: iconSize),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: valueFontSize,
                fontWeight: AppFontWeights.semiBold,
                color: ColorRes.textPrimary,
                height: 1.0,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      );
    },
  );
}