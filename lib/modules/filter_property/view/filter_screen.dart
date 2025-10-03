// import 'package:flutter/material.dart';
//
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/app/utils/dummy_data.dart';
// import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buyer_filter.dart';
// import 'package:housing_flutter_app/modules/filter_property/view/widget/commercial_property_filter/commercial_property_filter.dart';
// import 'package:housing_flutter_app/modules/filter_property/view/widget/pg_property/pg_co_living.dart';
// import 'package:housing_flutter_app/modules/filter_property/view/widget/rent_component/rented_filter.dart';
// import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
// import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';
//
// class RealEstateFilterScreen extends StatefulWidget {
//   const RealEstateFilterScreen({super.key});
//
//   @override
//   State<RealEstateFilterScreen> createState() => _RealEstateFilterScreenState();
// }
//
// class _RealEstateFilterScreenState extends State<RealEstateFilterScreen> {
//   int selectedPropertyTypeIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white24,
//         title: buildCommonText(
//           'Real Estate Filter',
//           20,
//           FontWeight.w600,
//           ColorRes.textColor,
//           1,
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 7),
//             buildFilterHeadingPadding('Types of properties'),
//             const SizedBox(height: 7),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 8,
//                 ), // only at edges
//                 child: Row(
//                   children: List.generate(propertyType.length, (index) {
//                     return Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               selectedPropertyTypeIndex = index;
//                               print(
//                                 'print property type  ${propertyType[selectedPropertyTypeIndex]}',
//                               );
//                             });
//                           },
//                           child: buildFilterPropertyTypes(
//                             title: propertyType[index],
//                             height: 50,
//                             width: 90,
//
//                             isSelected: selectedPropertyTypeIndex == index,
//                             isExpanded: true,
//                           ),
//                         ),
//                         if (index != propertyType.length - 1)
//                           const SizedBox(
//                             width: 8,
//                           ), // spacing only between items
//                       ],
//                     );
//                   }),
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 15),
//             buildFilterHeadingPadding('Localities'),
//             const SizedBox(height: 7),
//
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//
//               child: Row(
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(left: 8),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(AppRadius.small),
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                       color: Colors.grey.shade100,
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       spacing: 5,
//                       children: [
//                         const Icon(
//                           Icons.location_on,
//                           color: ColorRes.primary,
//                           size: 13,
//                         ),
//                         buildCommonText(
//                           'Add more',
//                           12,
//                           FontWeight.w600,
//                           ColorRes.textColor,
//                           1,
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   SizedBox(
//                     width: 300,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.horizontal,
//                       child: Row(
//                         children: List.generate(
//                           localityList.length,
//                           (index) => Container(
//                             margin: const EdgeInsets.only(right: 8),
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 8,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(
//                                 AppRadius.small,
//                               ),
//                               border: Border.all(
//                                 color: Colors.grey.shade300,
//                                 width: 1,
//                               ),
//                               color: ColorRes.primary,
//                             ),
//                             // child: Text(
//                             //   localityList[index],
//                             //   style:TextStyle(
//                             //     fontFamily: FontResource.fontFamily,
//                             //     fontWeight: FontWeight.w500,
//                             //     fontSize: 12.sp,
//                             //     color: Colors.white,
//                             //   ),
//                             // ),
//                             child: buildCommonText(
//                               localityList[index],
//                               12,
//                               FontWeight.w500,
//                               Colors.white,
//                               1,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 7),
//             Column(
//               children: [
//                 if (propertyType[selectedPropertyTypeIndex] == "Buy") ...[
//                   const BuyFilters(),
//                 ] else if (propertyType[selectedPropertyTypeIndex] ==
//                     "Rent") ...[
//                   const RentFilter(),
//                 ] else if (propertyType[selectedPropertyTypeIndex] ==
//                     "Commercial") ...[
//                   const CommercialPropertyFilter(),
//                 ] else if (propertyType[selectedPropertyTypeIndex] ==
//                     "PG/Co-living") ...[
//                   const PgCoLiving(),
//                 ],
//               ],
//             ),
//           ],
//         ),
//       ),
//
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           height: 80,
//           color: Colors.white,
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               backgroundColor: ColorRes.primary,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(60),
//               ),
//             ),
//             onPressed: () {},
//             child: buildCommonText(
//               'Apply Filters',
//               16,
//               FontWeight.w600,
//               Colors.white,
//               1,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/app/constants/size_manager.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buyer_filter.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/commercial_property_filter/commercial_property_filter.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/pg_property/pg_co_living.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/rent_component/rented_filter.dart';
import 'package:housing_flutter_app/modules/property_price_trend/view/widget/filter_type.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

class RealEstateFilterScreen extends StatelessWidget {
  // Controller initialized once
  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white24,
        title: buildCommonText(
          'Real Estate Filter',
          20,
          FontWeight.w600,
          ColorRes.textColor,
          1,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 7),
            buildFilterHeadingPadding('Types of properties'),
            const SizedBox(height: 7),

            // Property type selection row wrapped in Obx
            Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: List.generate(propertyType.length, (index) {
                      return Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              filterController.selectedPropertyTypeIndex.value =
                                  index;
                            },
                            child: buildFilterPropertyTypes(
                              title: propertyType[index],
                              height: 50,
                              width: 90,
                              isSelected:
                                  filterController
                                      .selectedPropertyTypeIndex
                                      .value ==
                                  index,
                              isExpanded: true,
                            ),
                          ),
                          if (index != propertyType.length - 1)
                            const SizedBox(width: 8),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),
            buildFilterHeadingPadding('Localities'),
            const SizedBox(height: 7),

            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadius.small),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    color: Colors.grey.shade100,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: ColorRes.primary,
                        size: 13,
                      ),
                      buildCommonText(
                        'Add more',
                        12,
                        FontWeight.w600,
                        ColorRes.textColor,
                        1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Flexible scroll for locality list
                Flexible(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(localityList.length, (index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppRadius.small,
                            ),
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                            color: ColorRes.primary,
                          ),
                          child: buildCommonText(
                            localityList[index],
                            12,
                            FontWeight.w500,
                            Colors.white,
                            1,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            // Dynamic filters based on property type
            Obx(() {
              final selectedType =
                  propertyType[filterController
                      .selectedPropertyTypeIndex
                      .value];

              if (selectedType == "Buy") return const BuyFilters();
              if (selectedType == "Rent") return const RentFilter();
              if (selectedType == "Commercial")
                return const CommercialPropertyFilter();
              if (selectedType == "PG/Co-living") return const PgCoLiving();

              return const SizedBox();
            }),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 80,
          color: Colors.white,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorRes.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            onPressed: () {},
            child: buildCommonText(
              'Apply Filters',
              16,
              FontWeight.w600,
              Colors.white,
              1,
            ),
          ),
        ),
      ),
    );
  }
}
