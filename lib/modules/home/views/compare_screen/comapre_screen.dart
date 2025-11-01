// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:housing_flutter_app/app/constants/app_font_sizes.dart';
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/img_res.dart';
// import 'package:housing_flutter_app/app/widgets/image/custom_image.dart';
//
// import '../../../../app/constants/size_manager.dart';
//
// class CompareScreen extends StatelessWidget {
//   const CompareScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Compare Property')),
//       body: Padding(
//         padding: const EdgeInsets.all(AppPadding.medium),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Text("Compare Property"),
//               // SizedBox(height: AppSpacing.medium),
//               PropertyCardForCompare(
//                 label: "Property A",
//                 title: "3 BHK Apartment",
//                 image: IMGRes.home2,
//               ),
//               SizedBox(height: AppSpacing.small),
//               PropertyCardForCompare(
//                 label: "Property B",
//                 title: "2 BHK Apartment",
//                 image: IMGRes.home4,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/img_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/widgets/image/custom_image.dart';

import 'package:flutter/material.dart';

// class PropertyCardForCompare extends StatelessWidget {
//   final String image;
//   final String title;
//   final String label;
//   final String address;
//   final String price;
//
//   const PropertyCardForCompare({
//     super.key,
//     required this.title,
//     required this.label,
//     required this.image,
//     required this.address,
//     required this.price,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: ColorRes.white,
//         border: Border.all(color: ColorRes.grey.withOpacity(0.2)),
//         borderRadius: BorderRadius.circular(AppRadius.medium),
//       ),
//       padding: EdgeInsets.all(AppPadding.small),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Property Image
//           ClipRRect(
//             borderRadius: BorderRadius.circular(AppRadius.small),
//             child: CustomImage(
//               type: CustomImageType.asset,
//               src: image,
//               height: 70,
//               width: 70,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           SizedBox(width: AppPadding.small),
//
//           // Property Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.medium,
//                     fontWeight: AppFontWeights.semiBold,
//                     color: ColorRes.textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 SizedBox(
//                   width: 190 ,
//                   child: Text(
//                     address,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: TextStyle(
//                       fontSize: AppFontSizes.extraSmall,
//                       fontWeight: AppFontWeights.regular,
//                       color: ColorRes.textSecondary,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 4),
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: AppFontSizes.caption,
//                     fontWeight: AppFontWeights.medium,
//                     color: ColorRes.primary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             width: 1,
//             height: 60,
//             color: ColorRes.leadGreyColor.withOpacity(0.2),
//           ),
//           SizedBox(width: 8),
//           // Price
//           Align(
//             alignment: Alignment.centerRight,
//             child: Text(
//               price, // now dynamic instead of hardcoded
//               style: TextStyle(
//                 fontSize: AppFontSizes.body,
//                 fontWeight: AppFontWeights.bold,
//                 color: ColorRes.primary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class PropertyCardForCompare extends StatelessWidget {
  final String image;
  final String title;
  final String label;
  final String address;
  final String price;

  const PropertyCardForCompare({
    super.key,
    required this.title,
    required this.label,
    required this.image,
    required this.address,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorRes.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 1,
      shadowColor: ColorRes.black.withOpacity(0.06),
      child: Container(
        height: 115,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ColorRes.leadGreyColor.shade200, width: 1),
        ),
        child: Row(
          children: [
            // Image Section
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(11)),
              child: CustomImage(
                type: CustomImageType.asset,
                src: image,
                width: 120,
                height: 121,
                fit: BoxFit.cover,
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Title
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: AppFontSizes.bodyMedium,
                        fontWeight: AppFontWeights.semiBold,
                        color: ColorRes.textColor,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),



                    // Address
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: AppFontSizes.caption,
                        color: ColorRes.leadGreyColor[600],
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),



                    // Property Typ
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bed_outlined, size: 13, color: const Color(0xFF2563EB)),
                        const SizedBox(width: 4),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: AppFontSizes.caption,
                            fontWeight: AppFontWeights.medium,
                            color: ColorRes.blackShade54,
                          ),
                        ),
                      ],
                    ),



                    // Price Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            price,
                            style: TextStyle(
                              fontSize: AppFontSizes.extraBody,
                              fontWeight: AppFontWeights.bold,

                              color: ColorRes.textColor,
                              height: 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ColorRes.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Visit',
                            style: TextStyle(
                              fontWeight: AppFontWeights.semiBold,
                              fontSize: AppFontSizes.small,
                              color: ColorRes.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorRes.leadGreyColor[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorRes.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Property Comparison',
          style: TextStyle(
            color: ColorRes.black,
            fontWeight: AppFontWeights.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: ColorRes.black, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppPadding.medium),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PropertyCardForCompare(
                  label: "Property A",
                  title: "3 BHK",
                  price: '2Cr',
                  image: IMGRes.home2,
                  address: 'Angan Residency Gurargon Karnatak India 358212',
                ),
                SizedBox(height: AppSpacing.small),
                PropertyCardForCompare(
                  label: "Property B",
                  title: "2 BHK",
                  price: '4.5Cr',
                  image: IMGRes.home4,
                  address: 'Angan Residency Gurargon Karnatak India 358212',
                ),
                SizedBox(height: 16),
                // Detailed Comparison Section
                Text(
                  'Detailed Comparison',
                  style: TextStyle(
                    fontSize: AppFontSizes.medium,
                    fontWeight: AppFontWeights.bold,
                    color: ColorRes.black,
                  ),
                ),
                const SizedBox(height: 12),
                _ComparisonTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String imagePath;
  final String propertyName;
  final String propertyType;
  final String location;
  final String price;
  final String description;
  final String sellerName;
  final double sellerRating;
  final int sellerReviews;
  final String sellerAvatar;
  final Color? priceColor;

  const _PropertyCard({
    required this.imagePath,
    required this.propertyName,
    required this.propertyType,
    required this.location,
    required this.price,
    required this.description,
    required this.sellerName,
    required this.sellerRating,
    required this.sellerReviews,
    required this.sellerAvatar,
    this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 120,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
              // Use Image.asset(imagePath) for actual images
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  propertyName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$propertyType -',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                Text(
                  location,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
                const SizedBox(height: 12),
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: priceColor ?? Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                // Seller Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sellerName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                '$sellerRating ($sellerReviews',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                'reviews)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Contact Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Contact Seller',
                      style: TextStyle(
                        fontSize: 14,
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
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3), width: 1),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.05),
        //     blurRadius: 10,
        //     offset: const Offset(0, 2),
        //   ),
        // ],
      ),
      child: Column(
        children: [
          // Header Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: ColorRes.leadGreyColor[200]!),
              ),
            ),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Features',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                Text(
                  'Property A',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
                Text(
                  'Property B',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: AppFontSizes.small,
                    fontWeight: AppFontWeights.medium,
                  ),
                ),
              ],
            ),
          ),
          // Comparison Rows
          _ComparisonRow(
            icon: Icons.home_outlined,
            label: 'Property\nType',
            valueA: 'Apartment',
            valueB: 'Villa',
          ),
          _ComparisonRow(
            icon: Icons.location_on_outlined,
            label: 'Location',
            valueA: 'Downtown',
            valueB: 'Lakeside',
          ),
          _ComparisonRow(
            icon: Icons.square_foot,
            label: 'Area',
            valueA: '1500 sq ft',
            valueB: '1650 sq ft',
            highlightB: true,
          ),
          _ComparisonRow(
            icon: Icons.bed_outlined,
            label: 'Bedrooms',
            valueA: '3',
            valueB: '2',
          ),
          _ComparisonRow(
            icon: Icons.bathtub_outlined,
            label: 'Bathrooms',
            valueA: '2',
            valueB: '2',
          ),
          _ComparisonRow(
            icon: Icons.layers_outlined,
            label: 'Floor',
            valueA: '8 of 12',
            valueB: 'G of 1',
          ),
          _ComparisonRow(
            icon: Icons.monetization_on_outlined,
            label: 'Price/sq\nft',
            valueA: '₹ 5,667',
            valueB: '₹ 4,727',
            highlightB: true,
          ),
          _ComparisonRow(
            icon: Icons.fitness_center_outlined,
            label: 'Amenities',
            valueA: 'Gym, Pool',
            valueB: 'Gym, Pool,\nParking,\nGarden',
            highlightB: true,
          ),
          _ComparisonRow(
            icon: Icons.calendar_today_outlined,
            label: 'Year\nBuilt',
            valueA: '2020',
            valueB: '2018',
          ),
          _ComparisonRow(
            icon: Icons.star_outline,
            label: 'Seller\nRating',
            valueA: '4.5',
            valueB: '4.8',
            highlightB: true,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valueA;
  final String valueB;
  final bool highlightB;
  final bool isLast;

  const _ComparisonRow({
    required this.icon,
    required this.label,
    required this.valueA,
    required this.valueB,
    this.highlightB = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppFontSizes.caption,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.leadGreyColor[700],
              ),
            ),
          ),

          Expanded(
            child: Text(
              valueA,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppFontSizes.small,
                fontWeight: AppFontWeights.medium,
                color: ColorRes.textColor,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  highlightB ? const EdgeInsets.symmetric(vertical: 6) : null,
              child: Text(
                valueB,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppFontSizes.small,
                  fontWeight: AppFontWeights.medium,
                  color: ColorRes.textColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildWishlistCard() {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: ColorRes.leadGreyColor.shade300, width: 1),
      borderRadius: BorderRadius.circular(12),
      color: ColorRes.white,
    ),
    child: Column(children: []),
  );
}
