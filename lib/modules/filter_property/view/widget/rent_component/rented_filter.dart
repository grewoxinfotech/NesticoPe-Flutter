import 'package:flutter/material.dart';

import 'package:housing_flutter_app/app/utils/dummy_data.dart';
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
        buildFilterHeadingPadding('BHK Type'),
        const SizedBox(height: 7),
        BHKTypes(bHKList: controllerForFilter.bHkType,controllerForFilter: controllerForFilter,onSelectionChanged: (selectedItems) {
debugPrint('rent bhk $selectedItems');
        },),
        const SizedBox(height: 7),
        buildFilterHeadingPadding('Rent Range'),
        BudgetFilter(
          maxQuantityLabel: 'Cr+',
          minQuantityLabel: 'L',
          maxLabel: 'Max',
          minLabel: 'Min',
          minValue: 100000,
          maxValue: 100000000,
          values: const RangeValues(100000, 5000000),
          onChanged: (newValues) {
            print('$newValues');
          },
        ),
        const SizedBox(height: 7),
        // buildFilterHeadingPadding('Listed By'),
        // const SizedBox(height: 7),
        // ListedBy(listedByList: listedByList),
        // const SizedBox(height: 7),
        buildFilterHeadingPadding('Furnishing Type'),
        const SizedBox(height: 7),
        ListedBy(listedByList: controllerForFilter.furnishingType,onTap: (items) {
debugPrint('Furnishing $items');
        },controllerForFilter: controllerForFilter,selectedString: controllerForFilter.rentFurnishing,),
      ],
    );
  }
}
