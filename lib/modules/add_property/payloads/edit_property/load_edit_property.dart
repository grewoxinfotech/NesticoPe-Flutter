import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/modules/add_property/model/add_property_model.dart';
import 'package:intl/intl.dart';

import '../../../../data/network/property/models/property_model.dart';
import '../../../../utils/logger/app_logger.dart';
import '../../../dashboard/views/dashboard_screen.dart';
import '../../controller/create_property_controller.dart';
import '../../model/photo_model.dart';

class LoadEditPropertyPayload extends GetxController {
  Rxn<AddPropertyModel> property = Rxn<AddPropertyModel>(null);

  void onLoad(CreatePropertyController controller, AddPropertyModel property) {
    AppLogger.structured("property", property.toJson());
    controller.propertyType.value =
        (property.type != null && property.type!.isNotEmpty)
            ? property.type!.capitalize.toString()
            : "";
    controller.lookingTo.value =
        (property.listingType != null && property.listingType!.isNotEmpty)
            ? property.listingType!
            : "";
    controller.rent_propertyType.value =
        (property.propertyType != null && property.propertyType!.isNotEmpty)
            ? property.propertyType!.replaceAll("_", " ").capitalize.toString()
            : "";
    controller.sell_rent_propertyDescriptionController.text =
        (property.propertyDescription != null &&
                property.propertyDescription!.isNotEmpty)
            ? property.propertyDescription!
            : "";

    controller.bhkType.value =
        (property.propertyDetails?.bhk != null &&
                property.propertyDetails!.bhk! != 0)
            ? "${property.propertyDetails!.bhk!} BHK"
            : "";

    controller.rent_Bathroom.value =
        (property.propertyDetails?.bathroom != null &&
                property.propertyDetails!.bathroom != 0)
            ? property.propertyDetails!.bathroom!
            : 0;
    controller.rent_Balcony.value =
        (property.propertyDetails?.balcony != null &&
                property.propertyDetails!.balcony != 0)
            ? property.propertyDetails!.balcony!
            : 0;

    controller.rent_Pet_Friendly.value =
        (property.propertyDetails?.petFriendly != null &&
                property.propertyDetails!.petFriendly!)
            ? 'Yes'
            : 'No';
    controller.cityController.text =
        (property.city != null && property.city!.isNotEmpty)
            ? property.city!
            : '';

    controller.localityController.text =
        (property.location != null && property.location!.isNotEmpty)
            ? property.location!
            : '';

    controller.sell_rent_Address.text =
        (property.address != null && property.address!.isNotEmpty)
            ? property.address!
            : '';

    controller.areaController.text =
        (property.propertyDetails?.propertyBuiltUpArea != null &&
                property.propertyDetails!.propertyBuiltUpArea != 0)
            ? property.propertyDetails!.propertyBuiltUpArea!.toStringAsFixed(0)
            : '';

    controller.carpetAreaController.text =
        (property.propertyDetails?.propertyCarpetArea != null &&
                property.propertyDetails!.propertyCarpetArea != 0)
            ? property.propertyDetails!.propertyCarpetArea!.toStringAsFixed(0)
            : '';

    controller.areaUnit.value =
        (property.propertyDetails?.propertyBuiltUpAreaUnit != null &&
                property.propertyDetails!.propertyBuiltUpAreaUnit!.isNotEmpty)
            ? addDotAfterEveryTwoCharacters(
              property.propertyDetails!.propertyBuiltUpAreaUnit!,
            )
            : 'sq.yd.';
    controller.carpetAreaUnit.value =
        (property.propertyDetails?.propertyCarpetAreaUnit != null &&
                property.propertyDetails!.propertyCarpetAreaUnit!.isNotEmpty)
            ? addDotAfterEveryTwoCharacters(
              property.propertyDetails!.propertyCarpetAreaUnit!,
            )
            : 'sq.yd.';

    controller.rent_CoveredParking.value =
        (property.propertyDetails?.parkingInfo?.coveredParking != null)
            ? "1"
            : '0';
    controller.rent_OpenParking.value =
        (property.propertyDetails?.parkingInfo?.openParking != null)
            ? "1"
            : '0';

    controller.rent_facing.value =
        (property.propertyDetails?.propertyFacing != null &&
                property.propertyDetails!.propertyFacing!.isNotEmpty)
            ? property.propertyDetails!.propertyFacing!
            : "";

    controller.sell_rent_Servent_Room.value =
        (property.propertyDetails?.serventRoom != null &&
                property.propertyDetails!.serventRoom!)
            ? 'Yes'
            : 'No';

    controller.sell_Rera_Id.text = property.reraId?.toString() ?? '';

    controller.transactionType.value =
        (property.propertyDetails?.transactionType != null &&
                property.propertyDetails!.transactionType!.isNotEmpty)
            ? property.propertyDetails!.transactionType!
                .replaceAll("_", " ")
                .capitalize!
                .toString()
            : "Resale";

    loadFinancialData(controller, property);
    loadPossessionInfo(controller, property);
    loadMedia(controller, property);
    loadFloorInfo(controller, property);
    loadFurnishingInfo(controller, property);
    loadAmenities(controller, property);
  }

