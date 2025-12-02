import '../../data/network/property/models/property_model.dart' as Items;
import '../../modules/add_property/model/add_property_model.dart'
    as AddPropertyModel;

extension ItemsMapper on Items.Items {
  AddPropertyModel.AddPropertyModel toAddPropertyModel() {
    return AddPropertyModel.AddPropertyModel(
      id: id,
      propertyMedia: propertyMedia != null ? _mapMedia(propertyMedia!) : null,
      createdBy: createdBy,
      updatedBy: updatedBy,
      title: title,
      type: type,
      listingType: listingType,
      propertyType: propertyType,
      propertyDescription: propertyDescription,
      propertyDetails:
          propertyDetails != null
              ? _mapPropertyDetails(propertyDetails!)
              : null,
      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      location: location,
      reraId: reraId,
      propertyStatus: propertyStatus,
      builderName: builderName,
      projectName: projectName,
      ownerPhone: ownerPhone,
      ownerName: ownerName,
      ownerEmail: ownerEmail,
    );
  }

  // Helper method to map PropertyDetails from Items to AddPropertyModel
  AddPropertyModel.PropertyDetails _mapPropertyDetails(
    Items.PropertyDetails source,
  ) {
    print("PropertyDetails ============ : ${source.amenities}");
    return AddPropertyModel.PropertyDetails(
      pgInfo: source.pgInfo != null ? _mapPgInfo(source.pgInfo!) : null,
      bhk: source.bhk,
      balcony: source.balcony,
      bathroom: source.bathroom,
      amenities: source.amenities,
      floorInfo:
          source.floorInfo != null ? _mapFloorInfo(source.floorInfo!) : null,
      furnishInfo:
          source.furnishInfo != null
              ? _mapFurnishInfo(source.furnishInfo!)
              : null,
      parkingInfo:
          source.parkingInfo != null
              ? _mapParkingInfo(source.parkingInfo!)
              : null,
      financialInfo:
          source.financialInfo != null
              ? _mapFinancialInfo(source.financialInfo!)
              : null,
      possessionInfo:
          source.possessionInfo != null
              ? _mapPossessionInfo(source.possessionInfo!)
              : null,
      propertyFacing: source.propertyFacing,
      propertyCarpetArea: source.propertyCarpetArea,
      propertyBuiltUpArea: source.propertyBuiltUpArea,
      propertyCondition: source.propertyCondition,
      propertyCarpetAreaUnit: source.propertyCarpetAreaUnit,
      propertyBuiltUpAreaUnit: source.propertyBuiltUpAreaUnit,
      plotInfo: source.plotInfo != null ? _mapPlotInfo(source.plotInfo!) : null,
      zoneType: source.zoneType,
      facilitiesInfo:
          source.facilitiesInfo != null
              ? _mapFacilitiesInfo(source.facilitiesInfo!)
              : null,
      petFriendly: source.petFriendly,
      lifInfo: source.liftInfo != null ? _mapLiftInfo(source.liftInfo!) : null,
      serventRoom: source.servantRoom,
      transactionType: source.transactionType,
    );
  }

  AddPropertyModel.PgInfo _mapPgInfo(Items.PgInfo source) {
    return AddPropertyModel.PgInfo(
      pgName: source.pgName,
      pgFor: source.pgFor,
      totalBed: source.totalBed,
      pgSuitedFor: source.pgSuitedFor,
      pgMealOffered: source.pgMealOffered,
      pgCommonArea: source.pgCommonArea,
      pgManageBy: source.pgManageBy,
      pgOwnerStaysAtPg: source.pgOwnerStaysAtPg,
      mealChargesPerMonth: source.mealChargesPerMonth,
      electricityChargesPerMonth: source.electricityChargesPerMonth,
      pgRules: source.pgRules != null ? _mapPgRules(source.pgRules!) : null,
      pgRoomInfo:
          source.pgRoomInfo?.map((room) => _mapPgRoomInfo(room)).toList(),
    );
  }

  AddPropertyModel.PgRules _mapPgRules(Items.PgRules source) {
    return AddPropertyModel.PgRules(
      nonVegAllowed: source.nonVegAllowed,
      petsAllowed: source.petsAllowed,
      lateEntryAllowed: source.lateEntryAllowed,
      smokingAllowed: source.smokingAllowed,
      drinkingAllowed: source.drinkingAllowed,
      visitorAllowed: source.visitorAllowed,
    );
  }

  AddPropertyModel.PgRoomInfo _mapPgRoomInfo(Items.PgRoomInfo source) {
    return AddPropertyModel.PgRoomInfo(
      roomType: source.roomType,
      rent: source.rent,
      securityDeposit: source.securityDeposit,
      roomFacilityInfo:
          source.roomFacilityInfo != null
              ? _mapRoomFacilityInfo(source.roomFacilityInfo!)
              : null,
    );
  }

