import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';

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
    this.isExpanded = false, required this.filterControllerForFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>  Wrap(
        runSpacing: runSpacing,
        children:
            items.map((type) {
              final isSelected = selectedItem.value == type;
              return GestureDetector(
                onTap: () {
                  filterControllerForFilter.updateFilter(selectedItem, type);
              onSelected(
                type
              );
                },
                child: Padding(
                  padding: EdgeInsets.only(left: itemPadding),
                  child: buildFilterPropertyTypes(
                    title: type,
                    isSelected: isSelected,
                    isExpanded: isExpanded,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