  void loadFinancialData(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    /// Rent
    controller.rent_MonthilyRent.text = (pickFirstValid<double>([
              property.propertyDetails?.financialInfo?.monthlyRent,
              property.propertyDetails?.financialInfo?.propertyRentPerMonth,
            ]) ??
            0.0)
        .toStringAsFixed(0);

    /// Security Deposit
    controller.rent_SecurityDeposit.text =
        (property.propertyDetails?.financialInfo?.propertySecurityDeposit !=
                    null &&
                property
                        .propertyDetails!
                        .financialInfo!
                        .propertySecurityDeposit !=
                    0)
            ? property.propertyDetails!.financialInfo!.propertySecurityDeposit!
                .toStringAsFixed(0)
            : '0';

    /// Price for Sale
    controller.sell_ExpectedPrice.text =
        (property.propertyDetails?.financialInfo?.propertyPrice != null &&
                property.propertyDetails!.financialInfo!.propertyPrice != 0)
            ? property.propertyDetails!.financialInfo!.propertyPrice!
                .toStringAsFixed(0)
            : '0';

    /// Other Charges
    // maintenance Charge
    controller.sell_rent_Maintenance_Charges.text =
        (property.propertyDetails?.financialInfo?.maintenanceCharges != null &&
                property.propertyDetails!.financialInfo!.maintenanceCharges !=
                    0)
            ? property.propertyDetails!.financialInfo!.maintenanceCharges!
                .toStringAsFixed(0)
            : '0';

    // broker charges
    controller.doYouWantBrokerage.value =
        (property.propertyDetails?.financialInfo?.brokerCommission != null &&
                property.propertyDetails!.financialInfo!.brokerCommission! != 0)
            ? 'Yes'
            : 'No';

    controller.brokerageCharge.text =
        (property.propertyDetails?.financialInfo?.brokerCommission != null &&
                property.propertyDetails!.financialInfo!.brokerCommission != 0)
            ? property.propertyDetails!.financialInfo!.brokerCommission!
                .toStringAsFixed(0)
            : '0';

    controller.brokerageChargeNegotiable.value =
        (property.propertyDetails?.financialInfo?.brokerNegotiable != null &&
                property.propertyDetails!.financialInfo!.brokerNegotiable!)
            ? 'Yes'
            : 'No';

    controller.negotiablePriceOrNot.value =
        (property.propertyDetails?.financialInfo?.negotiable != null &&
                property.propertyDetails!.financialInfo!.negotiable!)
            ? 'Yes'
            : 'No';

    /// Notice Period
    controller.noticPeriodController.text =
        (property.propertyDetails?.financialInfo?.noticePeriod != null &&
                property.propertyDetails!.financialInfo!.noticePeriod != 0)
            ? property.propertyDetails!.financialInfo!.noticePeriod!.toString()
            : '0';

    /// Locked in Period
    controller.lockPeriodController.text =
        (property.propertyDetails?.financialInfo?.lockInPeriod != null &&
                property.propertyDetails!.financialInfo!.lockInPeriod != 0)
            ? property.propertyDetails!.financialInfo!.lockInPeriod!.toString()
            : '0';
  }

  void loadPossessionInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.ageOfPropertyController.text =
        (property.propertyDetails?.possessionInfo?.propertyAgeInYear != null &&
                property
                    .propertyDetails!
                    .possessionInfo!
                    .propertyAgeInYear!
                    .isNotEmpty)
            ? property.propertyDetails!.possessionInfo!.propertyAgeInYear!
                .toString()
            : '0';

    if (property.listingType != null &&
        property.listingType!.toLowerCase() == 'rent') {
      controller.rent_AvailableFrom.text =
          (property.propertyDetails?.possessionInfo?.possessionDate != null &&
                  property
                      .propertyDetails!
                      .possessionInfo!
                      .possessionDate!
                      .isNotEmpty)
              ? DateFormat('dd/MM/yyyy').format(
                DateTime.tryParse(
                  property.propertyDetails!.possessionInfo!.possessionDate!
                      .toString(),
                )!,
              )
              : '0';
    } else {
      controller.sell_AvailableFrom.text =
          (property.propertyDetails?.possessionInfo?.possessionDate != null &&
                  property
                      .propertyDetails!
                      .possessionInfo!
                      .possessionDate!
                      .isNotEmpty)
              ? DateFormat('dd/MM/yyyy').format(
                DateTime.tryParse(
                  property.propertyDetails!.possessionInfo!.possessionDate!
                      .toString(),
                )!,
              )
              : '0';
    }

