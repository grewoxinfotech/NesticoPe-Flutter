import 'package:flutter/material.dart';
import 'package:housing_flutter_app/app/constants/color_res.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';

class FilterPropertyTypesList extends StatefulWidget {
  const FilterPropertyTypesList({
    super.key,
    required this.items,
    this.onSelectionChanged,
  });

  final List<String> items;
  final Function(List<String> selectedItems)? onSelectionChanged;

  @override
  State<FilterPropertyTypesList> createState() =>
      _FilterPropertyTypesListState();
}

class _FilterPropertyTypesListState extends State<FilterPropertyTypesList> {
  List<String> selectedItems = [];

  void toggleSelection(int index) {
    String value = widget.items[index];

    setState(() {
      if (value == "All") {
        if (selectedItems.length == widget.items.length) {
          selectedItems.clear();
        } else {
          selectedItems.clear();
          selectedItems.addAll(widget.items);
        }
      } else {
        if (selectedItems.contains(value)) {
          selectedItems.remove(value);
        } else {
          selectedItems.add(value);
        }

        if (selectedItems.length != widget.items.length &&
            selectedItems.contains("All")) {
          selectedItems.remove("All");
        }
        if (selectedItems.length == widget.items.length - 1 &&
            !selectedItems.contains("All")) {
          selectedItems.add("All");
        }
      }
    });

    widget.onSelectionChanged?.call(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(right: 8),
        shrinkWrap: true,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => toggleSelection(index),
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: buildFilterPropertyTypes(
                title: widget.items[index],
                isSelected: selectedItems.contains(widget.items[index]),
                isExpanded: false,
                paddingHorizontal: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}

Padding buildFilterHeadingPadding(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    child: buildCommonText(title, 15, FontWeight.w600, ColorRes.textColor, 1),
  );
}
