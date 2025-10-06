import 'package:flutter/foundation.dart';

class ProjectVariant {
  String name;
  double builtUpArea;
  double carpetArea;
  double price;
  double? pricePerSqFt;
  int totalUnits;
  int availableUnits;
  List<String> specifications;

  ProjectVariant({
    required this.name,
    required this.builtUpArea,
    required this.carpetArea,
    required this.price,
    this.pricePerSqFt,
    required this.totalUnits,
    required this.availableUnits,
    List<String>? specifications,
  }) : specifications = specifications ?? [];
}

class ProjectConfiguration {
  int bhk;
  List<ProjectVariant> variants;

  ProjectConfiguration({
    required this.bhk,
    List<ProjectVariant>? variants,
  }) : variants = variants ?? [];
}

class ProjectSize {
  int totalBuildings;
  int totalUnits;

  ProjectSize({required this.totalBuildings, required this.totalUnits});
}

class ProjectContactInfo {
  String? name;
  String? phone;
  String? email;

  ProjectContactInfo({this.name, this.phone, this.email});
}

class ProjectModel {
  String projectName;
  double projectArea;
  ProjectSize projectSize;
  DateTime launchDate;
  DateTime possessionDate;
  List<ProjectConfiguration> configurations;
  String reraId;
  String? propertyTypes; // 'apartment' | ... | 'other'
  String status; // 'upcoming' | 'ongoing' | 'completed'
  String address;
  String city;
  String state;
  String zipCode;
  String location;
  List<Map<String, dynamic>>? nearbyLocations; // kept generic
  List<String> amenities;
  Map<String, dynamic>? brochure; // placeholder for media/meta
  List<String> projectHighlights;
  ProjectContactInfo? projectContactInfo;

  ProjectModel({
    required this.projectName,
    required this.projectArea,
    required this.projectSize,
    required this.launchDate,
    required this.possessionDate,
    required this.configurations,
    required this.reraId,
    this.propertyTypes,
    this.status = 'upcoming',
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.location,
    this.nearbyLocations,
    List<String>? amenities,
    this.brochure,
    List<String>? projectHighlights,
    this.projectContactInfo,
  })  : amenities = amenities ?? [],
        projectHighlights = projectHighlights ?? [];
}