import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';

import '../../../../../app/constants/color_res.dart';
import '../../../../search_property/view/search_screen.dart';

// class ListedBy extends StatefulWidget {
//   const ListedBy({
//     super.key,
//     required this.listedByList,
//     required this.onTap,
//     required this.controllerForFilter, required this.selectedString,
//   });
//
//   final List<String> listedByList;
//   final Function(String? items) onTap;
//   final PropertyFilterControllerForFilter controllerForFilter;
//   final RxString selectedString;
//
//   @override
//   State<ListedBy> createState() => _ListedByState();
// }
//
// class _ListedByState extends State<ListedBy> {
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 35,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         shrinkWrap: true,
//         padding: const EdgeInsets.only(right: 10),
//         itemCount: widget.listedByList.length,
//         itemBuilder: (context, index) {
//           return Obx(
//             () => GestureDetector(
//               onTap: () {
//                 widget.controllerForFilter.updateFilter(
//                   widget.selectedString,
//                   widget.listedByList[index],
//                 );
//                 widget.onTap(widget.listedByList[index]);
//               },
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8),
//                 child: buildFilterPropertyTypes(
//                   title: widget.listedByList[index],
//                   isSelected:
//                      widget.selectedString.value ==
//                       widget.listedByList[index],
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

class ListedBy extends StatefulWidget {
  const ListedBy({
    super.key,
    required this.listedByList,
    required this.onTap,
    required this.controllerForFilter,
    required this.selectedString,
  });

  final List<String> listedByList;
  final Function(String? items) onTap;
  final PropertyFilterControllerForFilter controllerForFilter;
  final RxString selectedString;

  @override
  State<ListedBy> createState() => _ListedByState();
}

class _ListedByState extends State<ListedBy> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: EdgeInsets.only(right: 10),
        itemCount: widget.listedByList.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected =
                widget.selectedString.value == widget.listedByList[index];
            return Padding(
              padding: EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  widget.controllerForFilter.updateFilter(
                    widget.selectedString,
                    widget.listedByList[index],
                  );
                  widget.onTap(widget.listedByList[index]);
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
                            : Colors.white,
                    border: Border.all(
                      color:
                          isSelected ? ColorRes.primary : Colors.grey.shade300,
                      width: isSelected ? 1.8 : 1.5,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildCommonText(
                        widget.listedByList[index],
                        12,
                        FontWeight.w500,
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
