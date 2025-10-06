import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';

import '../common_component/bhk_list.dart';
import '../common_component/budget_filter.dart';
import '../common_component/listed_by.dart';
import 'buy_component.dart';

class BuyFilters extends StatelessWidget {
  final PropertyFilterControllerForFilter controllerForFilter;

  const BuyFilters({super.key, required this.controllerForFilter});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPropertyFilterHeadingPadding('Budget Range'),

        Obx(
          () => BudgetFilter(
            maxQuantityLabel: 'Cr+',
            minQuantityLabel: 'L',
            maxLabel: 'Max',
            minLabel: 'Min',
            minValue: controllerForFilter.min.value,
            maxValue: controllerForFilter.max.value,
            values: controllerForFilter.rangeValues,
            // Now this works with the getter
            onChanged: (newValues) {
              controllerForFilter.buyerPriceRange(newValues);
            },
          ),
        ),
        const SizedBox(height: 7),

        buildPropertyFilterHeadingPadding('BHK Type'),
        const SizedBox(height: 7),
        BHKTypes(
          bHKList: controllerForFilter.bHkType,
          onSelectionChanged: (index) {
            debugPrint('BHK Type $index');
          },
          controllerForFilter: controllerForFilter,
        ),
        const SizedBox(height: 7),

        buildPropertyFilterHeadingPadding('Property Types'),
        const SizedBox(height: 7),
        FilterPropertyTypesList(
          items: controllerForFilter.propertyTypesList,
          controllerForFilter: controllerForFilter,
          selectedItems: controllerForFilter.subpropertyType,
          onSelectionChanged: (index) {
            debugPrint('Sub property Type $index');
          },
        ),
        const SizedBox(height: 7),

        // buildFilterHeadingPadding('Listed By'),
        // const SizedBox(height: 7),
        // ListedBy(
        //   listedByList: listedByList,
        //   onTap: (index) {
        //     setState(() {});
        //   },
        // ),
        // const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Construction Status'),
        const SizedBox(height: 7),
        ListedBy(
          listedByList: controllerForFilter.constructionStatus,
          selectedString: controllerForFilter.constructionStatusInBuy,
          onTap: (index) {
            debugPrint('Construction Status $index');
          },
          controllerForFilter: controllerForFilter,
        ),
      ],
    );
  }
}
