import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';

import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';

class ListedBy extends StatefulWidget {
  const ListedBy({
    super.key,
    required this.listedByList,
    required this.onTap,
    required this.controllerForFilter, required this.selectedString,
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
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.only(right: 10),
        itemCount: widget.listedByList.length,
        itemBuilder: (context, index) {
          return Obx(
            () => GestureDetector(
              onTap: () {
                widget.controllerForFilter.updateFilter(
                  widget.selectedString,
                  widget.listedByList[index],
                );
                widget.onTap(widget.listedByList[index]);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: buildFilterPropertyTypes(
                  title: widget.listedByList[index],
                  isSelected:
                     widget.selectedString.value ==
                      widget.listedByList[index],
                  isExpanded: false,
                  paddingHorizontal: 20,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
