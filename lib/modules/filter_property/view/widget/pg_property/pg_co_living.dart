// import 'package:flutter/material.dart';
//
// import 'package:housing_flutter_app/app/constants/color_res.dart';
// import 'package:housing_flutter_app/app/constants/size_manager.dart';
// import 'package:housing_flutter_app/app/utils/dummy_data.dart';
// import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buy_component.dart';
// import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart'
//     hide buildFilterHeadingPadding;
//
// import '../common_component/budget_filter.dart';
// import '../common_component/sale_type.dart';
//
// class PgCoLiving extends StatefulWidget {
//   const PgCoLiving({super.key});
//
//   @override
//   State<PgCoLiving> createState() => _PgCoLivingState();
// }
//
// class _PgCoLivingState extends State<PgCoLiving> {
//   String selectedGender = 'Male';
//   String selectedFoodAvailable = 'Yes';
//   final List<dynamic> itemList = [];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         buildFilterHeadingPadding('Gender'),
//         const SizedBox(height: 7),
//         SelectableWrap(
//           items: genderList,
//           selectedItem: selectedGender,
//           onSelected: (value) {
//             setState(() {
//               selectedGender = value;
//             });
//           },
//           isExpanded: false,
//         ),
//         const SizedBox(height: 7),
//         buildFilterHeadingPadding('Room Type'),
//         const SizedBox(height: 7),
//         FilterPropertyTypesList(
//           items: roomTypeList,
//           onSelectionChanged: (index) {},
//         ),
//         const SizedBox(height: 7),
//         buildFilterHeadingPadding('Budget'),
//         // SizedBox(height: 7),
//         BudgetFilter(
//           minValue: 0.0,
//           maxValue: 20,
//           values: const RangeValues(5, 15),
//           onChanged: (value) {},
//           minLabel: "Min",
//           maxLabel: "Max",
//           minQuantityLabel: "L",
//           maxQuantityLabel: "Cr+",
//         ),
//         buildFilterHeadingPadding('Food available'),
//         const SizedBox(height: 7),
//         SelectableWrap(
//           items: foodAvailable,
//           selectedItem: selectedFoodAvailable,
//           onSelected: (value) {
//             setState(() {
//               selectedFoodAvailable = value;
//             });
//           },
//           isExpanded: false,
//         ),
//         const SizedBox(height: 7),
//         buildFilterHeadingPadding('Brand'),
//         const SizedBox(height: 7),
//         SizedBox(
//           height: 35,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.only(right: 8),
//             shrinkWrap: true,
//             itemCount: builderList.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   String value = builderList[index]['title'];
//                   setState(() {
//                     if (value == "All") {
//                       if (itemList.length == builderList.length) {
//                         itemList.clear();
//                       } else {
//                         itemList.clear();
//                         itemList.addAll(builderList);
//                       }
//                     } else {
//                       if (itemList.contains(value)) {
//                         itemList.remove(value);
//                       } else {
//                         itemList.add(value);
//                       }
//                       if (itemList.length != builderList.length &&
//                           itemList.contains("All")) {
//                         itemList.remove("All");
//                       }
//                       if (itemList.length == builderList.length - 1 &&
//                           !itemList.contains("All")) {
//                         itemList.add("All");
//                       }
//                     }
//                   });
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 8),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 8,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey.shade300, width: 1),
//                       color:
//                           itemList.contains(builderList[index]['title'])
//                               ? ColorRes.primary
//                               : Colors.grey.shade100,
//                       borderRadius: BorderRadius.circular(AppRadius.small),
//                     ),
//                     alignment: Alignment.center,
//                     child: Row(
//                       children: [
//                         Image.asset(
//                           builderList[index]['image'],
//                           height: 20,
//                           width: 20,
//                         ),
//                         const SizedBox(width: 5),
//
//                         buildCommonText(
//                           builderList[index]['title'],
//                           11,
//                           FontWeight.w500,
//                           itemList.contains(builderList[index]['title'])
//                               ? ColorRes.white
//                               : ColorRes.textColor,
//                           1,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/buy_componet/buy_component.dart';
import '../common_component/budget_filter.dart';
import '../common_component/sale_type.dart';

class PgCoLiving extends StatefulWidget {
  const PgCoLiving({super.key, required this.controllerForFilter});

  final PropertyFilterControllerForFilter controllerForFilter;

  @override
  State<PgCoLiving> createState() => _PgCoLivingState();
}

