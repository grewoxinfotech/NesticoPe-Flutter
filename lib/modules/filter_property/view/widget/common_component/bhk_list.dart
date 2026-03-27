import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/modules/filter_property/controller/property_filter_controller.dart';

import '../../../../../app/constants/app_font_sizes.dart';
import '../../../../../app/constants/color_res.dart';
import '../../../../search_property/view/search_screen.dart';

// class BHKTypes extends StatelessWidget {
//    BHKTypes({super.key, required this.bHKList, required this.onSelectionChanged, required this.controllerForFilter});
//
//   final List<String> bHKList;
//   final Function(String? selectedItems) onSelectionChanged;
//   final PropertyFilterControllerForFilter controllerForFilter;
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.only(left: 8),
//       child: Row(
//         children: List.generate(
//           bHKList.length,
//           (index) => Obx(
//             () =>  Padding(
//               padding: const EdgeInsets.only(right: 8),
//               child: GestureDetector(
//                 onTap: () { controllerForFilter.updateFilter(controllerForFilter.bhkType,bHKList[index]);
//                   onSelectionChanged(bHKList[index]);
//                   },
//                 child: buildFilterPropertyTypes(
//                   title: bHKList[index],
//                   isSelected: controllerForFilter.bhkType.value==bHKList[index],
//                   isExpanded: true,
//                   width: 80,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

class BHKTypes extends StatelessWidget {
  BHKTypes({
    super.key,
    required this.bHKList,
    required this.onSelectionChanged,
    required this.controllerForFilter,
  });

  final List<String> bHKList;
  final Function(String? selectedItems) onSelectionChanged;
  final PropertyFilterControllerForFilter controllerForFilter;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(right: 10),
        itemCount: bHKList.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected =
                controllerForFilter.bhkType.value == bHKList[index];
            return Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  controllerForFilter.updateFilter(
                    controllerForFilter.bhkType,
                    bHKList[index],
                  );
                  onSelectionChanged(bHKList[index]);
                },
                child: Container(
                  // duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCommonText(
                        bHKList[index],
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
