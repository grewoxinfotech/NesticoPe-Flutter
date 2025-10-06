import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';

import '../../buy_componet/buy_component.dart';
import '../../common_component/budget_filter.dart';
import '../../common_component/listed_by.dart';

class RentCommercialProperty extends StatefulWidget {
  const RentCommercialProperty({super.key, required this.controllerForFilter});
  final PropertyFilterControllerForFilter controllerForFilter;

  @override
  State<RentCommercialProperty> createState() => _RentCommercialPropertyState();
}

class _RentCommercialPropertyState extends State<RentCommercialProperty> {
  String saleType = "New Properties";
  String possessionType = "Ready to move";
  String selectedLeased = 'Pre-Leased';
  int selectedAvailable = 0;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPropertyFilterHeadingPadding("Property Type"),
        const SizedBox(height: 7),
        ListedBy(listedByList: widget.controllerForFilter.buyCommercialPropertyType,onTap: (items) {
          debugPrint('Rent Commercial property $items');

        },controllerForFilter: widget.controllerForFilter,selectedString: widget.controllerForFilter.buySelectedCommercialPropertyTyp,),
        const SizedBox(height: 7),
        buildPropertyFilterHeadingPadding('Budget'),
        Obx(
          () =>  BudgetFilter(
            minValue: widget.controllerForFilter.commercialRentMin.value,
            maxValue: widget.controllerForFilter.commercialRentMax.value,
            values:widget.controllerForFilter.commercialRentRangeValue.value,
            onChanged: (value) {
              widget.controllerForFilter.changeCommercialRent(value);
            },
            minLabel: 'Min',
            maxLabel: 'Max',
            minQuantityLabel: 'L',
            maxQuantityLabel: 'Cr+',
          ),
        ),

        buildPropertyFilterHeadingPadding('Build-up Area'),
        Obx(
          () =>  BudgetFilter(
            minValue: widget.controllerForFilter.commercialRentAreaMin.value,
            maxValue: widget.controllerForFilter.commercialRentAreaMax.value,
            values: widget.controllerForFilter.commercialRentAreaRangeValue.value,
            onChanged: (value) {
              widget.controllerForFilter.changeCommercialAreaRent(value);
            },
            minLabel: 'Min',
            maxLabel: 'Max',
            minQuantityLabel: 'sqft',
            maxQuantityLabel: 'sqft+',
          ),
        ),

        buildPropertyFilterHeadingPadding("Available"),
        const SizedBox(height: 7),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () =>  Row(
              children: [
                ...List.generate(widget.controllerForFilter.availableList.length, (index) {
                  return GestureDetector(
                    onTap: () {
                      widget.controllerForFilter.updateFilter(widget.controllerForFilter.availableSelectedList, widget.controllerForFilter.availableList[index]);
                      debugPrint('Available ${widget.controllerForFilter.availableSelectedList.value}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: buildFilterPropertyTypes(
                        title: widget.controllerForFilter.availableList[index],
                        isSelected: widget.controllerForFilter.availableSelectedList.value == widget.controllerForFilter.availableList[index],
                        isExpanded: false,
                      ),
                    ),
                  );
                }),
                SizedBox(width: 10,)
              ],
            ),
          ),
        ),
        // const SizedBox(height: 7),
        // buildFilterHeadingPadding("Listed By"),
        //
        // const SizedBox(height: 7),
        // ListedBy(listedByList: listedByList),
        const SizedBox(height: 7),
      ],
    );
  }
}