  AddPropertyModel.RoomFacilityInfo _mapRoomFacilityInfo(
    Items.RoomFacilityInfo source,
  ) {
    return AddPropertyModel.RoomFacilityInfo(
      wifi: source.wifi,
      ac: source.ac,
      tv: source.tv,
      geyser: source.geyser,
      fridge: source.fridge,
      cupboard: source.cupboard,
      other: source.other,
    );
  }

  AddPropertyModel.FloorInfo _mapFloorInfo(Items.FloorInfo source) {
    return AddPropertyModel.FloorInfo(
      floorNumber: source.floorNumber,
      totalFloors: source.totalFloors,
    );
  }

  AddPropertyModel.PropertyFurnishInfo _mapFurnishInfo(
    Items.FurnishInfo source,
  ) {
    return AddPropertyModel.PropertyFurnishInfo(
      furnishType: source.furnishType,
      furnishDetails:
          source.furnishDetails != null
              ? _mapFurnishDetails(source.furnishDetails!)
              : null,
    );
  }

  AddPropertyModel.FurnishDetails _mapFurnishDetails(
    Items.FurnishDetails source,
  ) {
    return AddPropertyModel.FurnishDetails(
      washingMachine: source.washingMachine,
      cupboard: source.cupboard,
      stove: source.stove,
      fridge: source.fridge,
      waterPurifier: source.waterPurifier,
      modularKitchen: source.modularKitchen,
      ac: source.ac,
      bed: source.bed,
      geyser: source.geyser,
    );
  }

  AddPropertyModel.ParkingInfo _mapParkingInfo(Items.ParkingInfo source) {
    return AddPropertyModel.ParkingInfo(
      coveredParking: source.covered,
      openParking: source.open,
    );
  }

  AddPropertyModel.FinancialInfo _mapFinancialInfo(Items.FinancialInfo source) {
    return AddPropertyModel.FinancialInfo(
      propertyPrice: source.price,
      propertyRentPerMonth: source.propertyRentPerMonth,
      monthlyRent: source.monthlyRent,
      pricePerSqft: source.pricePerSqft,
      brokerCommission: source.brokerCommission,
      // brokerNegotiable: source.brokerNegotiable,
      propertySecurityDeposit: source.propertySecurityDeposit,
      lockInPeriod: source.lockInPeriod,
      noticePeriod: source.noticePeriod,
      negotiable: source.negotiable,
      maintenanceCharges: source.maintenance,
      // parkingCharges: source.parkingCharges,
    );
  }

  AddPropertyModel.PossessionInfo _mapPossessionInfo(
    Items.PossessionInfo source,
  ) {
    return AddPropertyModel.PossessionInfo(
      possessionStatus: source.possessionStatus,
      propertyAgeInYear: source.propertyAgeInYear,
      possessionDate: source.possessionDate,
    );
  }

  AddPropertyModel.PlotInfo _mapPlotInfo(Items.PlotInfo source) {
    return AddPropertyModel.PlotInfo(
      plotArea: source.plotArea,
      plotAreaUnit: source.plotAreaUnit,
      plotLength: source.plotLength,
      plotWidth: source.plotWidth,
      possessionStatus: source.possessionStatus,
      // possessionDate: source.possessionDate,
    );
  }

  AddPropertyModel.FacilitiesInfo _mapFacilitiesInfo(
    Items.FacilitiesInfo source,
  ) {
    return AddPropertyModel.FacilitiesInfo(
      minSeats: source.minSeats,
      numberOfCabins: source.numberOfCabins,
      numberOfMeetingRooms: source.numberOfMeetingRooms,
      minSeatsCamel: source.minSeatsCamel,
      numberOfCabinsCamel: source.numberOfCabinsCamel,
      numberOfMeetingRoomsCamel: source.numberOfMeetingRoomsCamel,
    );
  }

  AddPropertyModel.PropertyMedia _mapMedia(Items.PropertyMedia source) {
    print("_mapMedia called");
    print("Images: ${source.images}");
    print("Videos: ${source.videos}");
    print("Documents: ${source.documents}");

    final mapped = AddPropertyModel.PropertyMedia(
      images: source.images,
      videos: source.videos,
      documents: source.documents,
    );

    print("Mapped Media: ${mapped.toJson()}");
    return mapped;
  }

  AddPropertyModel.LiftInfo _mapLiftInfo(Items.LiftInfo source) {
    return AddPropertyModel.LiftInfo(serviceLift: source.serviceLift);
  }
}