    controller.sell_constructionStatus.value =
        (property.propertyDetails?.possessionInfo?.possessionStatus != null &&
                property
                    .propertyDetails!
                    .possessionInfo!
                    .possessionStatus!
                    .isNotEmpty)
            ? property.propertyDetails!.possessionInfo!.possessionStatus!
                .replaceAll("_", " ")
                .capitalize
                .toString()
            : " ";
  }

  void loadMedia(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    print("loadMedia called");
    print("loadMedia called : ${property.propertyMedia?.toJson()}");
    if (property.propertyMedia != null) {
      print("property.propertyMedia != null");
      if (property.propertyMedia!.images != null) {
        controller.imageList.value = property.propertyMedia!.images!;
        controller.imageList.map((element) => File(element)).toList();
      }
      if (property.propertyMedia!.videos != null) {
        controller.videoList.value = property.propertyMedia!.videos!;
        controller.videoList.map((element) => File(element)).toList();
      }
      if (property.propertyMedia!.documents != null) {
        controller.documentList.value = property.propertyMedia!.documents!;
        controller.documentList.map((element) => File(element)).toList();
      }

      print("imageList: ${controller.imageList}");
      print("videoList: ${controller.videoList}");
      print("documentList: ${controller.documentList}");
    }
  }

  void loadFloorInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.sell_rent_Total_Floor.text =
        (property.propertyDetails?.floorInfo?.totalFloors != null &&
                property.propertyDetails!.floorInfo!.totalFloors != 0)
            ? property.propertyDetails!.floorInfo!.totalFloors!.toString()
            : '0';

    controller.sell_rent_Floor_No.text =
        (property.propertyDetails?.floorInfo?.floorNumber != null &&
                property.propertyDetails!.floorInfo!.floorNumber != 0)
            ? property.propertyDetails!.floorInfo!.floorNumber!.toString()
            : '0';
  }

  void loadFurnishingInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.furnishingType.value =
        (property.propertyDetails?.furnishInfo?.furnishType != null &&
                property.propertyDetails!.furnishInfo!.furnishType!.isNotEmpty)
            ? property.propertyDetails!.furnishInfo!.furnishType!
                .replaceAll("-", " ")
                .capitalize
                .toString()
            : "";

    if (property.propertyDetails?.furnishInfo?.furnishDetails != null) {
      final furnishingDetails =
          property.propertyDetails!.furnishInfo!.furnishDetails!;
      controller.selectedFurnishing.value['ac']?.quantity =
          furnishingDetails.ac == true ? furnishingDetails.ac! : 0;
      controller.selectedFurnishing.value['bed']?.quantity =
          furnishingDetails.bed == true ? furnishingDetails.bed! : 0;
      controller.selectedFurnishing.value['geyser']?.quantity =
          furnishingDetails.geyser == true ? furnishingDetails.geyser! : 0;
      controller.selectedFurnishing.value['washing_machine']?.quantity =
          (furnishingDetails.washingMachine != null &&
                  furnishingDetails.washingMachine!)
              ? 1
              : 0;
      controller.selectedFurnishing.value['cupboard']?.quantity =
          (furnishingDetails.cupboard != null && furnishingDetails.cupboard!)
              ? 1
              : 0;
      controller.selectedFurnishing.value['stove']?.quantity =
          (furnishingDetails.stove != null && furnishingDetails.stove!) ? 1 : 0;
      controller.selectedFurnishing.value['fridge']?.quantity =
          (furnishingDetails.fridge != null && furnishingDetails.fridge!)
              ? 1
              : 0;
      controller.selectedFurnishing.value['water_purifier']?.quantity =
          (furnishingDetails.waterPurifier != null &&
                  furnishingDetails.waterPurifier!)
              ? 1
              : 0;
      controller.selectedFurnishing.value['modular_kitchen']?.quantity =
          (furnishingDetails.modularKitchen != null &&
                  furnishingDetails.modularKitchen!)
              ? 1
              : 0;
    }
  }

  void loadAmenities(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.selectedRoomAmenities.value =
        (property.propertyDetails!.amenities != null &&
                property.propertyDetails!.amenities!.isNotEmpty)
            ? property.propertyDetails!.amenities!
            : [];
  }

  String addDotAfterEveryTwoCharacters(String input) {
    return input.replaceAllMapped(RegExp(r'.{1,2}'), (match) {
      return "${match.group(0)}.";
    });
  }

  T? pickFirstValid<T>(List<T?> values) {
    for (var v in values) {
      if (v == null) continue;

      // If numeric → skip zero value
      if (v is num && v == 0) continue;

      return v;
    }
    return null;
  }
}
