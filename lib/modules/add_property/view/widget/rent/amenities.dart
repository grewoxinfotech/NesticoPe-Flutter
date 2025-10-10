import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/app/utils/svg_widget.dart';
import 'package:housing_flutter_app/modules/add_property/controller/create_property_controller.dart';
import 'package:housing_flutter_app/modules/add_property/view/create_property.dart';

import '../../../../../app/constants/color_res.dart';

class RentAmenities extends StatelessWidget {
  final CreatePropertyController controller;
  const RentAmenities({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if ((controller.lookingTo.value =="Rent"||controller.lookingTo.value =="Sell") && controller.propertyType.value=="Residential") {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            buildSectionTitle("Flat Furnishing"),
            SizedBox(height: 8),
            // ...existing code...

               Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    IconManager.furnitureItems.map((e) {
                      final furnishing = controller.selectedFurnishing[e.key];
                      final isSelected = furnishing != null;
                      final quantity = furnishing?.quantity ?? 1;

                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: GestureDetector(
                          // Dart
                          onTap: () {
                            if (e.isMultiChoice) {
                              final furnishing = controller.selectedFurnishing[e.key];
                              if (furnishing != null) {
                                // If quantity > 1, increase; if quantity == 1, remove (deselect)
                                if (furnishing.quantity > 1) {
                                  controller.addOrUpdateFurnishing(e);
                                } else {
                                  controller.removeFurnishing(e);
                                }
                              } else {
                                controller.addOrUpdateFurnishing(e);
                              }
                            } else {
                              // Toggle select/deselect for non-multichoice
                              if (isSelected) {
                                controller.removeFurnishing(e);
                              } else {
                                controller.addOrUpdateFurnishing(e);
                              }
                            }
                          },

                          child: Container(
                            width: 95,
                            height: 110,
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1)
                                      : ColorRes.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Theme.of(context).primaryColor
                                        : ColorRes.leadGreyColor.shade300,
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: [
                                AppSvgIcon(
                                  assetName: e.key,
                                  size: 25,
                                  folder: 'furnishing',
                                  color:
                                      isSelected
                                          ? Theme.of(context).primaryColor
                                          : ColorRes.leadGreyColor.shade600,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  e.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Theme.of(context).primaryColor
                                            : ColorRes.black,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 10,
                                  ),
                                ),
                                if (e.isMultiChoice) ...[

                                  FittedBox(

                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.remove, size: 22),
                                          onPressed:
                                              () =>
                                                  controller.decreaseFurnishing(e),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                        ),
                                        Text(
                                          '$quantity',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add, size: 22),
                                          onPressed:
                                              () => controller
                                                  .addOrUpdateFurnishing(e),
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),

            SizedBox(height: 16),
            buildSectionTitle("Society Amenities"),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
              IconManager.amenitiesItems.map((e) {
                final isSelected = controller.selectedRoomAmenities.contains(e.key);

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () {
controller.addOrUpdateAmenities(e.key);
                    },
                    child: Container(
                      width: 95,
                      height: 110,
                      decoration: BoxDecoration(
                        color:
                        isSelected
                            ? Theme.of(
                          context,
                        ).primaryColor.withOpacity(0.1)
                            : ColorRes.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          isSelected
                              ? Theme.of(context).primaryColor
                              : ColorRes.leadGreyColor.shade300,
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          AppSvgIcon(
                            assetName: e.key,
                            size: 25,
                            folder: 'amenities',
                            color:
                            isSelected
                                ? Theme.of(context).primaryColor
                                : ColorRes.leadGreyColor.shade600,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            e.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                              isSelected
                                  ? Theme.of(context).primaryColor
                                  : ColorRes.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 10,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }
      else if((controller.lookingTo.value=="Rent"|| controller.lookingTo.value=="Sell" ) && controller.propertyType.value=="Commercial"){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            buildSectionTitle("Amenities"),
            SizedBox(height: 8),
            Obx(
                  () {
                final amenitiesList = (controller.selectedIndex.value == 'Shop' || controller.selectedIndex.value == 'Showroom')
                    ? IconManager.amenitiesDivided
                    : IconManager.amenities;

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: amenitiesList.map((e) {
                    final isSelected = controller.selectedCommercialAmenities.contains(e.title);

                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          controller.addCommercialAmenities(e.title);
                          print("vdsgvfsdfsd ${controller.selectedCommercialAmenities}");
                        },
                        child: Container(
                          width: 95,
                          height: 110,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor.withOpacity(0.1)
                                : ColorRes.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : ColorRes.leadGreyColor.shade300,
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 12,
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppSvgIcon(
                                assetName: e.key,
                                size: 25,
                                folder: 'amenities',
                                color: isSelected
                                    ? Theme.of(context).primaryColor
                                    : ColorRes.leadGreyColor.shade600,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                e.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isSelected
                                      ? Theme.of(context).primaryColor
                                      : ColorRes.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            )

          ],
        );
      }
      return SizedBox();
    });
  }
}
