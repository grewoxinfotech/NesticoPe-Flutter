import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/size_manager.dart';
import 'package:nesticope_app/modules/search_property/widget/suggested_list.dart';



class SelectableWrap extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelected;
  final double runSpacing;
  final double itemPadding;
  final bool isExpanded;

  const SelectableWrap({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
    this.runSpacing = 10,
    this.itemPadding = 8,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: AppSpacing.small,
      children: items.map((type) {
        final isSelected = selectedItem == type;
        return GestureDetector(
          onTap: () => onSelected(type),
          child: Padding(
            padding: const EdgeInsets.only(left: AppPadding.small),
            child: buildFilterPropertyTypes(
              title: type,
              isSelected: isSelected,
              isExpanded: isExpanded,
            ),
          ),
        );
      }).toList(),
    );
  }
}
