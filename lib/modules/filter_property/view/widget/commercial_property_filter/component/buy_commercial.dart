import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/common_component/listed_by.dart';

import '../../buy_componet/buy_component.dart';
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
        buildPropertyFilterHeadingPadding("Property Type"),
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

        buildPropertyFilterHeadingPadding("Sale Type"),
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
        buildPropertyFilterHeadingPadding('Budget'),
        Obx(
          () => BudgetFilter(
            minValue: widget.controllerForFilter.commercialMin.value,
            maxValue: widget.controllerForFilter.commercialMax.value,
            values: widget.controllerForFilter.commercialRangeValues.value,
            onChanged: (value) {
              widget.controllerForFilter.changeTheValueOfCommercial(value);
            },
            minLabel: 'Min',
            maxLabel: 'Max',
            minQuantityLabel: 'L',
            maxQuantityLabel: 'Cr+',
          ),
        ),

        buildPropertyFilterHeadingPadding('Build-up Area'),
        Obx(
          () => BudgetFilter(
            minValue: widget.controllerForFilter.areaMin.value,
            maxValue: widget.controllerForFilter.areaMax.value,
            values: widget.controllerForFilter.areaRangeValues.value,
            onChanged: (value) {
              widget.controllerForFilter.changeCommercialArea(value);
            },
            minLabel: 'Min',
            maxLabel: 'Max',
            minQuantityLabel: 'sqft',
            maxQuantityLabel: 'sqft+',
          ),
        ),

        buildPropertyFilterHeadingPadding("Possession"),
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
        buildPropertyFilterHeadingPadding('Roi % p.a'),
        Obx(
          () => BudgetFilter(
            minValue: widget.controllerForFilter.roiMin.value,
            maxValue: widget.controllerForFilter.roiMax.value,
            values: widget.controllerForFilter.roiRangeValue.value,
            onChanged: (value) {
              widget.controllerForFilter.changeCommercialRoi(value);
            },
            minLabel: 'Min',
            maxLabel: 'Max',
            minQuantityLabel: '%',
            maxQuantityLabel: '%+',
          ),
        ),
        buildPropertyFilterHeadingPadding('Furnishing Type'),
        const SizedBox(height: 7),
        ListedBy(
          listedByList: widget.controllerForFilter.furnishingType,
          onTap: (items) {
            debugPrint('Furnishing $items');
          },
          controllerForFilter:widget. controllerForFilter,
          selectedString:widget. controllerForFilter.rentFurnishing,
        ),
        buildPropertyFilterHeadingPadding("Leased"),
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