class _PgCoLivingState extends State<PgCoLiving> {
  String selectedGender = 'Male';
  String selectedFoodAvailable = 'Yes';
  List<String> selectedBrands = []; // store only titles

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPropertyFilterHeadingPadding('Gender'),
        const SizedBox(height: 7),
        SelectableWrap(
          items: widget.controllerForFilter.genderList,
          selectedItem: widget.controllerForFilter.genderSelected,
          filterControllerForFilter: widget.controllerForFilter,
          onSelected: (value) {
            print('gender $value');
          },
          isExpanded: false,
        ),
        const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Room Type'),
        const SizedBox(height: 7),
        FilterPropertyTypesList(
          items: widget.controllerForFilter.roomTypeList,
          selectedItems: widget.controllerForFilter.roomSelectedType,
          onSelectionChanged: (index) {
            debugPrint('RppmList $index');
          },
          controllerForFilter: widget.controllerForFilter,
        ),
        const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Budget'),
        Obx(
          () => BudgetFilter(
            minValue: widget.controllerForFilter.pgMin.value,
            maxValue: widget.controllerForFilter.pgMax.value,
            values: widget.controllerForFilter.pgRangeValues.value,
            onChanged: (value) {
              widget.controllerForFilter.changePGRent(value);
            },
            minLabel: "Min",
            maxLabel: "Max",
            minQuantityLabel: "L",
            maxQuantityLabel: "Cr+",
          ),
        ),
        buildPropertyFilterHeadingPadding('Food available'),
        const SizedBox(height: 7),
        SelectableWrap(
          items: widget.controllerForFilter.foodAvailable,
          selectedItem: widget.controllerForFilter.foodSelected,
          onSelected: (value) {
            debugPrint('Food Available $value');
          },
          isExpanded: false,
          filterControllerForFilter: widget.controllerForFilter,
        ),
        const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Brand'),
        const SizedBox(height: 7),

        // SizedBox(
        //   height: 35,
        //   child:  ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       padding: const EdgeInsets.only(right: 8),
        //       shrinkWrap: true,
        //       itemCount: widget.controllerForFilter.builderList.length,
        //       itemBuilder: (context, index) {
        //         final builder = widget.controllerForFilter.builderList[index];
        //
        //
        //         return Obx(
        //           () =>  GestureDetector(
        //             onTap: () {
        //
        //                   widget.controllerForFilter.selectedMap['title'] ==
        //                       builder['title'];
        //               // Assign the whole map to selectedMap
        //               widget.controllerForFilter.selectedMap.value = builder;
        //               debugPrint(
        //                 'hughughugyu ${widget.controllerForFilter.selectedMap.value}',
        //               );
        //             },
        //             child: Padding(
        //               padding: const EdgeInsets.only(left: 8),
        //               child: Container(
        //                 padding: const EdgeInsets.symmetric(
        //                   horizontal: 8,
        //                   vertical: 8,
        //                 ),
        //                 decoration: BoxDecoration(
        //                   border: Border.all(
        //                     color: Colors.grey.shade300,
        //                     width: 1,
        //                   ),
        //                   color:
        //                   widget.controllerForFilter.selectedMap['title'] ==
        //                       builder['title']
        //                           ? ColorRes.primary
        //                           : Colors.grey.shade100,
        //                   borderRadius: BorderRadius.circular(AppRadius.small),
        //                 ),
        //                 alignment: Alignment.center,
        //                 child: Row(
        //                   children: [
        //                     Image.asset(builder['image'], height: 20, width: 20),
        //                     const SizedBox(width: 5),
        //                     buildCommonText(
        //                       builder['title'],
        //                       11,
        //                       FontWeight.w500,
        //                       widget.controllerForFilter.selectedMap['title'] ==
        //                           builder['title'] ? ColorRes.white : ColorRes.textColor,
        //                       1,
        //                     ),
        //                   ],
        //                 ),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     )
        //
        // ),
        // SizedBox(
        //    height: 50,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     padding: EdgeInsets.only(right: 10),
        //     shrinkWrap: true,
        //     itemCount: widget.controllerForFilter.builderList.length,
        //     itemBuilder: (context, index) {
        //       final builder = widget.controllerForFilter.builderList[index];
        //
        //       return Obx(() {
        //         final isSelected =
        //             widget.controllerForFilter.selectedMap['title'] ==
        //             builder['title'];
        //         return Padding(
        //           padding: EdgeInsets.only(
        //           left: 10
        //           ),
        //           child: GestureDetector(
        //             onTap: () {
        //               widget.controllerForFilter.selectedMap.value = builder;
        //               debugPrint(
        //                 'Selected builder: ${widget.controllerForFilter.selectedMap.value}',
        //               );
        //             },
        //             child: Container(
        //               // duration: const Duration(milliseconds: 200),
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 14,
        //                 vertical: 10,
        //               ),
        //               decoration: BoxDecoration(
        //
        //                 color: isSelected ? ColorRes.primary.withOpacity(0.1) : ColorRes.white,
        //                 border: Border.all(
        //                   color:
        //                       isSelected
        //                           ? ColorRes.primary
        //                           : Colors.grey.shade300,
        //                   width: isSelected?1.8:1.5,
        //                 ),
        //                 borderRadius: BorderRadius.circular(10),
        //
        //               ),
        //               child: Row(
        //                 mainAxisSize: MainAxisSize.min,
        //                 children: [
        //                   Container(
        //                     padding: const EdgeInsets.all(4),
        //                     decoration: BoxDecoration(
        //                       color:
        //                           isSelected
        //                               ? ColorRes.primary.withOpacity(0.2)
        //                               : Colors.transparent,
        //
        //                       borderRadius: BorderRadius.circular(6),
        //                     ),
        //                     child: Image.asset(
        //                       builder['image'],
        //                       height: 15,
        //                       width: 15,
        //                     ),
        //                   ),
        //                   const SizedBox(width: 8),
        //                   buildCommonText(
        //                     builder['title'],
        //                     12,
        //                     FontWeight.w500,
        //                     isSelected ? ColorRes.primary : ColorRes.textColor,
        //                     1,
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         );
        //       });
        //     },
        //   ),
        // ),
      ],
    );
  }
}
