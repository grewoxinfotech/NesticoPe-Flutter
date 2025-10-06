import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';

import '../../../../../app/constants/color_res.dart';
import '../../../../search_property/view/search_screen.dart';

// class SelectableWrap extends StatelessWidget {
//   final List<String> items;
//   final RxString selectedItem;
//   final ValueChanged<String> onSelected;
//   final double runSpacing;
//   final double itemPadding;
//   final bool isExpanded;
//   final PropertyFilterControllerForFilter filterControllerForFilter;
//
//   const SelectableWrap({
//     super.key,
//     required this.items,
//     required this.selectedItem,
//     required this.onSelected,
//     this.runSpacing = 10,
//     this.itemPadding = 8,
//     this.isExpanded = false, required this.filterControllerForFilter,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () =>  Wrap(
//         runSpacing: runSpacing,
//         children:
//             items.map((type) {
//               final isSelected = selectedItem.value == type;
//               return GestureDetector(
//                 onTap: () {
//                   filterControllerForFilter.updateFilter(selectedItem, type);
//               onSelected(
//                 type
//               );
//                 },
//                 child: Padding(
//                   padding: EdgeInsets.only(left: itemPadding),
//                   child: buildFilterPropertyTypes(
//                     title: type,
//                     isSelected: isSelected,
//                     isExpanded: isExpanded,
//                   ),
//                 ),
//               );
//             }).toList(),
//       ),
//     );
//   }
// }

class SelectableWrap extends StatelessWidget {
  final List<String> items;
  final RxString selectedItem;
  final ValueChanged<String> onSelected;
  final double runSpacing;
  final double itemPadding;
  final bool isExpanded;
  final PropertyFilterControllerForFilter filterControllerForFilter;

  const SelectableWrap({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    this.runSpacing = 10,
    this.itemPadding = 8,
    this.isExpanded = false,
    required this.filterControllerForFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Wrap(
          spacing: 10,
          runSpacing: runSpacing,
          children:
              items.map((type) {
                final isSelected = selectedItem.value == type;
                return GestureDetector(
                  onTap: () {
                    filterControllerForFilter.updateFilter(selectedItem, type);
                    onSelected(type);
                  },
                  child: Container(
                    height: 42,
                    // duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? ColorRes.primary.withOpacity(0.1)
                              : Colors.white,
                      border: Border.all(
                        color:
                            isSelected
                                ? ColorRes.primary
                                : Colors.grey.shade300,
                        width: isSelected ? 1.8 : 1.5,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildCommonText(
                          type,
                          12,
                          FontWeight.w500,
                          isSelected ? ColorRes.primary : ColorRes.textColor,
                          1,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }
}
