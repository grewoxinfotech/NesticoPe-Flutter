import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/utils/dummy_data.dart';
import 'package:housing_flutter_app/modules/filter_property/controller/property_filter_controller.dart';
import 'package:housing_flutter_app/modules/filter_property/view/widget/commercial_property_filter/component/buy_commercial.dart';
import 'package:housing_flutter_app/modules/search_property/view/search_screen.dart';
import 'package:housing_flutter_app/modules/search_property/widget/suggested_list.dart';

import 'component/rent_commercial_property.dart';

class CommercialPropertyFilter extends StatelessWidget {

  const CommercialPropertyFilter({super.key, required this.controller});
  final PropertyFilterControllerForFilter controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildFilterHeadingPadding('Sub category'),
        const SizedBox(height: 7),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () =>  Row(
              children: List.generate(controller.commercialSubCategory.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                     controller.updateFilter(controller.commercialSelectedSubCategory, controller.commercialSubCategory[index]);
debugPrint('category ${controller.commercialSelectedSubCategory.value}');
                    },
                    child: buildFilterPropertyTypes(
                      title: controller.commercialSubCategory[index],
                      isSelected: controller.commercialSelectedSubCategory.value ==controller.commercialSubCategory[index] ,
                      isExpanded: true,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 7),
        SingleChildScrollView(
          child: Obx(
            () =>  Column(
              children: [
                if (controller.commercialSelectedSubCategory.value == 'Buy') ...[
                   BuyCommercial(controllerForFilter: controller,),
                ] else ...[
                   RentCommercialProperty(controllerForFilter: controller,),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
