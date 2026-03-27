import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:nesticope_app/modules/filter_property/controller/property_filter_controller.dart';

import '../common_component/bhk_list.dart';
import '../common_component/budget_filter.dart';
import '../common_component/listed_by.dart';
import 'buy_component.dart';

class BuyFilters extends StatefulWidget {
  final PropertyFilterControllerForFilter controllerForFilter;

  const BuyFilters({super.key, required this.controllerForFilter});

  @override
  State<BuyFilters> createState() => _BuyFiltersState();
}

class _BuyFiltersState extends State<BuyFilters> {
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPropertyFilterHeadingPadding('Budget Range'),

        // Obx(
        //   () => BudgetFilter(
        //     maxQuantityLabel: 'Cr+',
        //     minQuantityLabel: 'L',
        //     maxLabel: 'Max',
        //     minLabel: 'Min',
        //     minValue: controllerForFilter.min.value,
        //     maxValue: controllerForFilter.max.value,
        //     values: controllerForFilter.rangeValues,
        //     // Now this works with the getter
        //     onChanged: (newValues) {
        //       controllerForFilter.buyerPriceRange(newValues);
        //     },
        //   ),
        // ),
        Obx(
              () => BudgetFilterChange(
            minSelected: widget.controllerForFilter.min.value,
            maxSelected: widget.controllerForFilter.max.value,
            budgetList: widget.controllerForFilter.budgetValues.value,
            onMinChanged: (val) {
              if (val != null) {
                widget.controllerForFilter.min.value = val;
                print("Main ${widget.controllerForFilter.min.value}");
              }
            },
            onMaxChanged: (val) {
              if (val != null) {
                widget.controllerForFilter.max.value = val;

                print("mxa ${widget.controllerForFilter.max.value}");
              }
            },
            minLabel: "Min Budget",
            maxLabel: "Max Budget",
          ),
        ),


        const SizedBox(height: 7),

        buildPropertyFilterHeadingPadding('BHK Type'),
        const SizedBox(height: 7),
        BHKTypes(
          bHKList: widget.controllerForFilter.bHkType,
          onSelectionChanged: (index) {
            debugPrint('BHK Type $index');
          },
          controllerForFilter: widget.controllerForFilter,
        ),
        const SizedBox(height: 7),

        buildPropertyFilterHeadingPadding('Sub Property Types'),
        const SizedBox(height: 7),
        FilterPropertyTypesList(
          items: widget.controllerForFilter.propertyTypesList,
          controllerForFilter: widget.controllerForFilter,
          selectedItems: widget.controllerForFilter.subpropertyType,
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

        buildPropertyFilterHeadingPadding('Furnishing Type'),
        const SizedBox(height: 7),
        ListedBy(
          listedByList: widget.controllerForFilter.furnishingType,
          onTap: (items) {
            debugPrint('Furnishing $items');
          },
          controllerForFilter: widget.controllerForFilter,
          selectedString: widget.controllerForFilter.rentFurnishing,
        ),
      ],
    );
  }
}
