import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';

import '../common_component/bhk_list.dart';
import '../buy_componet/buy_component.dart';
import '../common_component/budget_filter.dart';
import '../common_component/listed_by.dart';

class RentFilter extends StatelessWidget {
  const RentFilter({super.key, required this.controllerForFilter});
  final PropertyFilterControllerForFilter controllerForFilter;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPropertyFilterHeadingPadding('BHK Type'),
        const SizedBox(height: 7),
        BHKTypes(
          bHKList: controllerForFilter.bHkType,
          controllerForFilter: controllerForFilter,
          onSelectionChanged: (selectedItems) {
            debugPrint('rent bhk $selectedItems');
          },
        ),
        const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Rent Range'),
        // Obx(
        //   () => BudgetFilter(
        //     maxQuantityLabel: 'Cr+',
        //     minQuantityLabel: 'L',
        //     maxLabel: 'Max',
        //     minLabel: 'Min',
        //     minValue: controllerForFilter.rentMin.value,
        //     maxValue: controllerForFilter.rentMax.value,
        //     values: controllerForFilter.rentRangeValues.value,
        //     onChanged: (newValues) {
        //       controllerForFilter.dynamicRentChangeValue(newValues);
        //       print(
        //         " Rent Range value ${controllerForFilter.rentMin.value}  ${controllerForFilter.rentMax.value} ${controllerForFilter.rentRangeValues.value}",
        //       );
        //     },
        //   ),
        // ),
        Obx(
              () => BudgetFilterChange(
            minSelected: controllerForFilter.rentMin.value,
            maxSelected: controllerForFilter.rentMax.value,
            budgetList: controllerForFilter.rentBudgetValues.value,
            onMinChanged: (val) {
              if (val != null) {
                controllerForFilter.rentMin.value = val;
                print("Main ${controllerForFilter.rentMin.value}");
              }
            },
            onMaxChanged: (val) {
              if (val != null) {
                controllerForFilter.rentMax.value = val;

                print("mxa ${controllerForFilter.rentMax.value}");
              }
            },
            minLabel: "Min Budget",
            maxLabel: "Max Budget",
          ),
        ),
        const SizedBox(height: 7),
        // buildFilterHeadingPadding('Listed By'),
        // const SizedBox(height: 7),
        // ListedBy(listedByList: listedByList),
        // const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Furnishing Type'),
        const SizedBox(height: 7),
        ListedBy(
          listedByList: controllerForFilter.furnishingType,
          onTap: (items) {
            debugPrint('Furnishing $items');
          },
          controllerForFilter: controllerForFilter,
          selectedString: controllerForFilter.rentFurnishing,
        ),
      ],
    );
  }
}
