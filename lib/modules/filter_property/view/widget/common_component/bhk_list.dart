import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';

class BHKTypes extends StatelessWidget {
   BHKTypes({super.key, required this.bHKList, required this.onSelectionChanged, required this.controllerForFilter});

  final List<String> bHKList;
  final Function(String? selectedItems) onSelectionChanged;
  final PropertyFilterControllerForFilter controllerForFilter;



  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        children: List.generate(
          bHKList.length,
          (index) => Obx(
            () =>  Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () { controllerForFilter.updateFilter(controllerForFilter.bhkType,bHKList[index]);
                  onSelectionChanged(bHKList[index]);
                  },
                child: buildFilterPropertyTypes(
                  title: bHKList[index],
                  isSelected: controllerForFilter.bhkType.value==bHKList[index],
                  isExpanded: true,
                  width: 80,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
