// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/database/secure_storage_service.dart';
// // 👈 import UserHelper
// import '../../../app/constants/app_font_sizes.dart';
// import '../../../app/constants/color_res.dart';
// import '../../../app/constants/enum.dart';
// import '../../../app/utils/helper_function/user_helper/user_helper.dart';

// import '../../auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
// import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
// import '../../contractor/view/widget/convert_to_contractor.dart';
// import '../../subscription/views/suscription_plan_screen.dart';

// class InsightsScreen extends StatelessWidget {
//   const InsightsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // 🔹 Logged-in users flow
//     if (UserHelper.isContractor) {
//       return SubscriptionPlansScreen(
//         role: Roles.contractor.name,
//         isShowCurrentPlan: true,
//         isNotFromBuyerSide: true,
//         origin: 'panel',
//       );
//     } else if (UserHelper.isSellerOwner) {
//       return SubscriptionPlansScreen(
//         role: Roles.sellerOwner.name,
//         isShowCurrentPlan: true,

//         isNotFromBuyerSide: true,
//         origin: 'panel',
//       );
//     } else if (UserHelper.isSellerBuilder) {
//       return SubscriptionPlansScreen(
//         role: Roles.sellerBuilder.name,
//         isShowCurrentPlan: true,
//         isNotFromBuyerSide: true,
//         origin: 'panel',
//       );
//     } else if (UserHelper.isReseller) {
//       return SubscriptionPlansScreen(
//         role: Roles.reseller.name,
//         isShowCurrentPlan: true,
//         origin: 'panel',
//         isNotFromBuyerSide: true,
//       );
//     }
//     // else if (UserHelper.isBuyer) {
//     //   return BuyerConversionScreen();
//     // }

//     // 🔹 Guest user flow → Show role selection tiles
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Center(
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Choose your role\nto continue',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                   height: 1.2,
//                 ),
//               ),
//               SizedBox(height: 8),
//               Text(
//                 'Select a role to view subscription plans\nand get started.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.grey[600],
//                   height: 1.5,
//                 ),
//               ),
//               SizedBox(height: 32),

//               _buildGuestRoleTile(
//                 title: "Seller (Owner) Plans",
//                 subtitle: "List and sell your property",
//                 icon: Icons.home_work_outlined,
//                 iconColor: ColorRes.primary,
//                 iconBgColor: ColorRes.primary.withOpacity(0.05),
//                 onTap: () async {
//                   final data =
//                       await SecureStorage.hasSubscriptionInquiryForUser(
//                         Roles.sellerOwner.name,
//                         userId: (await SecureStorage.getClientId()) ?? '',
//                         role: Roles.sellerOwner.name,
//                       );
//                   debugPrint("Has Subscription Inquiry For : $data");
//                   Get.to(
//                     () => SubscriptionPlansScreen(
//                       role: Roles.sellerOwner.name,
//                       isInquirySubmitted: data,
//                       origin: 'buyer',
//                       isNotFromBuyerSide: false,
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 16),

//               _buildGuestRoleTile(
//                 title: "Seller (Builder) Plans",
//                 subtitle: "Showcase your projects",
//                 icon: Icons.apartment_outlined,
//                 iconColor: ColorRes.primary,
//                 iconBgColor: ColorRes.primary.withOpacity(0.05),
//                 onTap: () async {
//                   final data =
//                       await SecureStorage.hasSubscriptionInquiryForUser(
//                         Roles.sellerBuilder.name,
//                         userId: (await SecureStorage.getClientId()) ?? '',
//                         role: Roles.sellerBuilder.name,
//                       );
//                   debugPrint("Has Subscription Inquiry For : $data");
//                   Get.to(
//                     () => SubscriptionPlansScreen(
//                       role: Roles.sellerBuilder.name,
//                       isInquirySubmitted: data,
//                       isNotFromBuyerSide: false,
//                       origin: 'buyer',
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 16),

//               _buildGuestRoleTile(
//                 title: "Partner Plans",
//                 subtitle: "Join our partners program",
//                 icon: Icons.handshake_outlined,
//                 iconColor: ColorRes.primary,
//                 iconBgColor: ColorRes.primary.withOpacity(0.05),
//                 onTap: () async {
//                   final data =
//                       await SecureStorage.hasSubscriptionInquiryForUser(
//                         Roles.reseller.name,
//                         userId: (await SecureStorage.getClientId()) ?? '',
//                         role: Roles.reseller.name,
//                       );
//                   debugPrint("Has Subscription Inquiry For : $data");
//                   Get.to(
//                     () => SubscriptionPlansScreen(
//                       isNotFromBuyerSide: false,
//                       role: Roles.reseller.name,
//                       isInquirySubmitted: data,
//                       origin: 'buyer',
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 16),

