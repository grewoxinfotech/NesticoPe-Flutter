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
import '../../../../app/constants/app_font_sizes.dart';
import '../../../../app/constants/color_res.dart';
import '../../../../app/constants/img_res.dart';
import '../../../../app/constants/size_manager.dart';
import '../../../../app/widgets/image/custom_image.dart';

class PropertyCardForCompare extends StatelessWidget {
  final String image;
  final String title;
  final String label;
  const PropertyCardForCompare({
    super.key,
    required this.title,
    required this.label,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(AppRadius.medium),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppPadding.small),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: CustomImage(
                type: CustomImageType.asset,
                src: image,
                height: 100,
                width: 100,
              ),
            ),
            SizedBox(width: AppPadding.medium),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: AppFontSizes.large,
                    fontWeight: AppFontWeights.bold,
                    color: ColorRes.textPrimary,
                  ),
                ),
                SizedBox(height: AppSpacing.small),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppFontSizes.body,
                    fontWeight: AppFontWeights.medium,
                    color: ColorRes.textSecondary,
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

class CompareScreen extends StatelessWidget {
  const CompareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Property Comparison',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.view_list, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.medium),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                // Property Cards Section
                PropertyCardForCompare(
                  label: "Property A",
                  title: "3 BHK Apartment",
                  image: IMGRes.home2,
                ),
                SizedBox(height: AppSpacing.small),
                PropertyCardForCompare(
                  label: "Property B",
                  title: "2 BHK Apartment",
                  image: IMGRes.home4,
                ),
                SizedBox(height: 16),
                // Detailed Comparison Section
                Text(
                  'Detailed Comparison',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
                _ComparisonTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _PropertyCard extends StatelessWidget {
//   final String imagePath;
//   final String propertyName;
//   final String propertyType;
//   final String location;
//   final String price;
//   final String description;
//   final String sellerName;
//   final double sellerRating;
//   final int sellerReviews;
//   final String sellerAvatar;
//   final Color? priceColor;
//
//   const _PropertyCard({
//     required this.imagePath,
//     required this.propertyName,
//     required this.propertyType,
//     required this.location,
//     required this.price,
//     required this.description,
//     required this.sellerName,
//     required this.sellerRating,
//     required this.sellerReviews,
//     required this.sellerAvatar,
//     this.priceColor,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Property Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Container(
//               height: 120,
//               width: double.infinity,
//               color: Colors.grey[300],
//               child: const Icon(Icons.image, size: 50, color: Colors.grey),
//               // Use Image.asset(imagePath) for actual images
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   propertyName,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$propertyType -',
//                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 ),
//                 Text(
//                   location,
//                   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   price,
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.w700,
//                     color: priceColor ?? Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 12,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // Seller Info
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: Colors.grey[300],
//                       child: const Icon(
//                         Icons.person,
//                         size: 20,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             sellerName,
//                             style: const TextStyle(
//                               fontSize: 13,
//                               fontWeight: FontWeight.w600,
//                               color: Colors.black,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               const Icon(
//                                 Icons.star,
//                                 size: 14,
//                                 color: Colors.amber,
//                               ),
//                               const SizedBox(width: 2),
//                               Text(
//                                 '$sellerRating ($sellerReviews',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                               const SizedBox(width: 2),
//                               Text(
//                                 'reviews)',
//                                 style: TextStyle(
//                                   fontSize: 11,
//                                   color: Colors.grey[600],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 // Contact Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {},
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                     ),
//                     child: const Text(
//                       'Contact Seller',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
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

class _ComparisonTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorRes.grey.withOpacity(0.3)),
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                const Expanded(child: SizedBox()),
                Expanded(
                  child: Text(
                    'Property A',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'Property B',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              valueA,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding:
                  highlightB ? const EdgeInsets.symmetric(vertical: 6) : null,
              decoration:
                  highlightB
                      ? BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(8),
                      )
                      : null,
              child: Text(
                valueB,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
