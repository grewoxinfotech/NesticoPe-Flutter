import 'package:housing_flutter_app/modules/add_property/model/photo_model.dart';

import '../controller/create_property_controller.dart';

// class PropertyPhoto {
//   final String path;     // file path
//   final String label;    // photo label (Kitchen, Balcony, etc.)
//   final bool isCover;    // cover image or not
//
//   PropertyPhoto({
//     required this.path,
//     this.label = "",
//     this.isCover = false,
//   });
//
//   factory PropertyPhoto.fromJson(Map<String, dynamic> json) {
//     return PropertyPhoto(
//       path: json['path'],
//       label: json['label'] ?? "",
//       isCover: json['isCover'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'path': path,
//       'label': label,
//       'isCover': isCover,
//     };
//   }
// }

class CommercialPropertyModel {
  final String buildingName;
  final String localityName;
  final String? propertyName;
  final String? possessionStatus;
  final String? availableFrom;
  final String? ageOfProperty;

  final String? zoneType;
  final String? locationHub;
  final String? otherLocation;

  final String? propertyCondition;
  final String? carpetArea;
  final String? carpetAreaUnit;
  final String? plotArea;
  final String? plotAreaUnit;
  final String? buildUpArea;
  final String? buildUpAreaUnit;

  final String? ownership;
  final String? constructionStatus;

  final String? seats;
  final String? cabins;
  final String? meetingRooms;

  final String? totalFloor;
  final String? yourFloor;

  /// 🔹 Financial
  final String? expectedRent;

  /// 🔹 Amenities (multi-select)
  final List<String> amenities;

  /// 🔹 Photos
  final List<PhotoImageModel> photos;

  CommercialPropertyModel({
    required this.buildingName,
    required this.localityName,
    this.propertyName,
    this.possessionStatus,
    this.availableFrom,
    this.ageOfProperty,
    this.zoneType,
    this.locationHub,
    this.otherLocation,
    this.propertyCondition,
    this.carpetArea,
    this.carpetAreaUnit,
    this.plotArea,
    this.plotAreaUnit,
    this.buildUpArea,
    this.buildUpAreaUnit,
    this.ownership,
    this.constructionStatus,
    this.seats,
    this.cabins,
    this.meetingRooms,
    this.totalFloor,
    this.yourFloor,
    this.expectedRent,
    this.amenities = const [],
    this.photos = const [],
  });

  /// Factory to build model from controller
  factory CommercialPropertyModel.fromController(CreatePropertyController controller) {
    return CommercialPropertyModel(
      buildingName: controller.commercial_rent_building_Name.text,
      localityName: controller.commercial_rent_Loaclity_Name.text,
      propertyName: controller.commercial_Property_Name.text,
      possessionStatus: controller.commercial_rent_posessionStatus.value,
      availableFrom: controller.commercial_rent_AvailableFrom.text,
      ageOfProperty: controller.commercial_rent_AgeOfPropertInYear.text,
      zoneType: controller.commercial_ZoneType.value,
      locationHub: controller.commercial_LocationHub.value,
      otherLocation: controller.commercial_other_Location.text,
      propertyCondition: controller.commercial_property_condition.value,
      carpetArea: controller.commercial_Square_CarpetArea.text,
      carpetAreaUnit: controller.commercial_Square_AreaUnti_Carpet.value,
      plotArea: controller.commercial_plot.text,
      plotAreaUnit: controller.commercial_plotArea.value,
      buildUpArea: controller.commercial_Square_BuildArea.text,
      buildUpAreaUnit: controller.commercial_Square_AreaUnti_Build.value,
      ownership: controller.commercial_ownerShipList.value,
      constructionStatus: controller.commercial_construction_status_value.value,
      seats: controller.commercial_seats.text,
      cabins: controller.commercial_cabins.text,
      meetingRooms: controller.commercial_meeting_room.text,
      totalFloor: controller.commercial_total_floor.text,
      yourFloor: controller.commercial_your_floor.text,

      /// Financial
      expectedRent: controller.commercial_rent_cost.text,

      /// Amenities
      amenities: controller.selectedCommercialAmenities.toList(),

      /// Photos
      photos: controller.selectedImages
          .map((img) => PhotoImageModel(
        path: img.path,
        label: img.label,
        isCover: img.isCover,
      ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "buildingName": buildingName,
      "localityName": localityName,
      "propertyName": propertyName,
      "possessionStatus": possessionStatus,
      "availableFrom": availableFrom,
      "ageOfProperty": ageOfProperty,
      "zoneType": zoneType,
      "locationHub": locationHub,
      "otherLocation": otherLocation,
      "propertyCondition": propertyCondition,
      "carpetArea": carpetArea,
      "carpetAreaUnit": carpetAreaUnit,
      "plotArea": plotArea,
      "plotAreaUnit": plotAreaUnit,
      "buildUpArea": buildUpArea,
      "buildUpAreaUnit": buildUpAreaUnit,
      "ownership": ownership,
      "constructionStatus": constructionStatus,
      "seats": seats,
      "cabins": cabins,
      "meetingRooms": meetingRooms,
      "totalFloor": totalFloor,
      "yourFloor": yourFloor,
      "expectedRent": expectedRent,
      "amenities": amenities,
      "photos": photos.map((e) => e.toMap()).toList(),
    };
  }
}
