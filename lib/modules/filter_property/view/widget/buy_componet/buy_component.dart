import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../../../../app/constants/app_font_sizes.dart';

// class FilterPropertyTypesList extends StatefulWidget {
//   const FilterPropertyTypesList({
//     super.key,
//     required this.items,
//     required this.onSelectionChanged,
//     required this.controllerForFilter, required this.selectedItems,
//
//   });
//
//   final List<String> items;
//   final Function(String? selectedItems) onSelectionChanged;
//   final PropertyFilterControllerForFilter controllerForFilter;
//   final RxString selectedItems;
//
//   @override
//   State<FilterPropertyTypesList> createState() =>
//       _FilterPropertyTypesListState();
// }
//
// class _FilterPropertyTypesListState extends State<FilterPropertyTypesList> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 35,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.only(right: 8),
//         shrinkWrap: true,
//         itemCount: widget.items.length,
//         itemBuilder: (context, index) {
//           return Obx(
//             ()=> GestureDetector(
//               onTap: () {
//                 widget.controllerForFilter.updateFilter(
//                   widget.selectedItems,
//                   widget.items[index],
//                 );
//                 widget.onSelectionChanged(widget.items[index]);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child: buildFilterPropertyTypes(
//                   title: widget.items[index],
//                   isSelected:
//                       widget.selectedItems.value ==
//                       widget.items[index],
//                   isExpanded: false,
//                   paddingHorizontal: 20,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// Padding buildFilterHeadingPadding(String title) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//     child: buildCommonText(title, 15, AppFontWeights.semiBold, ColorRes.textColor, 1),
//   );
// }

class FilterPropertyTypesList extends StatefulWidget {
  const FilterPropertyTypesList({
    super.key,
    required this.items,
    required this.onSelectionChanged,
    required this.controllerForFilter,
    required this.selectedItems,
  });

  final List<String> items;
  final Function(String? selectedItems) onSelectionChanged;
  final PropertyFilterControllerForFilter controllerForFilter;
  final RxString selectedItems;

  @override
  State<FilterPropertyTypesList> createState() =>
      _FilterPropertyTypesListState();
}

class _FilterPropertyTypesListState extends State<FilterPropertyTypesList> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 10),
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected =
                widget.selectedItems.value == widget.items[index];
            return Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  widget.controllerForFilter.updateFilter(
                    widget.selectedItems,
                    widget.items[index],
                  );
                  widget.onSelectionChanged(widget.items[index]);
                },
                child: Container(
                  // duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? ColorRes.primary.withOpacity(0.1)
                            : ColorRes.white,
                    border: Border.all(
                      color:
                          isSelected ? ColorRes.primary : ColorRes.leadGreyColor.shade300,
                      width: isSelected ? 1.8 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCommonText(
                        widget.items[index],
                        AppFontSizes.small,
                        AppFontWeights.medium,
                        isSelected ? ColorRes.primary : ColorRes.textColor,
                        1,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

Padding buildPropertyFilterHeadingPadding(String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: buildCommonText(title,AppFontSizes.medium, AppFontWeights.semiBold, ColorRes.textColor, 1),
  );
}