//               _buildGuestRoleTile(
//                 title: "Contractor Plans",
//                 subtitle: "Provide renovation services",
//                 icon: Icons.engineering_outlined,
//                 iconColor: ColorRes.primary,
//                 iconBgColor: ColorRes.primary.withOpacity(0.05),
//                 onTap: () async {
//                   final data =
//                       await SecureStorage.hasSubscriptionInquiryForUser(
//                         Roles.contractor.name,
//                         userId: (await SecureStorage.getClientId()) ?? '',
//                         role: Roles.contractor.name,
//                       );
//                   debugPrint("Has Subscription Inquiry For : $data");
//                   Get.to(
//                     () => SubscriptionPlansScreen(
//                       role: Roles.contractor.name,
//                       isNotFromBuyerSide: false,
//                       isInquirySubmitted: data,
//                       origin: 'buyer',
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildGuestRoleTile({
//     required String title,
//     required String subtitle,
//     required IconData icon,
//     required Color iconColor,
//     required Color iconBgColor,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(12),
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.grey[50],
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.transparent, width: 2),
//         ),
//         child: Row(
//           children: [
//             Container(
//               padding: EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: iconBgColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, color: iconColor, size: 24),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class BuyerConversionScreen extends StatelessWidget {
//   const BuyerConversionScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upgrade Your Account'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Icon(Icons.trending_up, size: 60, color: ColorRes.primary),
//             const SizedBox(height: 16),
//             Text(
//               'Unlock More Features',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: AppFontSizes.large,
//                 fontWeight: AppFontWeights.bold,
//                 color: ColorRes.textPrimary,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Convert your account to access advanced features and grow your business',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: AppFontSizes.small,
//                 color: ColorRes.textSecondary,
//               ),
//             ),
//             const SizedBox(height: 32),
//             _buildConversionButton(
//               context,
//               icon: Icons.store,
//               title: 'Become a Seller',
//               description: 'Start selling your products',
//               color: ColorRes.success,
//               onTap: () {
//                 Get.to(() => SellerConversionScreen());
//                 // TODO: Navigate to seller registration/conversion
//               },
//             ),
//             const SizedBox(height: 12),
//             _buildConversionButton(
//               context,
//               icon: Icons.people,
//               title: 'Become a Reseller',
//               description: 'Resell products and earn commissions',
//               color: ColorRes.orangeColor,
//               onTap: () {
//                 // TODO: Navigate to reseller registration/conversion
//                 Get.to(() => ResellerConversionScreen());
//               },
//             ),
//             const SizedBox(height: 12),
//             _buildConversionButton(
//               context,
//               icon: Icons.engineering,
//               title: 'Become a Contractor',
//               description: 'Offer your services as a contractor',
//               color: ColorRes.blueColor,
//               onTap: () {
//                 // TODO: Navigate to contractor registration/conversion
//                 Get.to(() => ConvertToContractorConversionScreen());
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConversionButton(
//     BuildContext context, {
//     required IconData icon,
//     required String title,
//     required String description,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.all(14.0),
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: color.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(icon, size: 28, color: color),
//               ),
//               const SizedBox(width: 14),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.medium,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       description,
//                       style: TextStyle(
//                         fontSize: AppFontSizes.caption,
//                         color: ColorRes.textSecondary,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Icon(
//                 Icons.arrow_forward_ios,
//                 size: 16,
//                 color: ColorRes.textSecondary,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

//
// class InsightProperty extends StatelessWidget {
//   InsightProperty({super.key});
//
//   // Dummy data
//   final List<Map<String, dynamic>> dummyProperties = [
//     {
//       "title": "Luxury Villa",
//       "address": "Beverly Hills, LA",
//       "totalViews": 1240,
//       "price": "\$2,500,000",
//       "image":
//           "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg",
//     },
//     {
//       "title": "Modern Apartment",
//       "address": "Downtown, New York",
//       "totalViews": 890,
//       "price": "\$850,000",
//       "image":
//           "https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg",
//     },
//     {
//       "title": "Beach House",
//       "address": "Miami Beach, Florida",
//       "totalViews": 1430,
//       "price": "\$1,750,000",
//       "image":
//           "https://images.pexels.com/photos/261146/pexels-photo-261146.jpeg",
//     },
//     {
//       "title": "Mountain Cabin",
//       "address": "Aspen, Colorado",
//       "totalViews": 560,
//       "price": "\$650,000",
//       "image":
//           "https://images.pexels.com/photos/460695/pexels-photo-460695.jpeg",
//     },
//     {
//       "title": "Penthouse Suite",
//       "address": "Dubai Marina",
//       "totalViews": 2100,
//       "price": "\$4,200,000",
//       "image":
//           "https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg",
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: dummyProperties.length,
//         padding: const EdgeInsets.only(left: 10),
//         itemBuilder: (context, index) {
//           final property = dummyProperties[index];
//           return Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: PropertyHorizontalCard(
//               imageHeight: double.infinity,
//               titleFontWeight: AppFontWeights.semiBold,
//               buttonText: 'View More',
//               locationFontSize: AppFontSizes.caption,
//               maxLineTitle: 1,
//               buttonFontWeight: AppFontWeights.semiBold,
//               buttonFontSize: AppFontSizes.extraSmall,
//               buttonTextColor: ColorRes.primary,
//               borderColor: ColorRes.grey,
//               maxLine: 1,
//               title: property["title"],
//               imagePath: property["image"],
//               location: 'Location : ${property["address"]}',
//               rating: (property["totalViews"] as int).toDouble(),
//               price: property["price"],
//               priceFontSize: AppFontSizes.caption,
//               priceFontWeight: AppFontWeights.semiBold,
//               ratingColor: ColorRes.primary,
//               accentColor: ColorRes.primary,
//               onTap: () {
//                 // Get.to(() => RatingDetail(property: property));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class RatedProperty extends StatelessWidget {
//   RatedProperty({super.key});
//
//   // Dummy data
//   final List<Map<String, dynamic>> ratedProperties = [
//     {
//       "title": "Luxury Villa",
//       "address": "Beverly Hills, LA",
//       "totalViews": 1240,
//       "price": "\$2,500,000",
//       "image":
//           "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg",
//     },
//     {
//       "title": "Modern Apartment",
//       "address": "Downtown, New York",
//       "totalViews": 890,
//       "price": "\$850,000",
//       "image":
//           "https://images.pexels.com/photos/323780/pexels-photo-323780.jpeg",
//     },
//     {
//       "title": "Beach House",
//       "address": "Miami Beach, Florida",
//       "totalViews": 1430,
//       "price": "\$1,750,000",
//       "image":
//           "https://images.pexels.com/photos/261146/pexels-photo-261146.jpeg",
//     },
//     {
//       "title": "Mountain Cabin",
//       "address": "Aspen, Colorado",
//       "totalViews": 560,
//       "price": "\$650,000",
//       "image":
//           "https://images.pexels.com/photos/460695/pexels-photo-460695.jpeg",
//     },
//     {
//       "title": "Penthouse Suite",
//       "address": "Dubai Marina",
//       "totalViews": 2100,
//       "price": "\$4,200,000",
//       "image":
//           "https://images.pexels.com/photos/259962/pexels-photo-259962.jpeg",
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 100,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: ratedProperties.length,
//         padding: const EdgeInsets.only(left: 10),
//         itemBuilder: (context, index) {
//           final property = ratedProperties[index];
//           return Padding(
//             padding: const EdgeInsets.only(right: 10),
//             child: PropertyHorizontalCard(
//               imageHeight: double.infinity,
//               titleFontWeight: AppFontWeights.semiBold,
//               buttonText: 'View More',
//               locationFontSize: AppFontSizes.caption,
//               maxLineTitle: 1,
//               buttonFontWeight: AppFontWeights.semiBold,
//               buttonFontSize: AppFontSizes.extraSmall,
//               buttonTextColor: ColorRes.primary,
//               borderColor: ColorRes.grey,
//               maxLine: 1,
//               title: property["title"],
//               imagePath: property["image"],
//               location: 'Location : ${property["address"]}',
//               rating: (property["totalViews"] as int).toDouble(),
//               price: property["price"],
//               priceFontSize: AppFontSizes.caption,
//               priceFontWeight: AppFontWeights.semiBold,
//               ratingColor: ColorRes.primary,
//               accentColor: ColorRes.primary,
//               onTap: () {
//                 // Get.to(() => RatingDetail(property: property));
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// // class RatedPropertyCard extends StatelessWidget {
// //   final String name;
// //   final String address;
// //   final String price;
// //   final String imagePath;
// //
// //   const RatedPropertyCard({
// //     super.key,
// //     required this.name,
// //     required this.address,
// //     required this.price,
// //     required this.imagePath,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: 350,
// //       padding: const EdgeInsets.all(8),
// //       decoration: BoxDecoration(
// //         borderRadius: BorderRadius.circular(10),
// //         border: Border.all(color: Colors.grey[200]!),
// //         // color: ColorRes.white,
// //       ),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min, // ✅ prevent vertical overflow
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Row(
// //             crossAxisAlignment: CrossAxisAlignment.start,
// //             children: [
// //               ClipRRect(
// //                 borderRadius: BorderRadius.circular(8),
// //                 child: Image.asset(
// //                   IMGRes.home1,
// //                   height: 80,
// //                   width: 80,
// //                   fit: BoxFit.cover,
// //                 ),
// //               ),
// //               const SizedBox(width: 12),
// //               Expanded(
// //                 // ✅ prevents horizontal overflow
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     Text(
// //                       name,
// //                       style: const TextStyle(
// //                         fontSize: 14,
// //                         fontWeight: AppFontWeights.semiBold,
// //                       ),
// //                       maxLines: 1,
// //                       overflow: TextOverflow.ellipsis, // ✅ avoids overflow
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Text(
// //                       address,
// //                       style: const TextStyle(
// //                         fontSize: 11,
// //                         color: Colors.black54,
// //                       ),
// //                       maxLines: 2,
// //                       overflow: TextOverflow.ellipsis, // ✅ wraps address
// //                     ),
// //                     const SizedBox(height: 4),
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                       children: [
// //                         Flexible(
// //                           child: Text(
// //                             price,
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               fontWeight: AppFontWeights.medium,
// //                             ),
// //                             maxLines: 1,
// //                             overflow: TextOverflow.ellipsis,
// //                           ),
// //                         ),
// //
// //                         Row(
// //                           children: [
// //                             Icon(Icons.star, color: ColorRes.primary, size: 12),
// //                             SizedBox(width: 4),
// //                             const Text(
// //                               "4.5 Ratings",
// //                               style: TextStyle(
// //                                 fontWeight: AppFontWeights.medium,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ],
// //                     ),
// //
// //                     SizedBox(height: 8),
// //                     SizedBox(
// //                       width: double.infinity,
// //                       child: ElevatedButton(
// //                         onPressed: () {},
// //                         child: Text("View Property"),
// //                         style: ElevatedButton.styleFrom(
// //                           backgroundColor: ColorRes.primary.withOpacity(0.1),
// //                           foregroundColor: ColorRes.primary,
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
//
// class AnimatedImageCarousel extends StatefulWidget {
//   const AnimatedImageCarousel({super.key});
//
//   @override
//   State<AnimatedImageCarousel> createState() => _AnimatedImageCarouselState();
// }
//
// class _AnimatedImageCarouselState extends State<AnimatedImageCarousel> {
//   final PageController _pageController = PageController(viewportFraction: 0.7);
//   int _currentPage = 0;
//
//   final List<String> images = [
//     IMGRes.home4,
//     IMGRes.home3,
//     IMGRes.home1,
//     IMGRes.home2,
//   ];
//
//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 150,
//       child: PageView.builder(
//         controller: _pageController,
//         itemCount: images.length,
//         onPageChanged: (index) {
//           setState(() => _currentPage = index);
//         },
//         itemBuilder: (context, index) {
//           final isActive = index == _currentPage;
//
//           return AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             curve: Curves.easeOut,
//             margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
//             child: AnimatedOpacity(
//               duration: const Duration(milliseconds: 300),
//               opacity: isActive ? 1.0 : 0.5,
//               child: AnimatedScale(
//                 scale: isActive ? 1.0 : 0.85,
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeOut,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.asset(
//                     images[index],
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class PropertyCard extends StatelessWidget {
//   final Property property;
//
//   const PropertyCard({Key? key, required this.property}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(right: 10),
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: ColorRes.leadGreyColor[300]!),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Property Image
//           SizedBox(
//             height: 130,
//             child: Padding(
//               padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.asset(
//                         IMGRes.home4,
//                         height: 130,
//                         width: 200,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(width: 8), // spacing between images
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(12),
//                       child: Image.asset(
//                         IMGRes.home3,
//                         height: 130,
//                         width: 200,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//
//           // Content
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Title and Location
//                 Text(
//                   property.name,
//                   style: const TextStyle(
//                     fontSize: AppFontSizes.bodySmall,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.blackShade87,
//                   ),
//                 ),
//                 Text(
//                   property.location,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.caption,
//                     color: ColorRes.leadGreyColor.shade600,
//                   ),
//                 ),
//                 // Rating
//                 SizedBox(height: 4),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       '₹${property.pricePerSqFt}/sq.ft.',
//                       style: const TextStyle(
//                         fontSize: AppFontSizes.small,
//                         fontWeight: AppFontWeights.semiBold,
//                         color: ColorRes.blackShade87,
//                       ),
//                     ),
//                     Row(
//                       children: [
//                         Icon(Icons.star, color: ColorRes.primary, size: 12),
//                         const SizedBox(width: 4),
//                         Text(
//                           property.rating.toString(),
//                           style: const TextStyle(
//                             fontWeight: AppFontWeights.medium,
//                             fontSize: AppFontSizes.small,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 10),
//
//                 // Price Trend Section
//                 Column(
//                   children: [
//                     // Price change indicator
//                     Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: ColorRes.green,
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Icon(
//                                 Icons.trending_up_outlined,
//                                 color: ColorRes.white,
//                                 size: 12,
//                               ),
//                               const SizedBox(width: 2),
//                               Text(
//                                 '${property.priceChangePercent}%',
//                                 style: const TextStyle(
//                                   color: ColorRes.white,
//                                   fontSize: AppFontSizes.extraSmall,
//                                   fontWeight: AppFontWeights.medium,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'in ${property.priceChangePeriod}',
//                           style: TextStyle(
//                             fontSize: AppFontSizes.extraSmall,
//                             color: ColorRes.leadGreyColor.shade600,
//                           ),
//                         ),
//                         const Spacer(),
//                         GestureDetector(
//                           child: Text(
//                             'View price trend',
//                             style: TextStyle(
//                               fontSize: AppFontSizes.extraSmall,
//                               color: ColorRes.primary,
//                               fontWeight: AppFontWeights.medium,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//
//                     // Price Chart
//                     SizedBox(
//                       height: 60,
//                       child: LineChart(
//                         LineChartData(
//                           gridData: FlGridData(show: false),
//                           titlesData: FlTitlesData(show: false),
//                           borderData: FlBorderData(show: false),
//                           lineBarsData: [
//                             LineChartBarData(
//                               spots: property.priceData,
//                               isCurved: true,
//                               color: ColorRes.primary,
//                               barWidth: 2,
//                               isStrokeCapRound: true,
//                               dotData: FlDotData(show: false),
//                               belowBarData: BarAreaData(
//                                 show: true,
//                                 color: ColorRes.primary.withOpacity(0.1),
//                               ),
//                             ),
//                           ],
//                           minX: 0,
//                           maxX: property.priceData.length.toDouble() - 1,
//                           minY:
//                               property.priceData
//                                   .map((e) => e.y)
//                                   .reduce((a, b) => a < b ? a : b) -
//                               1,
//                           maxY:
//                               property.priceData
//                                   .map((e) => e.y)
//                                   .reduce((a, b) => a > b ? a : b) +
//                               1,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//
//                 // Price per sq ft
//
//                 // View Property Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: OutlinedButton(
//                     onPressed: () {},
//                     style: OutlinedButton.styleFrom(
//                       side: BorderSide(color: ColorRes.primary),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: Text(
//                       'View Property',
//                       style: TextStyle(
//                         fontSize: AppFontSizes.extraSmall,
//                         color: ColorRes.primary,
//                         fontWeight: AppFontWeights.semiBold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Custom painter for building illustration
// class BuildingPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint =
//         Paint()
//           ..color = ColorRes.leadGreyColor.shade300
//           ..style = PaintingStyle.fill;
//
//     final windowPaint =
//         Paint()
//           ..color = ColorRes.leadGreyColor.shade500
//           ..style = PaintingStyle.fill;
//
//     // Draw building outline
//     final buildingRect = Rect.fromLTWH(
//       size.width * 0.3,
//       size.height * 0.2,
//       size.width * 0.4,
//       size.height * 0.6,
//     );
//     canvas.drawRect(buildingRect, paint);
//
//     // Draw windows in a grid pattern
//     for (int row = 0; row < 6; row++) {
//       for (int col = 0; col < 4; col++) {
//         final windowRect = Rect.fromLTWH(
//           buildingRect.left + (col + 0.5) * buildingRect.width / 5,
//           buildingRect.top + (row + 1) * buildingRect.height / 8,
//           buildingRect.width / 8,
//           buildingRect.height / 12,
//         );
//         canvas.drawRect(windowRect, windowPaint);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
//
// // Property model
// class Property {
//   final String name;
//   final String location;
//   final double rating;
//   final double priceChangePercent;
//   final String priceChangePeriod;
//   final String pricePerSqFt;
//   final List<FlSpot> priceData;
//
//   Property({
//     required this.name,
//     required this.location,
//     required this.rating,
//     required this.priceChangePercent,
//     required this.priceChangePeriod,
//     required this.pricePerSqFt,
//     required this.priceData,
//   });
// }
//
// // Demo widget with dummy data
// class PropertyListDemo extends StatelessWidget {
//   const PropertyListDemo({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<Property> properties = [
//       Property(
//         name: 'Platinum Heights',
//         location: 'By Patel Nagar, Andheri West Mumbai',
//         rating: 3.7,
//         priceChangePercent: 8.06,
//         priceChangePeriod: '1 yrs',
//         pricePerSqFt: '24,000',
//         priceData: [
//           const FlSpot(0, 20),
//           const FlSpot(1, 19),
//           const FlSpot(2, 21),
//           const FlSpot(3, 20),
//           const FlSpot(4, 22),
//           const FlSpot(5, 24),
//           const FlSpot(6, 26),
//           const FlSpot(7, 25),
//           const FlSpot(8, 27),
//           const FlSpot(9, 28),
//         ],
//       ),
//       Property(
//         name: 'Golden Residency',
//         location: 'Bandra East, Mumbai',
//         rating: 4.2,
//         priceChangePercent: 12.5,
//         priceChangePeriod: '2 yrs',
//         pricePerSqFt: '35,000',
//         priceData: [
//           const FlSpot(0, 28),
//           const FlSpot(1, 29),
//           const FlSpot(2, 31),
//           const FlSpot(3, 30),
//           const FlSpot(4, 32),
//           const FlSpot(5, 33),
//           const FlSpot(6, 35),
//           const FlSpot(7, 34),
//           const FlSpot(8, 36),
//           const FlSpot(9, 37),
//         ],
//       ),
//       Property(
//         name: 'Silver Heights',
//         location: 'Powai, Mumbai',
//         rating: 4.0,
//         priceChangePercent: 6.8,
//         priceChangePeriod: '6 months',
//         pricePerSqFt: '28,500',
//         priceData: [
//           const FlSpot(0, 25),
//           const FlSpot(1, 26),
//           const FlSpot(2, 25),
//           const FlSpot(3, 27),
//           const FlSpot(4, 28),
//           const FlSpot(5, 27),
//           const FlSpot(6, 29),
//           const FlSpot(7, 28),
//           const FlSpot(8, 30),
//           const FlSpot(9, 31),
//         ],
//       ),
//     ];
//
//     return SizedBox(
//       height: 370,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(left: 10),
//         itemCount: properties.length,
//         itemBuilder: (context, index) {
//           return SizedBox(
//             width: 270,
//             child: PropertyCard(property: properties[index]),
//           );
//         },
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/img_res.dart';
import 'package:nesticope_app/data/network/auth/model/user_model.dart';
import 'package:nesticope_app/modules/auth/views/listing_intro_screen.dart';
import 'package:nesticope_app/modules/auth/views/login_screen.dart';
import 'package:nesticope_app/modules/auth/views/onboarding_screen.dart';
import 'package:nesticope_app/modules/auth/views/register_screen.dart';
import 'package:nesticope_app/modules/builder/view/builder_main_screen.dart';
import 'package:nesticope_app/modules/contractor/view/contractor_main.dart';
import 'package:nesticope_app/modules/dashboard/views/seller_dashboard_screen.dart';
import 'package:nesticope_app/modules/reseller/view/property_reseller.dart';
import 'package:nesticope_app/modules/subscription/controller/subscription_controller.dart';
// import 'package:nesticope_app/modules/auth/views/listing_intro_screen.dart';
import 'package:nesticope_app/modules/subscription/views/owner_plans_intro_screen.dart';
import 'package:nesticope_app/modules/subscription/views/builder_plans_intro_screen.dart';
import 'package:nesticope_app/modules/subscription/views/widgets/sign_up_subscription_card.dart';
import '../../../data/database/secure_storage_service.dart';
// 👈 import UserHelper
import '../../../app/constants/app_font_sizes.dart';
import '../../../app/constants/color_res.dart';
import '../../../app/constants/enum.dart';
import '../../../app/utils/helper_function/user_helper/user_helper.dart';

import '../../auth/views/role_convert/convert_to_seller/convert_to_seller.dart';
import '../../auth/views/role_convert/covert_to_reseller/convert_to_reseller.dart';
import '../../contractor/view/widget/convert_to_contractor.dart';
import '../../subscription/views/suscription_plan_screen.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

late SubscriptionPlanController controller;
bool isInquirySubmitted = false;

class _InsightsScreenState extends State<InsightsScreen> {
  @override
  void initState() {
    super.initState();
    // controller = Get.find<SubscriptionPlanController>();
  }

  @override
  Widget build(BuildContext context) {
    // 🔹 Logged-in users flow
    // if (UserHelper.isContractor) {

    //   // return SubscriptionPlansScreen(
    //   //   role: Roles.contractor.name,
    //   //   isShowCurrentPlan: true,
    //   //   isNotFromBuyerSide: false,
    //   //   origin: 'panel',
    //   // );
    //   return ListingIntroScreen(
    //     role: Roles.contractor.name,
    //     showPropertySection: false,
    //     planTitle: "Contractor Plans",

    //     config: ListingIntroConfig(
    //       contractorStrategyTitle:
    //           'Skyrocket Your Business as a NesticoPe Contractor',
    //       contractorStrategySubtitle:
    //           'Strategic steps to scale your construction business with our platform',
    //       contractorStrategySteps: const [
    //         FeatureItemData(
    //           Icons.search,
    //           'Identify Local Demand',
    //           'Use our data insights to find high-demand localities in your expertise.',
    //         ),
    //         FeatureItemData(
    //           Icons.bar_chart,
    //           'Optimize Your Profile',
    //           'Showcase your best projects and gather verified reviews for higher visibility.',
    //         ),
    //         FeatureItemData(
    //           Icons.rocket_launch,
    //           'Leverage Technology',
    //           'Use our advanced management tools to streamline your operations and sales.',
    //         ),
    //       ],
    //       contractorBenefitsTitle: 'Empowering Your Construction Business',
    //       contractorBenefitsSubtitle:
    //           'At NesticoPe, we provide a holistic platform for contractors. We offer buyers a complete property solution—from initial searching and legal vetting to high-quality construction and interior design. This integrated approach ensures a steady flow of verified projects for our partners, creating a massive opportunity for everyone to scale their business with trust and technology.',
    //       contractorBenefits: const [
    //         FeatureItemData(
    //           Icons.trending_up,
    //           'Complete Project Ecosystem',
    //           'We offer buyers everything—from property search and legal work to construction and interior design. You are part of a full-service journey.',
    //         ),
    //         FeatureItemData(
    //           Icons.business,
    //           'Verified High-Intent Leads',
    //           'Access a steady stream of verified construction and renovation inquiries from buyers already engaged in our property ecosystem.',
    //         ),
    //         FeatureItemData(
    //           Icons.verified,
    //           'Brand Authority',
    //           'Build a verified professional contractor profile that establishes immediate trust with property owners and large-scale developers.',
    //         ),
    //         FeatureItemData(
    //           Icons.construction,
    //           'Advanced Digital Tools',
    //           'Manage projects, track site visits, and showcase your portfolio with our enterprise-grade contractor dashboard.',
    //         ),
    //         FeatureItemData(
    //           Icons.location_city,
    //           'Premium Networking',
    //           'Connect with top builders and developers for high-value commercial and residential construction opportunities.',
    //         ),
    //         FeatureItemData(
    //           Icons.handshake,
    //           'Unmatched Growth Support',
    //           'Scale your construction business with 24/7 dedicated support and specialized marketing solutions for elite contractors.',
    //         ),
    //       ],
    //       logoAsset: 'assets/images/NesticoPe_logo.png',
    //       appBarBrand: 'NesticoPe',
    //       badgeText: 'New Feature',

    //       headline: 'Build Your Legacy',
    //       highlightWord: 'With NesticoPe',
    //       subHeadline:
    //           'Grow your business with verified leads and professional tools.',
    //       primaryCta: 'Sign Up as Contractor',
    //       sellWithTitle: 'What NesticoPe Expects from You',
    //       sellWithSubtitle:
    //           'We maintain the highest standards to ensure quality and trust in our ecosystem.',
    //       manageTitle: 'Already have services?',
    //       manageSubtitle:
    //           'Boost visibility and manage your services from one place.',
    //       manageButtonText: 'Manage Services',
    //       premiumTitle: 'Featured Contractors',
    //       premiumActionText: 'View All',
    //       stepsTitle: 'How It Works?',
    //       viewPlansTitle: 'Find the Perfect Plan for You',
    //       viewPlansSubtitle:
    //           'Choose from premium plans to maximize your reach and brand visibility.',
    //       viewPlansButtonText: 'View Plans',
    //       stats: const [
    //         StatItemData('₹100Cr+', 'Projects Completed'),
    //         StatItemData('800+', 'Active Projects'),
    //         StatItemData('300+', 'Verified Contractors'),
    //       ],
    //       features: const [
    //         FeatureItemData(
    //           Icons.security_outlined,
    //           'No Spam Policy',
    //           '''We value our buyers' privacy. Only meaningful interactions are encouraged.''',
    //         ),
    //         FeatureItemData(
    //           Icons.high_quality_outlined,
    //           'Quality Over Quantity',
    //           'We prioritize exceptional craftsmanship over the number of projects handled.',
    //         ),
    //         FeatureItemData(
    //           Icons.verified_outlined,
    //           'Verified Professionals Only',
    //           'Every contractor must pass a thorough verification process for trust.',
    //         ),
    //         // FeatureItemData(
    //         //   Icons.support_agent_outlined,
    //         //   'Direct Support',
    //         //   'Dedicated support for project management and updates.',
    //         // ),
    //       ],
    //       premiumListings: const [
    //         PremiumListingItem(
    //           imageAsset: IMGRes.home2,
    //           title: 'Skyline Apartments',
    //           subtitle: 'Downtown, NYC',
    //           priceText: '₹45,00,000',
    //         ),
    //         PremiumListingItem(
    //           imageAsset: IMGRes.project_2,
    //           title: 'Greenview Residency',
    //           subtitle: 'Udhna, Surat',
    //           priceText: '₹1,20,00,000',
    //         ),
    //       ],
    //       steps: const [
    //         HowStep(
    //           'Register & Profile',
    //           'Complete your professional registration and get verified.',
    //         ),
    //         HowStep(
    //           'Add Your Services',
    //           'List your specialized construction services and expertise.',
    //         ),
    //         HowStep(
    //           'Get Quality Leads',
    //           'Receive inquiries from interested clients.',
    //         ),
    //         HowStep(
    //           'Start Project',
    //           'Connect with clients and start your construction work.',
    //         ),
    //         HowStep(
    //           'High Earnings',
    //           'Grow your business and maximize your revenue with us.',
    //         ),
    //       ],
    //       plansForm: const PlansFormConfig(
    //         pillText: 'Pricing',
    //         title: 'Contractor Premium Plans',
    //         subtitle: 'Get featured and grow your service business',
    //         buttonText: 'Unlock Contractor Plans',
    //       ),
    //       finalCallout: const FinalCalloutConfig(
    //         headline: "Ready to Build Your Legacy?",
    //         points: [
    //           '300+ Verified Contractors',
    //           '₹100Cr+ Projects Value',
    //           '24/7 Expert Support',
    //         ],
    //         cta: 'Start Your Journey Now',
    //       ),
    //     ),
    //     onPrimaryCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => ConvertToContractorConversionScreen());

    //       } else if (UserHelper.isContractor) {
    //         Get.to(() => ContractorMainScreen());
    //       }
    //     }, // Post Property Free
    //     onManageListings: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => ConvertToContractorConversionScreen());
    //       } else if (UserHelper.isContractor) {
    //         Get.to(() => ContractorMainScreen());
    //       }
    //     }, // Manage Listings
    //     onUnlockPlans: () async {
    //       Get.to(
    //         () => SubscriptionPlansScreen(
    //           role: Roles.contractor.name,
    //           isNotFromBuyerSide: false,

    //           origin: 'buyer',
    //         ),
    //       );
    //     }, // Unlock Owner Plans
    //     onFinalCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => ConvertToContractorConversionScreen());
    //       } else if (UserHelper.isContractor) {
    //         Get.to(() => ContractorMainScreen());
    //       }
    //     }, // Final CTA
    //   );
    // } else if (UserHelper.isSellerOwner) {
    //   // return SubscriptionPlansScreen(
    //   //   role: Roles.sellerOwner.name,
    //   //   isShowCurrentPlan: true,

    //   //   isNotFromBuyerSide: false,
    //   //   origin: 'panel',
    //   // );
    //   return ListingIntroScreen(
    //     role: Roles.sellerOwner.name,
    //     planTitle: "Seller Plans",
    //     config: ListingIntroConfig(
    //       logoAsset: 'assets/images/NesticoPe_logo.png',
    //       appBarBrand: 'NesticoPe',
    //       badgeText: 'New Feature',
    //       headline: 'Sell Your Property',
    //       highlightWord: 'Faster',
    //       subHeadline:
    //           'Post your property for free and reach thousands of verified buyers instantly.',
    //       primaryCta: 'Post Property Free',
    //       sellWithTitle: 'Sell With NesticoPe',
    //       sellWithSubtitle:
    //           'We provide the tools and reach you need to sell your property at the best price.',
    //       manageTitle: 'Already have a listing?',
    //       manageSubtitle:
    //           'Boost your listing to the top of search results and sell 3x faster.',
    //       manageButtonText: 'Manage Listings',
    //       premiumTitle: 'Premium Listings',
    //       premiumActionText: 'View All',
    //       stepsTitle: 'How It Works?',
    //       viewPlansTitle: 'Find the Perfect Plan for You',
    //       viewPlansSubtitle:
    //           'Choose from our range of premium plans designed to get your property sold faster with maximum exposure.',
    //       viewPlansButtonText: 'View Plans',
    //       stats: const [
    //         StatItemData('10k+', 'Active Buyers'),
    //         StatItemData('5k+', 'Properties Sold'),
    //         StatItemData('0%', 'Commission'),
    //       ],
    //       features: const [
    //         FeatureItemData(
    //           Icons.camera_alt_outlined,
    //           'Free Listing',
    //           'Unlimited images and videos for free.',
    //         ),
    //         FeatureItemData(
    //           Icons.visibility_outlined,
    //           'More Visibility',
    //           'Get 10x more reach than traditional brokers.',
    //         ),
    //         FeatureItemData(
    //           Icons.support_agent_outlined,
    //           'NesticoPe Support',
    //           '24/7 dedicated assistance for your listing.',
    //         ),
    //         FeatureItemData(
    //           Icons.verified_outlined,
    //           'Serious Enquiries',
    //           'Verified buyers screened for intent.',
    //         ),
    //       ],
    //       premiumListings: const [
    //         PremiumListingItem(
    //           imageAsset: IMGRes.home2,
    //           title: 'Skyline Apartments',
    //           subtitle: 'Downtown, NYC',
    //           priceText: '₹45,00,000',
    //         ),
    //         PremiumListingItem(
    //           imageAsset: IMGRes.project_2,
    //           title: 'Greenview Residency',
    //           subtitle: 'Udhna, Surat',
    //           priceText: '₹1,20,00,000',
    //         ),
    //       ],
    //       steps: const [
    //         HowStep(
    //           'Post Property',
    //           'Add photos and details of your property.',
    //         ),
    //         HowStep(
    //           'Get Verified',
    //           'Our team will verify the listing for authenticity.',
    //         ),
    //         HowStep(
    //           'Receive Inquiries',
    //           'Interact with genuine and verified buyers.',
    //         ),
    //         HowStep(
    //           'Close the Deal',
    //           'Finalize the sale with zero brokerage fees.',
    //         ),
    //       ],
    //       plansForm: const PlansFormConfig(
    //         pillText: 'Pricing',
    //         title: 'Owner Premium Plans',
    //         subtitle: 'Get featured, sell 3x faster with priority support',
    //         buttonText: 'Unlock Owner Plans',
    //       ),
    //       finalCallout: const FinalCalloutConfig(
    //         headline: "Still Waiting? Your Buyer Isn’t!",
    //         points: [
    //           '2 Min Fast Posting',
    //           '0% Brokerage',
    //           'Unlimited Visibility',
    //         ],
    //         cta: 'Start Your Free Listing',
    //       ),
    //     ),
    //     onPrimaryCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerConversionScreen());
    //       } else if (UserHelper.isSellerOwner) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerDashboardScreen());
    //       }
    //     }, // Post Property Free
    //     onManageListings: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerConversionScreen());
    //       } else if (UserHelper.isSellerOwner) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerDashboardScreen());
    //       }
    //     }, // Manage Listings
    //     onUnlockPlans: () async {
    //       Get.to(
    //         () => SubscriptionPlansScreen(
    //           role: Roles.sellerOwner.name,

    //           origin: 'buyer',
    //           isNotFromBuyerSide: false,
    //         ),
    //       );
    //     }, // Unlock Owner Plans
    //     onFinalCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerConversionScreen());
    //       } else if (UserHelper.isSellerOwner) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerDashboardScreen());
    //       }
    //     }, // Final CTA
    //   );
    // } else if (UserHelper.isSellerBuilder) {
    //   print('sdfsdf df ddfsd sdf sdfgsd Builder role');
    //   // return SubscriptionPlansScreen(
    //   //   role: Roles.sellerBuilder.name,
    //   //   isShowCurrentPlan: true,
    //   //   isNotFromBuyerSide: false,
    //   //   origin: 'panel',
    //   // );
    //   return ListingIntroScreen(
    //     role: Roles.sellerBuilder.name,
    //     planTitle: "Builder Plans",
    //     isBulletPoint: true,
    //     config: ListingIntroConfig(
    //       logoAsset: 'assets/images/NesticoPe_logo.png',
    //       appBarBrand: 'NesticoPe',
    //       badgeText: 'New Feature',

    //       headline: 'Scale Your Real Estate',
    //       highlightWord: 'Vision',
    //       subHeadline:
    //           'The most powerful ecosystem for developers to showcase projects and manage inventory.',
    //       primaryCta: 'Register as Builder',
    //       sellWithTitle: 'Developer Solutions',
    //       sellWithSubtitle:
    //           'Designed for large scale projects and high-volume sales management.',
    //       manageTitle: 'Already have projects?',
    //       manageSubtitle: 'Boost visibility and manage leads from one place.',
    //       manageButtonText: 'Manage Projects',
    //       premiumTitle: 'Featured Projects',
    //       premiumActionText: 'View All',
    //       stepsTitle: 'Sell with NesticoPe',
    //       viewPlansTitle: 'Find the Perfect Plan for You',
    //       viewPlansSubtitle:
    //           'Choose from premium plans to maximize reach and brand visibility.',
    //       viewPlansButtonText: 'View Plans',
    //       stats: const [
    //         StatItemData('500+', 'Projects Listed'),
    //         StatItemData('50k+', 'Monthly Leads'),
    //         StatItemData('100+', 'Top Developers'),
    //       ],
    //       features: const [
    //         FeatureItemData(
    //           Icons.photo_library_outlined,
    //           'Project Showcase',
    //           'Feature your entire project portfolio with dedicated galleries and virtual tours.',
    //         ),
    //         FeatureItemData(
    //           Icons.people_outlined,
    //           'Bulk Lead Generation',
    //           'Get high-intent corporate and individual leads specifically for your developments.',
    //         ),
    //         FeatureItemData(
    //           Icons.verified_outlined,
    //           'Developer Authority',
    //           'Build brand presence with a premium verified builder profile and RERA badges.',
    //         ),
    //         FeatureItemData(
    //           Icons.support_agent_outlined,
    //           'Enterprise Support',
    //           'Dedicated account managers for seamless project management and updates.',
    //         ),
    //       ],
    //       premiumListings: const [
    //         PremiumListingItem(
    //           imageAsset: IMGRes.home2,
    //           title: 'Skyline Apartments',
    //           subtitle: 'Downtown, NYC',
    //           priceText: '₹45,00,000',
    //         ),
    //         PremiumListingItem(
    //           imageAsset: IMGRes.project_2,
    //           title: 'Greenview Residency',
    //           subtitle: 'Udhna, Surat',
    //           priceText: '₹1,20,00,000',
    //         ),
    //       ],
    //       steps: const [
    //         HowStep(
    //           'Massive Buyer Network',
    //           'Instant access to over 10,000+ active property seekers.',
    //         ),
    //         HowStep(
    //           'NesticoPe Premium Support',
    //           'Get dedicated support for project promotion and strategic marketing to boost your sales.',
    //         ),
    //         HowStep(
    //           'Advanced CRM Tools',
    //           'Manage your leads, site visits, and inventory from a single dashboard.',
    //         ),
    //         HowStep(
    //           'Brand Authority',
    //           'Get a verified builder profile that builds immediate trust with investors.',
    //         ),
    //       ],
    //       plansForm: const PlansFormConfig(
    //         pillText: 'Pricing',
    //         title: 'Owner Premium Plans',
    //         subtitle: 'Get featured, sell 3x faster with priority support',
    //         buttonText: 'Unlock Owner Plans',
    //       ),
    //       finalCallout: const FinalCalloutConfig(
    //         headline: "Scale Your Construction Business Today!",
    //         points: ['500+ Active Builders', '10k+ Units Sold', '24/7 Support'],
    //         cta: 'Register Now',
    //       ),
    //     ),
    //     onPrimaryCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerConversionScreen());
    //       } else if (UserHelper.isSellerBuilder) {
    //         Get.to(() => BuilderMainScreen());
    //         // return;
    //       }
    //     }, // Post Property Free
    //     onManageListings: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerConversionScreen());
    //       } else if (UserHelper.isSellerBuilder) {
    //         Get.to(() => BuilderMainScreen());
    //         // return;
    //       }
    //     }, // Manage Listings
    //     onUnlockPlans: () async {
    //       Get.to(
    //         () => SubscriptionPlansScreen(
    //           role: Roles.sellerBuilder.name,

    //           isNotFromBuyerSide: false,
    //           origin: 'buyer',
    //         ),
    //       );
    //     }, // Unlock Owner Plans
    //     onFinalCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => SellerConversionScreen());
    //       } else if (UserHelper.isSellerBuilder) {
    //         Get.to(() => BuilderMainScreen());
    //         // return;
    //       }
    //     }, // Final CTA
    //   );
    // } else if (UserHelper.isReseller) {
    //   print('sdfsdf df ddfsd sdf sdfgsd Reseller role');
    //   // return SubscriptionPlansScreen(
    //   //   role: Roles.reseller.name,
    //   //   isShowCurrentPlan: true,
    //   //   origin: 'panel',
    //   //   isNotFromBuyerSide: false,
    //   // );
    //   return ListingIntroScreen(
    //     role: Roles.reseller.name,
    //     planTitle: "Partner Plans",
    //     isBulletPoint: true,
    //     config: ListingIntroConfig(
    //       logoAsset: 'assets/images/NesticoPe_logo.png',
    //       appBarBrand: 'NesticoPe',
    //       badgeText: 'New Feature',

    //       headline: '''India's Ultimate Property''',
    //       highlightWord: 'Growth Engine',
    //       subHeadline:
    //           'Join the elite network of property experts and unlock unprecedented growth today.',
    //       primaryCta: 'Sign Up as Partner',
    //       sellWithTitle: 'How You Can Earn?',
    //       sellWithSubtitle:
    //           'Simple 4-step process to start your real estate business with zero investment',
    //       manageTitle: 'Already have a partner account?',
    //       manageSubtitle: 'Boost visibility and manage leads from one place.',
    //       manageButtonText: 'Manage Account',
    //       premiumTitle: 'Featured Projects',
    //       premiumActionText: 'View All',
    //       stepsTitle: 'Why Become a NesticoPe Partner?',
    //       viewPlansTitle: 'Find the Perfect Plan for You',
    //       viewPlansSubtitle:
    //           'Choose from premium plans to maximize your partner visibility.',

    //       viewPlansButtonText: 'View Plans',
    //       stats: const [
    //         StatItemData('50L+', 'Commission Paid'),
    //         StatItemData('1000+', 'Properties Sold'),
    //         StatItemData('500+', 'Active Partners'),
    //       ],
    //       features: const [
    //         FeatureItemData(
    //           Icons.person_add_outlined,
    //           'Register & Join',
    //           'Create your partner profile and get verified in minutes.',
    //         ),
    //         FeatureItemData(
    //           Icons.search_off_sharp,
    //           'Access Inventory',
    //           'Browse thousands of verified properties and projects.',
    //         ),
    //         FeatureItemData(
    //           Icons.share_outlined,
    //           'Share & Connect',
    //           'Share personalized property links with your potential buyers.',
    //         ),
    //         FeatureItemData(
    //           Icons.attach_money_outlined,
    //           'Earn Commission',
    //           'Receive direct payouts when your clients close a deal.',
    //         ),
    //       ],
    //       premiumListings: const [
    //         PremiumListingItem(
    //           imageAsset: IMGRes.home2,
    //           title: 'Skyline Apartments',
    //           subtitle: 'Downtown, NYC',
    //           priceText: '₹45,00,000',
    //         ),
    //         PremiumListingItem(
    //           imageAsset: IMGRes.project_2,
    //           title: 'Greenview Residency',
    //           subtitle: 'Udhna, Surat',
    //           priceText: '₹1,20,00,000',
    //         ),
    //       ],
    //       steps: const [
    //         HowStep(
    //           'High Commission',
    //           'Earn up to 2% on every successful deal.',
    //         ),
    //         HowStep(
    //           'Trusted Network',
    //           'Partner with verified builders & owners.',
    //         ),
    //         HowStep('Premium Support', '24/7 dedicated support team.'),
    //         HowStep(
    //           'Quality Listings',
    //           'Access to verified property listings.',
    //         ),
    //         HowStep(
    //           'Gamified Dashboard',
    //           'Track your earnings and progress seamlessly.',
    //         ),
    //         HowStep(
    //           'Special Incentives',
    //           'Earn bonuses and extra rewards for your performance.',
    //         ),
    //       ],
    //       plansForm: const PlansFormConfig(
    //         pillText: 'Pricing',
    //         title: 'Owner Premium Plans',
    //         subtitle: 'Get featured, sell 3x faster with priority support',
    //         buttonText: 'Unlock Owner Plans',
    //       ),
    //       finalCallout: const FinalCalloutConfig(
    //         headline: "Ready to Scale Your Earning?",
    //         points: [
    //           '500+ Active Partners',
    //           '₹50L+ Comm. Paid',
    //           '24/7 Partner Support',
    //         ],
    //         cta: 'Start Your Journey Now',
    //       ),
    //     ),
    //     onPrimaryCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => ResellerConversionScreen());
    //       } else if (UserHelper.isReseller) {
    //         Get.to(() => MainNavigationScreen());
    //       }
    //     }, // Post Property Free
    //     onManageListings: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => ResellerConversionScreen());
    //       } else if (UserHelper.isReseller) {
    //         Get.to(() => MainNavigationScreen());
    //       }
    //     }, // Manage Listings
    //     onUnlockPlans: () async {
    //       Get.to(
    //         () => SubscriptionPlansScreen(
    //           isNotFromBuyerSide: false,
    //           role: Roles.reseller.name,

    //           origin: 'buyer',
    //         ),
    //       );
    //     }, // Unlock Owner Plans
    //     onFinalCta: () {
    //       if (UserHelper.isGuest) {
    //         Navigator.of(context).pop();
    //         Get.to(() => LoginScreen());
    //       } else if (UserHelper.isBuyer) {
    //         // Get.to(() => ManageListingsScreen());
    //         Get.to(() => ResellerConversionScreen());
    //       } else if (UserHelper.isReseller) {
    //         Get.to(() => MainNavigationScreen());
    //       }
    //     }, // Final CTA
    //   );
    // }
    // else if (UserHelper.isBuyer) {
    //   return BuyerConversionScreen();
    // }

    // 🔹 Guest user flow → Show role selection tiles
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xffF2F3EE), // deep navy
          ),
        ),

        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 300,
          child: ShaderMask(
            shaderCallback:
                (rect) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.white.withOpacity(0.5), Colors.transparent],
                  stops: [0.4, 1.0],
                ).createShader(rect),
            blendMode: BlendMode.dstIn,
            child: Image.asset(
              'assets/images/moder_villa.png',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),

        // Subtle dot pattern overlay
        Positioned.fill(
          child: CustomPaint(painter: DotPatternForRolePainter()),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ), // space for the image

                    Text(
                      'Choose your role\nto continue',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Select a role to view subscription plans\nand get started.',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.70),
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: 32),

                    _buildGuestRoleTile(
                      title: "Seller (Owner) Plans",
                      subtitle: "List and sell your property",
                      icon: Icons.home_work_outlined,
                      iconColor: ColorRes.primary,
                      iconBgColor: ColorRes.primary.withOpacity(0.05),
                      onTap: () async {
                        // Get.to(() => const OwnerPlansIntroScreen());
                        Get.to(
                          () => ListingIntroScreen(
                            role: Roles.sellerOwner.name,
                            planTitle: "Seller Plans",
                            config: ListingIntroConfig(
                              logoAsset: 'assets/images/NesticoPe_logo.png',
                              appBarBrand: 'NesticoPe',
                              badgeText: 'New Feature',
                              headline: 'Sell Your Property',
                              highlightWord: 'Faster with NesticoPe',
                              subHeadline:
                                  'Post your property for FREE and reach thousands of verified buyers directly. No brokers, no hidden fees, only pure success.',
                              primaryCta: 'Post Property Free',
                              sellWithTitle: 'Sell With NesticoPe',
                              sellWithSubtitle:
                                  'We provide the tools and reach you need to sell your property at the best price.',
                              manageTitle: 'Already have a listing?',
                              manageSubtitle:
                                  'Boost your listing to the top of search results and sell 3x faster.',
                              manageButtonText: 'Manage Listings',
                              premiumTitle: 'Premium Listings',
                              premiumActionText: 'View All',
                              stepsTitle: 'How It Works?',
                              viewPlansTitle: 'Find the Perfect Plan for You',
                              viewPlansSubtitle:
                                  'Choose from our range of premium plans designed to get your property sold faster with maximum exposure.',
                              viewPlansButtonText: 'Explore Plans',
                              stats: const [
                                StatItemData('Growing', 'Active Buyers'),
                                StatItemData('Massive', 'Monthly Leads'),
                                StatItemData('Trusted', 'Top Sellers'),
                              ],
                              features: const [
                                FeatureItemData(
                                  Icons.camera_alt_outlined,
                                  'Free Listing',
                                  'List your property for free and reach thousands of buyers without any cost .',
                                ),
                                FeatureItemData(
                                  Icons.visibility_outlined,
                                  'More Visibility',
                                  'Get your property in front of thousands of active buyers every day.',
                                ),
                                FeatureItemData(
                                  Icons.support_agent_outlined,
                                  'NesticoPe Support',
                                  'Dedicated relationship managers to help you list and sell.',
                                ),
                                FeatureItemData(
                                  Icons.verified_outlined,
                                  'Serious Enquiries',
                                  'Build trust with buyers and receive enquiries from verified, serious buyers.',
                                ),
                              ],
                              premiumListings: const [
                                PremiumListingItem(
                                  imageAsset: IMGRes.home2,
                                  title: 'Skyline Apartments',
                                  subtitle: 'Downtown, NYC',
                                  priceText: '₹45,00,000',
                                ),
                                PremiumListingItem(
                                  imageAsset: IMGRes.project_2,
                                  title: 'Greenview Residency',
                                  subtitle: 'Udhna, Surat',
                                  priceText: '₹1,20,00,000',
                                ),
                              ],
                              steps: const [
                                HowStep(
                                  'Post Property',
                                  'Enter basic details and upload high-quality photos in just few minutes.',
                                ),
                                HowStep(
                                  'Get Verified',
                                  'Our team verifies your listing to build trust with potential buyers.',
                                ),
                                HowStep(
                                  'Receive Inquiries',
                                  'Buyers will contact you directly via call or message through our platform.',
                                ),
                                HowStep(
                                  'Close the Deal',
                                  'Negotiate directly and sell your property with zero brokerage fees.',
                                ),
                              ],
                              plansForm: const PlansFormConfig(
                                pillText: 'Pricing',
                                title: 'Owner Premium Plans',
                                subtitle:
                                    'Get featured, sell 3x faster with priority support',
                                buttonText: 'Unlock Owner Plans',
                              ),
                              finalCallout: const FinalCalloutConfig(
                                headline: "Still Waiting? Your Buyer Isn’t!",
                                points: [
                                  'Quick Fast Posting',
                                  'Zero Brokerage',
                                  'Unlimited Visibility',
                                ],
                                cta: 'Start Your Free Listing',
                              ),
                            ),
                            onPrimaryCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerOwner) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerDashboardScreen());
                              }
                            }, // Post Property Free
                            onManageListings: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerOwner) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerDashboardScreen());
                              }
                            }, // Manage Listings
                            onBecomeType: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerOwner) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerDashboardScreen());
                              }
                            },

                            onUnlockPlans: () async {
                              // Get.to(
                              //   () => SubscriptionPlansScreen(
                              //     role: Roles.sellerOwner.name,

                              //     origin: 'buyer',
                              //     isNotFromBuyerSide: false,
                              //   ),
                              // );
                              final data =
                                  await SecureStorage.hasSubscriptionInquiryForUser(
                                    Roles.sellerOwner.name,
                                    userId:
                                        (await SecureStorage.getClientId()) ??
                                        '',
                                    role: Roles.sellerOwner.name,
                                  );
                              debugPrint(
                                "Has Subscription Inquiry For : $data",
                              );
                              Get.to(
                                () => SubscriptionPlansScreen(
                                  role: Roles.sellerOwner.name,
                                  isInquirySubmitted: data,
                                  origin: 'buyer',
                                  isNotFromBuyerSide: false,
                                ),
                              );
                            }, // Unlock Owner Plans

                            onFinalCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerOwner) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerDashboardScreen());
                              }
                            }, // Final CTA
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    _buildGuestRoleTile(
                      title: "Seller (Builder) Plans",
                      subtitle: "Showcase your projects",
                      icon: Icons.apartment_outlined,
                      iconColor: ColorRes.primary,
                      iconBgColor: ColorRes.primary.withOpacity(0.05),
                      onTap: () async {
                        // Get.to(() => const BuilderPlansIntroScreen());
                        Get.to(
                          () => ListingIntroScreen(
                            role: Roles.sellerBuilder.name,
                            planTitle: "Builder Plans",
                            isBulletPoint: true,
                            config: ListingIntroConfig(
                              logoAsset: 'assets/images/NesticoPe_logo.png',
                              appBarBrand: 'NesticoPe',
                              badgeText: 'New Feature',

                              headline: 'Showcase Your Projects',
                              highlightWord: 'with NesticoPe',
                              subHeadline:
                                  'Elevate your construction brand and reach thousands of verified property seekers with our specialized developer solutions.',
                              primaryCta: 'Register as Builder',
                              sellWithTitle: 'Developer Solutions',
                              sellWithSubtitle:
                                  'Designed for large scale projects and high-volume sales management.',
                              manageTitle: 'Already have projects?',
                              manageSubtitle:
                                  'Boost visibility and manage leads from one place.',
                              manageButtonText: 'Manage Projects',
                              premiumTitle: 'Featured Projects',
                              premiumActionText: 'View All',
                              stepsTitle: 'Sell with NesticoPe',
                              viewPlansTitle: 'Find the Perfect Plan for You',
                              viewPlansSubtitle:
                                  'Choose from premium plans to maximize reach and brand visibility.',
                              viewPlansButtonText: 'Explore Plans',
                              stats: const [
                                StatItemData('Growing', 'Projects Listed'),
                                StatItemData('Massive', 'Monthly Leads'),
                                StatItemData('Trusted', 'Top Developers'),
                              ],
                              features: const [
                                FeatureItemData(
                                  Icons.photo_library_outlined,
                                  'Project Showcase',
                                  'Feature your entire project portfolio with dedicated galleries and virtual tours.',
                                ),
                                FeatureItemData(
                                  Icons.people_outlined,
                                  'Bulk Lead Generation',
                                  'Get high-intent corporate and individual leads specifically for your developments.',
                                ),
                                FeatureItemData(
                                  Icons.verified_outlined,
                                  'Developer Authority',
                                  'Build brand presence with a premium verified builder profile and RERA badges.',
                                ),
                                FeatureItemData(
                                  Icons.support_agent_outlined,
                                  'Enterprise Support',
                                  'Dedicated account managers for seamless project management and updates.',
                                ),
                              ],
                              premiumListings: const [
                                PremiumListingItem(
                                  imageAsset: IMGRes.home2,
                                  title: 'Skyline Apartments',
                                  subtitle: 'Downtown, NYC',
                                  priceText: '₹45,00,000',
                                ),
                                PremiumListingItem(
                                  imageAsset: IMGRes.project_2,
                                  title: 'Greenview Residency',
                                  subtitle: 'Udhna, Surat',
                                  priceText: '₹1,20,00,000',
                                ),
                              ],
                              steps: const [
                                HowStep(
                                  'Massive Buyer Network',
                                  'Instant access to over 10,000+ active property seekers.',
                                ),
                                HowStep(
                                  'NesticoPe Premium Support',
                                  'Get dedicated support for project promotion and strategic marketing to boost your sales.',
                                ),
                                HowStep(
                                  'Advanced CRM Tools',
                                  'Manage your leads, site visits, and inventory from a single dashboard.',
                                ),
                                HowStep(
                                  'Brand Authority',
                                  'Get a verified builder profile that builds immediate trust with investors.',
                                ),
                              ],
                              plansForm: const PlansFormConfig(
                                pillText: 'Pricing',
                                title: 'Owner Premium Plans',
                                subtitle:
                                    'Get featured, sell 3x faster with priority support',
                                buttonText: 'Unlock Owner Plans',
                              ),
                              finalCallout: const FinalCalloutConfig(
                                headline:
                                    "Scale Your Construction Business Today!",
                                points: [
                                  'Large Active Builders',
                                  'Proven Units Sold',
                                  'Constant Support',
                                ],
                                cta: 'Register Now',
                              ),
                            ),
                            onPrimaryCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerBuilder) {
                                Get.to(() => BuilderMainScreen());
                                // return;
                              }
                            }, // Post Property Free
                            onBecomeType: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerBuilder) {
                                Get.to(() => BuilderMainScreen());
                                // return;
                              }
                            },
                            onManageListings: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerBuilder) {
                                Get.to(() => BuilderMainScreen());
                                // return;
                              }
                            }, // Manage Listings
                            onUnlockPlans: () async {
                              // Get.to(
                              //   () => SubscriptionPlansScreen(
                              //     role: Roles.sellerBuilder.name,

                              //     isNotFromBuyerSide: false,
                              //     origin: 'buyer',
                              //   ),
                              // );
                              final data =
                                  await SecureStorage.hasSubscriptionInquiryForUser(
                                    Roles.sellerBuilder.name,
                                    userId:
                                        (await SecureStorage.getClientId()) ??
                                        '',
                                    role: Roles.sellerBuilder.name,
                                  );
                              debugPrint(
                                "Has Subscription Inquiry For : $data",
                              );
                              Get.to(
                                () => SubscriptionPlansScreen(
                                  role: Roles.sellerBuilder.name,
                                  isInquirySubmitted: data,
                                  isNotFromBuyerSide: false,
                                  origin: 'buyer',
                                ),
                              );
                            }, // Unlock Owner Plans
                            onFinalCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.seller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => SellerConversionScreen());
                              } else if (UserHelper.isSellerBuilder) {
                                Get.to(() => BuilderMainScreen());
                                // return;
                              }
                            }, // Final CTA
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    _buildGuestRoleTile(
                      title: "Partner Plans",
                      subtitle: "Join our partners program",
                      icon: Icons.handshake_outlined,
                      iconColor: ColorRes.primary,
                      iconBgColor: ColorRes.primary.withOpacity(0.05),
                      onTap: () async {
                        Get.to(
                          () => ListingIntroScreen(
                            role: Roles.reseller.name,
                            planTitle: "Partner Plans",
                            isBulletPoint: true,
                            config: ListingIntroConfig(
                              logoAsset: 'assets/images/NesticoPe_logo.png',
                              appBarBrand: 'NesticoPe',
                              badgeText: 'New Feature',

                              headline: '''Start Your Real Estate''',
                              highlightWord: 'Journey With Us',
                              subHeadline:
                                  'Unlock endless possibilities in the property market with our advanced platform and verified inventory.',
                              primaryCta: 'Sign Up as Partner',
                              sellWithTitle: 'How You Can Earn?',
                              sellWithSubtitle:
                                  'Simple 4-step process to start your real estate business with zero investment',
                              manageTitle: 'Already have a partner account?',
                              manageSubtitle:
                                  'Boost visibility and manage leads from one place.',
                              manageButtonText: 'Manage Account',
                              premiumTitle: 'Featured Projects',
                              premiumActionText: 'View All',
                              stepsTitle: 'Why Become a NesticoPe Partner?',
                              viewPlansTitle: 'Find the Perfect Plan for You',
                              viewPlansSubtitle:
                                  'Choose from premium plans to maximize your partner visibility.',

                              viewPlansButtonText: 'Explore Plans',
                              stats: const [
                                StatItemData('High', 'Commission Payouts'),
                                StatItemData(
                                  'Rapidly Growing',
                                  'Property Sales',
                                ),
                                StatItemData('Expanding', 'Partner Network'),
                              ],
                              features: const [
                                FeatureItemData(
                                  Icons.person_add_outlined,
                                  'Register & Join',
                                  'Create your partner profile and get verified in minutes.',
                                ),
                                FeatureItemData(
                                  Icons.search_off_sharp,
                                  'Access Inventory',
                                  'Browse thousands of verified properties and projects.',
                                ),
                                FeatureItemData(
                                  Icons.share_outlined,
                                  'Share & Connect',
                                  'Share personalized property links with your potential buyers.',
                                ),
                                FeatureItemData(
                                  Icons.attach_money_outlined,
                                  'Earn Commission',
                                  'Receive direct payouts when your clients close a deal.',
                                ),
                              ],
                              premiumListings: const [
                                PremiumListingItem(
                                  imageAsset: IMGRes.home2,
                                  title: 'Skyline Apartments',
                                  subtitle: 'Downtown, NYC',
                                  priceText: '₹45,00,000',
                                ),
                                PremiumListingItem(
                                  imageAsset: IMGRes.project_2,
                                  title: 'Greenview Residency',
                                  subtitle: 'Udhna, Surat',
                                  priceText: '₹1,20,00,000',
                                ),
                              ],
                              steps: const [
                                HowStep(
                                  'High Commission',
                                  'Earn up to 2% on every successful deal.',
                                ),
                                HowStep(
                                  'Trusted Network',
                                  'Partner with verified builders & owners.',
                                ),
                                HowStep(
                                  'Premium Support',
                                  '24/7 dedicated support team.',
                                ),
                                HowStep(
                                  'Quality Listings',
                                  'Access to verified property listings.',
                                ),
                                HowStep(
                                  'Gamified Dashboard',
                                  'Track your earnings and progress seamlessly.',
                                ),
                                HowStep(
                                  'Special Incentives',
                                  'Earn bonuses and extra rewards for your performance.',
                                ),
                              ],
                              plansForm: const PlansFormConfig(
                                pillText: 'Pricing',
                                title: 'Owner Premium Plans',
                                subtitle:
                                    'Get featured, sell 3x faster with priority support',
                                buttonText: 'Unlock Owner Plans',
                              ),
                              finalCallout: const FinalCalloutConfig(
                                headline: "Ready to Scale Your Earning?",
                                points: [
                                  'Elite Active Partners',
                                  'Huge Comm. Paid',
                                  'Reliable Partner Support',
                                ],
                                cta: 'Start Your Journey Now',
                              ),
                            ),
                            onPrimaryCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.reseller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => ResellerConversionScreen());
                              } else if (UserHelper.isReseller) {
                                Get.to(() => MainNavigationScreen());
                              }
                            }, // Post Property Free
                            onManageListings: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.reseller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => ResellerConversionScreen());
                              } else if (UserHelper.isReseller) {
                                Get.to(() => MainNavigationScreen());
                              }
                            },
                            onBecomeType: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.reseller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => ResellerConversionScreen());
                              } else if (UserHelper.isReseller) {
                                Get.to(() => MainNavigationScreen());
                              }
                            }, // Manage Listings
                            onUnlockPlans: () async {
                              final data =
                                  await SecureStorage.hasSubscriptionInquiryForUser(
                                    Roles.reseller.name,
                                    userId:
                                        (await SecureStorage.getClientId()) ??
                                        '',
                                    role: Roles.reseller.name,
                                  );
                              debugPrint(
                                "Has Subscription Inquiry For : $data",
                              );
                              Get.to(
                                () => SubscriptionPlansScreen(
                                  isNotFromBuyerSide: false,
                                  role: Roles.reseller.name,
                                  isInquirySubmitted: data,
                                  origin: 'buyer',
                                ),
                              );
                            }, // Unlock Owner Plans
                            onFinalCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () => RegisterScreen(role: UserRole.reseller),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(() => ResellerConversionScreen());
                              } else if (UserHelper.isReseller) {
                                Get.to(() => MainNavigationScreen());
                              }
                            }, // Final CTA
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),

                    _buildGuestRoleTile(
                      title: "Contractor Plans",
                      subtitle: "Provide renovation services",
                      icon: Icons.engineering_outlined,
                      iconColor: ColorRes.primary,
                      iconBgColor: ColorRes.primary.withOpacity(0.05),
                      onTap: () async {
                        Get.to(
                          () => ListingIntroScreen(
                            role: Roles.contractor.name,
                            showPropertySection: false,
                            planTitle: "Contractor Plans",

                            config: ListingIntroConfig(
                              contractorStrategyTitle:
                                  'Skyrocket Your Business as a NesticoPe Contractor',
                              contractorStrategySubtitle:
                                  'Strategic steps to scale your construction business with our platform',
                              contractorStrategySteps: const [
                                FeatureItemData(
                                  Icons.search,
                                  'Identify Local Demand',
                                  'Use our data insights to find high-demand localities in your expertise.',
                                ),
                                FeatureItemData(
                                  Icons.bar_chart,
                                  'Optimize Your Profile',
                                  'Showcase your best projects and gather verified reviews for higher visibility.',
                                ),
                                FeatureItemData(
                                  Icons.rocket_launch,
                                  'Leverage Technology',
                                  'Use our advanced management tools to streamline your operations and sales.',
                                ),
                              ],
                              contractorBenefitsTitle:
                                  'Empowering Your Construction Business',
                              contractorBenefitsSubtitle:
                                  'At NesticoPe, we provide a holistic platform for contractors. We offer buyers a complete property solution from initial searching and legal vetting to high-quality construction and interior design. This integrated approach ensures a steady flow of verified projects for our partners, creating a massive opportunity for everyone to scale their business with trust and technology.',
                              contractorBenefits: const [
                                FeatureItemData(
                                  Icons.trending_up,
                                  'Complete Project Ecosystem',
                                  'We offer buyers everything—from property search and legal work to construction and interior design. You are part of a full-service journey.',
                                ),
                                FeatureItemData(
                                  Icons.business,
                                  'Verified High-Intent Leads',
                                  'Access a steady stream of verified construction and renovation inquiries from buyers already engaged in our property ecosystem.',
                                ),
                                FeatureItemData(
                                  Icons.verified,
                                  'VBrand Authority',
                                  'Build a verified professional contractor profile that establishes immediate trust with property owners and large-scale developers.',
                                ),
                                FeatureItemData(
                                  Icons.construction,
                                  'Advanced Digital Tools',
                                  'Manage projects, track site visits, and showcase your portfolio with our enterprise-grade contractor dashboard.',
                                ),
                                FeatureItemData(
                                  Icons.location_city,
                                  'Premium Networking',
                                  'Connect with top builders and developers for high-value commercial and residential construction opportunities.',
                                ),
                                FeatureItemData(
                                  Icons.handshake,
                                  'Unmatched Growth Support',
                                  'Scale your construction business with 24/7 dedicated support and specialized marketing solutions for elite contractors.',
                                ),
                              ],
                              logoAsset: 'assets/images/NesticoPe_logo.png',
                              appBarBrand: 'NesticoPe',
                              badgeText: 'New Feature',

                              headline: 'Build Your Legacy',
                              highlightWord: 'With NesticoPe',
                              subHeadline:
                                  'Grow your business with verified leads and professional tools.',
                              primaryCta: 'Sign Up as Contractor',
                              sellWithTitle: 'What NesticoPe Expects from You',
                              sellWithSubtitle:
                                  'We maintain the highest standards to ensure quality and trust in our ecosystem.',
                              manageTitle: 'Already have services?',
                              manageSubtitle:
                                  'Boost visibility and manage your services from one place.',
                              manageButtonText: 'Manage Services',
                              premiumTitle: 'Featured Contractors',
                              premiumActionText: 'View All',
                              stepsTitle: 'How It Works?',
                              viewPlansTitle: 'Find the Perfect Plan for You',
                              viewPlansSubtitle:
                                  'Choose from premium plans to maximize your reach and brand visibility.',
                              viewPlansButtonText: 'Explore Plans',
                              stats: const [
                                StatItemData('Massive', 'Projects Completed'),
                                StatItemData('Growing', 'Active Projects'),
                                StatItemData('Trusted', 'Verified Contractors'),
                              ],
                              features: const [
                                FeatureItemData(
                                  Icons.security_outlined,
                                  'No Spam Policy',
                                  '''We value our buyers' privacy. Only meaningful interactions are encouraged.''',
                                ),
                                FeatureItemData(
                                  Icons.high_quality_outlined,
                                  'Quality Over Quantity',
                                  'We prioritize exceptional craftsmanship over the number of projects handled.',
                                ),
                                FeatureItemData(
                                  Icons.verified_outlined,
                                  'Verified Professionals Only',
                                  'Every contractor must pass a thorough verification process for trust.',
                                ),
                                // FeatureItemData(
                                //   Icons.support_agent_outlined,
                                //   'Direct Support',
                                //   'Dedicated support for project management and updates.',
                                // ),
                              ],
                              premiumListings: const [
                                PremiumListingItem(
                                  imageAsset: IMGRes.home2,
                                  title: 'Skyline Apartments',
                                  subtitle: 'Downtown, NYC',
                                  priceText: '₹45,00,000',
                                ),
                                PremiumListingItem(
                                  imageAsset: IMGRes.project_2,
                                  title: 'Greenview Residency',
                                  subtitle: 'Udhna, Surat',
                                  priceText: '₹1,20,00,000',
                                ),
                              ],
                              steps: const [
                                HowStep(
                                  'Register & Profile',
                                  'Complete your professional registration and get verified.',
                                ),
                                HowStep(
                                  'Add Your Services',
                                  'List your specialized construction services and expertise.',
                                ),
                                HowStep(
                                  'Get Quality Leads',
                                  'Receive inquiries from interested clients.',
                                ),
                                HowStep(
                                  'Start Project',
                                  'Connect with clients and start your construction work.',
                                ),
                                HowStep(
                                  'High Earnings',
                                  'Grow your business and maximize your revenue with us.',
                                ),
                              ],
                              plansForm: const PlansFormConfig(
                                pillText: 'Pricing',
                                title: 'Contractor Premium Plans',
                                subtitle:
                                    'Get featured and grow your service business',
                                buttonText: 'Unlock Contractor Plans',
                              ),
                              finalCallout: const FinalCalloutConfig(
                                headline: "Ready to Build Your Legacy?",
                                points: [
                                  'Expert Verified Contractors',
                                  'Massive Projects Value',
                                  'Roundclock Expert Support',
                                ],
                                cta: 'Start Your Journey Now',
                              ),
                            ),
                            onPrimaryCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () =>
                                      RegisterScreen(role: UserRole.contractor),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());

                                Get.to(
                                  () => ConvertToContractorConversionScreen(),
                                );
                              } else if (UserHelper.isContractor) {
                                Get.to(() => ContractorMainScreen());
                              }
                            }, // Post Property Free
                            onBecomeType: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () =>
                                      RegisterScreen(role: UserRole.contractor),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(
                                  () => ConvertToContractorConversionScreen(),
                                );
                              } else if (UserHelper.isContractor) {
                                Get.to(() => ContractorMainScreen());
                              }
                            },
                            onManageListings: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () =>
                                      RegisterScreen(role: UserRole.contractor),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(
                                  () => ConvertToContractorConversionScreen(),
                                );
                              } else if (UserHelper.isContractor) {
                                Get.to(() => ContractorMainScreen());
                              }
                            }, // Manage Listings
                            onUnlockPlans: () async {
                              // final data =
                              //     await SecureStorage.hasSubscriptionInquiryForUser(
                              //       Roles.contractor.name,
                              //       userId: (await SecureStorage.getClientId()) ?? '',

                              //       role: Roles.contractor.name,
                              //     );
                              // debugPrint("Has Subscription Inquiry For : $data");
                              // Get.to(
                              //   () => SubscriptionPlansScreen(
                              //     role: Roles.contractor.name,
                              //     isNotFromBuyerSide: false,

                              //     origin: 'buyer',
                              //   ),
                              // );
                              final data =
                                  await SecureStorage.hasSubscriptionInquiryForUser(
                                    Roles.contractor.name,
                                    userId:
                                        (await SecureStorage.getClientId()) ??
                                        '',
                                    role: Roles.contractor.name,
                                  );
                              debugPrint(
                                "Has Subscription Inquiry For : $data",
                              );
                              Get.to(
                                () => SubscriptionPlansScreen(
                                  role: Roles.contractor.name,
                                  isNotFromBuyerSide: true,
                                  isInquirySubmitted: data,
                                  origin: 'buyer',
                                ),
                              );
                            }, // Unlock Owner Plans

                            onFinalCta: () async {
                              if (UserHelper.isGuest) {
                                Navigator.of(context).pop();
                                await Get.to(
                                  () =>
                                      RegisterScreen(role: UserRole.contractor),
                                );
                              } else if (UserHelper.isBuyer) {
                                // Get.to(() => ManageListingsScreen());
                                Get.to(
                                  () => ConvertToContractorConversionScreen(),
                                );
                              } else if (UserHelper.isContractor) {
                                Get.to(() => ContractorMainScreen());
                              }
                            }, // Final CTA
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuestRoleTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorRes.primary.withOpacity(0.10),

                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: ColorRes.primary),
          ],
        ),
      ),
    );
  }
}

class DotPatternForRolePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..style = PaintingStyle.fill;

    const spacing = 28.0;
    const radius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(DotPatternForRolePainter oldDelegate) => false;
}

String _mapRoleToTitle(String role) {
  switch (role) {
    case 'sellerOwner':
      return 'Become a Seller';
    case 'sellerBuilder':
      return 'Become a Seller';
    case 'reseller':
      return 'Become a Partner';
    case 'contractor':
      return 'Become a Contractor';
    default:
      return '';
  }
}

Future<void> _saveInquiryToStorage(
  String name,
  String email,
  String role,
  String phone,
) async {
  final user = await SecureStorage.getUserData();
  final username =
      user?.user?.username ?? (UserHelper.isGuest ? 'guest' : name);
  final userId = user?.user?.id ?? '';
  final payload = {
    'userId': userId,
    'username': username,
    'role': role,
    'name': name,
    'email': email,
    'phone': phone,
    'timestamp': DateTime.now().toIso8601String(),
  };
  await SecureStorage.addSubscriptionInquiry(payload);
}
