import 'dart:io';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/manager/icon_manager.dart';
import 'package:housing_flutter_app/modules/add_property/model/add_property_model.dart';
import 'package:housing_flutter_app/modules/add_property/model/furnishing_,model.dart';
import 'package:intl/intl.dart';

import '../../../../utils/logger/app_logger.dart';

import '../../controller/create_property_controller.dart';

import '../../model/room_detail_model.dart';

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
            ? property.listingType!.toLowerCase() == 'pg'
                ? 'PG/Co-Living'
                : property.listingType!
            : "";

    controller.selectedIndex.value =
        (property.propertyType != null && property.propertyType!.isNotEmpty)
            ? property.propertyType!.toLowerCase() == 'others'
                ? 'Other'
                : property.propertyType!.toLowerCase() == 'retail_shop'
                ? 'Shop'
                : property.propertyType!
                    .replaceAll("_", " ")
                    .capitalize
                    .toString()
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

    controller.lift_info.value =
        (property.propertyDetails?.lifInfo?.serviceLift != null &&
                property.propertyDetails!.lifInfo!.serviceLift!)
            ? 'Yes'
            : 'No';

    loadFinancialData(controller, property);
    loadPossessionInfo(controller, property);
    loadMedia(controller, property);
    loadFloorInfo(controller, property);
    loadFurnishingInfo(controller, property);
    if (property.type!.toLowerCase() == 'commercial') {
      loadCommercialAmenities(controller, property);
      loadCommercialInfo(controller, property);
    } else {
      loadAmenities(controller, property);
    }
    loadPgInfo(controller, property);
  }

  void loadCommercialInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.commercial_rent_building_Name.text =
        (property.location != null && property.location!.isNotEmpty)
            ? property.location!
            : '';

    controller.commercial_rent_Loaclity_Name.text =
        (property.address != null && property.address!.isNotEmpty)
            ? property.address!
            : '';

    controller.commercial_ZoneType.value =
        (property.propertyDetails?.zoneType != null &&
                property.propertyDetails!.zoneType!.isNotEmpty)
            ? property.propertyDetails!.zoneType!
            : '';

    loadPlotInfo(controller, property);
    loadPropertyCondition(controller, property);
    loadOfficeInfo(controller, property);
  }

  void loadPropertyCondition(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.commercial_property_condition.value =
        (property.propertyDetails?.propertyCondition != null &&
                property.propertyDetails!.propertyCondition!.isNotEmpty)
            ? property.propertyDetails!.propertyCondition!.toLowerCase() ==
                    'ready_to_use'
                ? 'Ready to use'
                : 'Bare Shell'
            : '';
    controller.commercial_Square_BuildArea.text =
        (property.propertyDetails?.propertyBuiltUpArea != null &&
                property.propertyDetails!.propertyBuiltUpArea != 0)
            ? property.propertyDetails!.propertyBuiltUpArea!.toStringAsFixed(0)
            : '0';

    controller.commercial_Square_CarpetArea.text =
        (property.propertyDetails?.propertyCarpetArea != null &&
                property.propertyDetails!.propertyCarpetArea != 0)
            ? property.propertyDetails!.propertyCarpetArea!.toStringAsFixed(0)
            : '0';

    controller.commercial_Square_AreaUnti_Build.value =
        (property.propertyDetails?.propertyBuiltUpAreaUnit != null &&
                property.propertyDetails!.propertyBuiltUpAreaUnit!.isNotEmpty)
            ? addDotAfterEveryTwoCharacters(
              property.propertyDetails!.propertyBuiltUpAreaUnit!,
            )
            : 'sq.yd.';

    controller.commercial_Square_AreaUnti_Carpet.value =
        (property.propertyDetails?.propertyCarpetAreaUnit != null &&
                property.propertyDetails!.propertyCarpetAreaUnit!.isNotEmpty)
            ? addDotAfterEveryTwoCharacters(
              property.propertyDetails!.propertyCarpetAreaUnit!,
            )
            : 'sq.yd.';
  }

  void loadOfficeInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.commercial_seats.text =
        (property.propertyDetails?.facilitiesInfo?.minSeats != null &&
                property.propertyDetails!.facilitiesInfo!.minSeats != 0)
            ? property.propertyDetails!.facilitiesInfo!.minSeats.toString()
            : '0';

    controller.commercial_cabins.text =
        (property.propertyDetails?.facilitiesInfo?.numberOfCabins != null &&
                property.propertyDetails!.facilitiesInfo!.numberOfCabins != 0)
            ? property.propertyDetails!.facilitiesInfo!.numberOfCabins
                .toString()
            : '0';

    controller.commercial_meeting_room.text =
        (property.propertyDetails?.facilitiesInfo?.numberOfMeetingRooms !=
                    null &&
                property
                        .propertyDetails!
                        .facilitiesInfo!
                        .numberOfMeetingRooms !=
                    0)
            ? property.propertyDetails!.facilitiesInfo!.numberOfMeetingRooms
                .toString()
            : '0';
  }

  void loadPlotInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.commercial_plot.text =
        (property.propertyDetails?.plotInfo?.plotArea != null &&
                property.propertyDetails!.plotInfo!.plotArea != 0)
            ? property.propertyDetails!.plotInfo!.plotArea!.toStringAsFixed(0)
            : '0';
  }

  void loadFinancialData(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.commercial_rent_cost.text =
        (property.propertyDetails?.financialInfo?.propertyPrice != null &&
                property.propertyDetails!.financialInfo!.propertyPrice != 0)
            ? property.propertyDetails!.financialInfo!.propertyPrice!
                .toStringAsFixed(0)
            : '0';

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
    if (property.type!.toLowerCase() == 'commercial') {
      controller.commercial_rent_AgeOfPropertInYear.text =
          (property.propertyDetails?.possessionInfo?.propertyAgeInYear !=
                      null &&
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
        controller.commercial_rent_AvailableFrom.text =
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
        controller.commercial_rent_AvailableFrom.text =
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

      controller.commercial_rent_posessionStatus.value =
          (property.propertyDetails?.possessionInfo?.possessionStatus != null &&
                  property
                      .propertyDetails!
                      .possessionInfo!
                      .possessionStatus!
                      .isNotEmpty)
              ? property.propertyDetails!.possessionInfo!.possessionStatus! ==
                      'ready_to_move'
                  ? 'Ready to move'
                  : 'Under Construction'
              : " ";
    } else {
      controller.ageOfPropertyController.text =
          (property.propertyDetails?.possessionInfo?.propertyAgeInYear !=
                      null &&
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
  }

  void loadMedia(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    if (property.propertyMedia != null) {
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
    }
  }

  void loadFloorInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    if (property.type!.toLowerCase() == 'commercial') {
      controller.commercial_total_floor.text =
          (property.propertyDetails?.floorInfo?.totalFloors != null &&
                  property.propertyDetails!.floorInfo!.totalFloors != 0)
              ? property.propertyDetails!.floorInfo!.totalFloors!.toString()
              : '0';

      controller.commercial_your_floor.text =
          (property.propertyDetails?.floorInfo?.floorNumber != null &&
                  property.propertyDetails!.floorInfo!.floorNumber != 0)
              ? property.propertyDetails!.floorInfo!.floorNumber!.toString()
              : '0';
    } else {
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
      final f = property.propertyDetails!.furnishInfo!.furnishDetails!;
      // controller.selectedFurnishing['ac']?.quantity =
      //     furnishingDetails.ac == true ? furnishingDetails.ac! : 0;
      // ---------- Boolean Furnishings ----------
      loadItemByTitle(controller, "Dining Table", f.diningTable);
      loadItemByTitle(controller, "Washing Machine", f.washingMachine);
      loadItemByTitle(controller, "Cupboard", f.cupboard);
      loadItemByTitle(controller, "Sofa", f.sofa);
      loadItemByTitle(controller, "Microwave", f.microwave);
      loadItemByTitle(controller, "Stove", f.stove);
      loadItemByTitle(controller, "Fridge", f.fridge);
      loadItemByTitle(controller, "Water Purifier", f.waterPurifier);
      loadItemByTitle(controller, "Gas Pipeline", f.gasPipeline);
      loadItemByTitle(controller, "Chimney", f.chimney);
      loadItemByTitle(controller, "Modular Kitchen", f.modularKitchen);

      // ---------- Multi-choice Furnishings ----------
      loadItemByTitle(controller, "Fan", f.fan);
      loadItemByTitle(controller, "Light", f.light);
      loadItemByTitle(controller, "AC", f.ac);
      loadItemByTitle(controller, "Wardrobe", f.wardrobe);
      loadItemByTitle(controller, "TV", f.tv);
      loadItemByTitle(controller, "Bed", f.bed);
      loadItemByTitle(controller, "Geyser", f.geyser);

      // controller.selectedFurnishing['bed']?.quantity =
      //     furnishingDetails.bed == true ? furnishingDetails.bed! : 0;
      // controller.selectedFurnishing['geyser']?.quantity =
      //     furnishingDetails.geyser == true ? furnishingDetails.geyser! : 0;
      // controller.selectedFurnishing['washing_machine']?.quantity =
      //     (furnishingDetails.washingMachine != null &&
      //             furnishingDetails.washingMachine!)
      //         ? 1
      //         : 0;
      // controller.selectedFurnishing['cupboard']?.quantity =
      //     (furnishingDetails.cupboard != null && furnishingDetails.cupboard!)
      //         ? 1
      //         : 0;
      // controller.selectedFurnishing['stove']?.quantity =
      //     (furnishingDetails.stove != null && furnishingDetails.stove!) ? 1 : 0;
      // controller.selectedFurnishing['fridge']?.quantity =
      //     (furnishingDetails.fridge != null && furnishingDetails.fridge!)
      //         ? 1
      //         : 0;
      // controller.selectedFurnishing['water_purifier']?.quantity =
      //     (furnishingDetails.waterPurifier != null &&
      //             furnishingDetails.waterPurifier!)
      //         ? 1
      //         : 0;
      // controller.selectedFurnishing['modular_kitchen']?.quantity =
      //     (furnishingDetails.modularKitchen != null &&
      //             furnishingDetails.modularKitchen!)
      //         ? 1
      //         : 0;
    }

    print('Furnish Info:${controller.selectedFurnishing.value}');
  }

  void loadItemByTitle(
    CreatePropertyController controller,
    String title,
    dynamic count,
  ) {
    final icon = IconManager.furnitureItems.firstWhereOrNull(
      (i) => i.title == title,
    );

    if (icon == null) return;

    final qty = (count is int ? count : (count == true ? 1 : 0));

    if (qty > 0) {
      controller.selectedFurnishing[icon.key] = FurnishingItemModel(
        key: icon.key,
        title: icon.title,
        quantity: qty,
      );
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

  void loadCommercialAmenities(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    controller.selectedCommercialAmenities.value =
        (property.propertyDetails?.amenities != null &&
                property.propertyDetails!.amenities!.isNotEmpty)
            ? property.propertyDetails!.amenities!
            : [];
  }

  void loadPgInfo(
    CreatePropertyController controller,
    AddPropertyModel property,
  ) {
    /// pg name
    controller.pgNameController.text =
        (property.propertyDetails?.pgInfo?.pgName != null &&
                property.propertyDetails!.pgInfo!.pgName!.isNotEmpty)
            ? property.propertyDetails!.pgInfo!.pgName!
            : '';

    /// pg common area
    controller.commonAreasList.value =
        (property.propertyDetails?.pgInfo?.pgCommonArea != null &&
                property.propertyDetails!.pgInfo!.pgCommonArea!.isNotEmpty)
            ? property.propertyDetails!.pgInfo!.pgCommonArea!
                .split(',')
                .map((e) => e.trim())
                .toList()
            : [];

    /// pg total bed
    controller.totalRoomsController.text =
        (property.propertyDetails?.pgInfo?.totalBed != null &&
                property.propertyDetails!.pgInfo!.totalBed != 0)
            ? property.propertyDetails!.pgInfo!.totalBed!.toString()
            : '0';

    /// Pg For
    controller.pgFor.value =
        (property.propertyDetails?.pgInfo?.pgFor != null &&
                property.propertyDetails!.pgInfo!.pgFor!.isNotEmpty)
            ? property.propertyDetails!.pgInfo!.pgFor!
            : '';

    /// pg best suited for
    controller.bestSuitedList.value =
        (property.propertyDetails?.pgInfo?.pgSuitedFor != null &&
                property.propertyDetails!.pgInfo!.pgSuitedFor!.isNotEmpty)
            ? property.propertyDetails!.pgInfo!.pgSuitedFor!.split(',')
            : [];

    /// pg mea setails
    controller.mealAvailable.value =
        (property.propertyDetails?.pgInfo?.pgMealOffered != null &&
                property.propertyDetails!.pgInfo!.pgMealOffered!.isNotEmpty)
            ? 'Yes'
            : 'No';

    controller.mealAvailableList.value =
        (property.propertyDetails?.pgInfo?.pgMealOffered != null &&
                property.propertyDetails!.pgInfo!.pgMealOffered!.isNotEmpty)
            ? property.propertyDetails!.pgInfo!.pgMealOffered!
                .split(',')
                .map((e) => e.trim())
                .toList()
            : [];

    if ((property.propertyDetails?.pgInfo?.mealChargesPerMonth != null &&
        property.propertyDetails!.pgInfo!.mealChargesPerMonth != 0)) {
      controller.mealCharges.value = 'Separate';

      controller.mealChargesTextFiled.text = property
          .propertyDetails!
          .pgInfo!
          .mealChargesPerMonth!
          .toStringAsFixed(0);
    } else {
      controller.mealCharges.value = 'Included in rent';
    }

    /// electricity charge
    if ((property.propertyDetails?.pgInfo?.electricityChargesPerMonth != null &&
        property.propertyDetails!.pgInfo!.electricityChargesPerMonth != 0)) {
      controller.electricityCharges.value = 'Separate';

      controller.electricityChargesTextFiled.text = property
          .propertyDetails!
          .pgInfo!
          .electricityChargesPerMonth!
          .toStringAsFixed(0);
    } else {
      controller.electricityCharges.value = 'Included in rent';
    }

    /// PG Rules
    controller.pgRulesAvailable.value =
        (property.propertyDetails?.pgInfo?.pgRules != null &&
                (property.propertyDetails!.pgInfo!.pgRules!.visitorAllowed! ==
                        true ||
                    property.propertyDetails!.pgInfo!.pgRules!.petsAllowed! ==
                        true ||
                    property
                            .propertyDetails!
                            .pgInfo!
                            .pgRules!
                            .drinkingAllowed! ==
                        true ||
                    property
                            .propertyDetails!
                            .pgInfo!
                            .pgRules!
                            .smokingAllowed! ==
                        true ||
                    property.propertyDetails!.pgInfo!.pgRules!.nonVegAllowed! ==
                        true ||
                    property
                            .propertyDetails!
                            .pgInfo!
                            .pgRules!
                            .lateEntryAllowed! ==
                        true))
            ? 'Yes'
            : 'No';

    controller.visitorsAllowed.value =
        (property.propertyDetails?.pgInfo?.pgRules?.visitorAllowed != null &&
                property.propertyDetails!.pgInfo!.pgRules!.visitorAllowed!)
            ? 'Yes'
            : 'No';
    controller.petAllowed.value =
        (property.propertyDetails?.pgInfo?.pgRules?.petsAllowed != null &&
                property.propertyDetails!.pgInfo!.pgRules!.petsAllowed!)
            ? 'Yes'
            : 'No';
    controller.drinkingAllowed.value =
        (property.propertyDetails?.pgInfo?.pgRules?.drinkingAllowed != null &&
                property.propertyDetails!.pgInfo!.pgRules!.drinkingAllowed!)
            ? 'Yes'
            : 'No';
    controller.smokingAllowed.value =
        (property.propertyDetails?.pgInfo?.pgRules?.smokingAllowed != null &&
                property.propertyDetails!.pgInfo!.pgRules!.smokingAllowed!)
            ? 'Yes'
            : 'No';
    controller.nonVegAllowed.value =
        (property.propertyDetails?.pgInfo?.pgRules?.nonVegAllowed != null &&
                property.propertyDetails!.pgInfo!.pgRules!.nonVegAllowed!)
            ? 'Yes'
            : 'No';
    controller.letEntryAllowed.value =
        (property.propertyDetails?.pgInfo?.pgRules?.lateEntryAllowed != null &&
                property.propertyDetails!.pgInfo!.pgRules!.lateEntryAllowed!)
            ? 'Yes'
            : 'No';

    /// Pg managed by
    controller.propertyManagedBy.value =
        (property.propertyDetails?.pgInfo?.pgManageBy != null &&
                property.propertyDetails!.pgInfo!.pgManageBy!.isNotEmpty)
            ? property.propertyDetails!.pgInfo!.pgManageBy!.toLowerCase() ==
                    "other"
                ? "Professional"
                : property.propertyDetails!.pgInfo!.pgManageBy!.capitalize
                    .toString()
            : '';

    controller.managerStaysAtProperty.value =
        (property.propertyDetails?.pgInfo?.pgManageBy != null &&
                property.propertyDetails!.pgInfo!.pgManageBy!.isNotEmpty)
            ? 'Yes'
            : 'No';

    final pgRooms = property.propertyDetails?.pgInfo?.pgRoomInfo;

    controller.rooms.value =
        pgRooms?.map((e) {
          controller.roomFacilityAvailableOrNot.value = 'Yes';
          if (e.roomFacilityInfo != null) {
            controller.selectedRoomAmenitiesDataForPG.value = _mapPgAmenities(
              e.roomFacilityInfo,
            );
            print(
              '=========== ${controller.selectedRoomAmenitiesDataForPG.value}',
            );
            print('=========== ${_mapPgAmenities(e.roomFacilityInfo)}');
          }
          return RoomModel(
            monthlyRent:
                (e.rent != null && e.rent != 0)
                    ? e.rent!.toStringAsFixed(0)
                    : '0',
            deposit:
                (e.securityDeposit != null && e.securityDeposit != 0)
                    ? e.securityDeposit!.toStringAsFixed(0)
                    : '0',
            roomType:
                (e.roomType != null && e.roomType!.isNotEmpty)
                    ? e.roomType!.toString()
                    : '',
            amenities:
                (e.roomFacilityInfo != null)
                    ? _mapPgAmenities(e.roomFacilityInfo)
                    : [],
            // amenities: _mapAmenities(e.roomFacilityInfo),
            other: e.roomFacilityInfo?.other ?? '',
          );
        }).toList() ??
        [];
  }

  List<String> _mapPgAmenities(RoomFacilityInfo? info) {
    if (info == null) return [];

    final amenityMap = {
      'wifi': info.wifi,
      'ac': info.ac,
      'tv': info.tv,
      'geyser': info.geyser,
      'refrigerate': info.fridge,
      'cupboard': info.cupboard,
    };

    final List<String> data =
        amenityMap.entries
            .where((element) => element.value == true)
            .map((e) => e.key)
            .toList();

    return data;
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
