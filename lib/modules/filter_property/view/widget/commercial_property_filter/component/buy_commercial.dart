import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/common_component/listed_by.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';

import '../../common_component/budget_filter.dart';
import '../../common_component/sale_type.dart';

class BuyCommercial extends StatefulWidget {
  const BuyCommercial({super.key, required this.controllerForFilter});

  final PropertyFilterControllerForFilter controllerForFilter;

  @override
  State<BuyCommercial> createState() => _BuyCommercialState();
}

class _BuyCommercialState extends State<BuyCommercial> {
  String saleType = "New Properties";
  String possessionType = "Ready to move";
  String selectedLeased = 'Pre-Leased';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFilterHeadingPadding("Property Type"),
        const SizedBox(height: 7),
        ListedBy(
          listedByList: widget.controllerForFilter.buyCommercialPropertyType,
          onTap: (items) {
            debugPrint('Property Type Commercial $items');
          },
          controllerForFilter: widget.controllerForFilter,
          selectedString:
              widget.controllerForFilter.buySelectedCommercialPropertyTyp,
        ),
        const SizedBox(height: 7),

        buildFilterHeadingPadding("Sale Type"),
        const SizedBox(height: 7),

        SelectableWrap(
          items: widget.controllerForFilter.saleTypeCommercialProperty,
          filterControllerForFilter: widget.controllerForFilter,
          selectedItem: widget.controllerForFilter.selectedSalesType,
          onSelected: (type) {

            debugPrint('Sale Type Commercial $type');

            setState(() {
              possessionType = type;
            });
          },
        ),

        const SizedBox(height: 7),
        buildFilterHeadingPadding('Budget'),
        BudgetFilter(
          minValue: 0.0,
          maxValue: 20,
          values: const RangeValues(1, 20),
          onChanged: (value) {},
          minLabel: 'Min',
          maxLabel: 'Max',
          minQuantityLabel: 'L',
          maxQuantityLabel: 'Cr+',
        ),

        buildFilterHeadingPadding('Build-up Area'),
        BudgetFilter(
          minValue: 0.0,
          maxValue: 4950,
          values: const RangeValues(50, 2000),
          onChanged: (value) {},
          minLabel: 'Min',
          maxLabel: 'Max',
          minQuantityLabel: 'sqft',
          maxQuantityLabel: 'sqft+',
        ),

        buildFilterHeadingPadding("Possession"),
        const SizedBox(height: 7),
        SelectableWrap(
          items: widget.controllerForFilter.possessionCommercialList,
          selectedItem: widget.controllerForFilter.selectedCommercialPossession,
          filterControllerForFilter: widget.controllerForFilter,
          onSelected: (type) {
            debugPrint('possession type $type');
          },
        ),
        const SizedBox(height: 7),
        // buildFilterHeadingPadding("Listed By"),
        // const SizedBox(height: 7),
        // ListedBy(listedByList: listedByList),
        const SizedBox(height: 7),
        buildFilterHeadingPadding('Roi % p.a'),
        BudgetFilter(
          minValue: 0.0,
          maxValue: 10,
          values: const RangeValues(4, 8),
          onChanged: (value) {},
          minLabel: 'Min',
          maxLabel: 'Max',
          minQuantityLabel: '%',
          maxQuantityLabel: '%+',
        ),
        buildFilterHeadingPadding("Leased"),
        SelectableWrap(
          items: widget.controllerForFilter.leaseTypeCommercialProperty,
          filterControllerForFilter: widget.controllerForFilter,
          selectedItem: widget.controllerForFilter.selectedCommercialLeased,
          onSelected: (value) {
            debugPrint('lease type $value');
          },
        ),
      ],
    );
  }
}
