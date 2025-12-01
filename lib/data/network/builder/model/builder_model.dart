// // class ProjectVariant {
// //   String name;
// //   double builtUpArea;
// //   double carpetArea;
// //   double price;
// //   double? pricePerSqFt;
// //   int totalUnits;
// //   int availableUnits;
// //   List<String> specifications;
// //
// //   /// ✅ Added new optional fields
// //   List<String>? images;
// //   List<String>? videos;
// //
// //   ProjectVariant({
// //     required this.name,
// //     required this.builtUpArea,
// //     required this.carpetArea,
// //     required this.price,
// //     this.pricePerSqFt,
// //     required this.totalUnits,
// //     required this.availableUnits,
// //     List<String>? specifications,
// //     this.images,
// //     this.videos,
// //   }) : specifications = specifications ?? [];
// //
// //   Map<String, dynamic> toJson() => {
// //     'name': name,
// //     'builtUpArea': builtUpArea,
// //     'carpetArea': carpetArea,
// //     'price': price,
// //     'pricePerSqFt': pricePerSqFt,
// //     'totalUnits': totalUnits,
// //     'availableUnits': availableUnits,
// //     'specifications': specifications,
// //     // ✅ Include image & video lists in toJson
// //     'images': images,
// //     'videos': videos,
// //   };
// //
// //   factory ProjectVariant.fromJson(Map<String, dynamic> json) => ProjectVariant(
// //     name: json['name'] ?? '',
// //     builtUpArea: (json['builtUpArea'] ?? 0).toDouble(),
// //     carpetArea: (json['carpetArea'] ?? 0).toDouble(),
// //     price: (json['price'] ?? 0).toDouble(),
// //     pricePerSqFt: json['pricePerSqFt']?.toDouble(),
// //     totalUnits: json['totalUnits'] ?? 0,
// //     availableUnits: json['availableUnits'] ?? 0,
// //     specifications: List<String>.from(json['specifications'] ?? []),
// //
// //     // ✅ Safely parse image & video lists (nullable)
// //     images: json['images'] != null ? List<String>.from(json['images']) : null,
// //     videos: json['videos'] != null ? List<String>.from(json['videos']) : null,
// //   );
// // }
// //
// // class ProjectConfiguration {
// //   int bhk;
// //   List<ProjectVariant> variants;
// //
// //   ProjectConfiguration({required this.bhk, List<ProjectVariant>? variants})
// //     : variants = variants ?? [];
// //
// //   Map<String, dynamic> toJson() => {
// //     'bhk': bhk,
// //     'variants': variants.map((v) => v.toJson()).toList(),
// //   };
// //
// //   factory ProjectConfiguration.fromJson(Map<String, dynamic> json) =>
// //       ProjectConfiguration(
// //         bhk: json['bhk'] ?? 1,
// //         variants:
// //             (json['variants'] as List<dynamic>? ?? [])
// //                 .map((v) => ProjectVariant.fromJson(v))
// //                 .toList(),
// //       );
// // }
// //
// // class ProjectSize {
// //   int totalBuildings;
// //   int totalUnits;
// //
// //   ProjectSize({required this.totalBuildings, required this.totalUnits});
// //
// //   Map<String, dynamic> toJson() => {
// //     'totalBuildings': totalBuildings,
// //     'totalUnits': totalUnits,
// //   };
// //
// //   factory ProjectSize.fromJson(Map<String, dynamic> json) => ProjectSize(
// //     totalBuildings: json['totalBuildings'] ?? 0,
// //     totalUnits: json['totalUnits'] ?? 0,
// //   );
// // }
// //
// // class ProjectContactInfo {
// //   String? name;
// //   String? phone;
// //   String? email;
// //
// //   ProjectContactInfo({this.name, this.phone, this.email});
// //
// //   Map<String, dynamic> toJson() => {
// //     'name': name,
// //     'phone': phone,
// //     'email': email,
// //   };
// //
// //   factory ProjectContactInfo.fromJson(Map<String, dynamic> json) =>
// //       ProjectContactInfo(
// //         name: json['name'],
// //         phone: json['phone'],
// //         email: json['email'],
// //       );
// // }
// //
// // class AddProjectModel {
// //   String? id;
// //   MediaGallery mediaGallery;
// //   String projectName;
// //   double projectArea;
// //   ProjectSize projectSize;
// //   DateTime launchDate;
// //   DateTime possessionDate;
// //   List<ProjectConfiguration> configurations;
// //   String reraId;
// //   String? propertyTypes;
// //   String status;
// //   String address;
// //   String city;
// //   String state;
// //   String zipCode;
// //   String location;
// //   List<Map<String, dynamic>> nearbyLocations;
// //   List<String> amenities;
// //   List<String> imageList;
// //   List<String> videoList;
// //   String? brochure;
// //   String? pdfPath;
// //   List<String> projectHighlights;
// //   ProjectContactInfo? projectContactInfo;
// //
// //   AddProjectModel({
// //     this.id,
// //     required this.mediaGallery,
// //     required this.projectName,
// //     required this.projectArea,
// //     required this.projectSize,
// //     required this.launchDate,
// //     required this.possessionDate,
// //     required this.configurations,
// //     required this.reraId,
// //     this.propertyTypes,
// //     this.status = 'upcoming',
// //     required this.address,
// //     required this.city,
// //     required this.state,
// //     required this.zipCode,
// //     required this.location,
// //     List<Map<String, dynamic>>? nearbyLocations,
// //     List<String>? amenities,
// //     this.brochure,
// //     this.pdfPath,
// //     List<String>? projectHighlights,
// //     this.projectContactInfo,
// //     List<String>? imageList,
// //     List<String>? videoList,
// //   }) : nearbyLocations = nearbyLocations ?? [],
// //        amenities = amenities ?? [],
// //        projectHighlights = projectHighlights ?? [],
// //        imageList = imageList ?? [],
// //        videoList = videoList ?? [];
// //
// //   Map<String, dynamic> toJson() => {
// //     'projectName': projectName,
// //     'projectArea': projectArea,
// //     'projectSize': projectSize.toJson(), // ✅ fixed here
// //     'launchDate': launchDate.toIso8601String(),
// //     'possessionDate': possessionDate.toIso8601String(),
// //     'reraId': reraId,
// //     'propertyTypes': propertyTypes,
// //     'status': status,
// //     'address': address,
// //     'city': city,
// //     'state': state,
// //     'zipCode': zipCode,
// //     'location': location,
// //     'pdfPath': pdfPath,
// //     'nearbyLocations': nearbyLocations,
// //     'configurations': configurations.map((c) => c.toJson()).toList(),
// //     'amenities': amenities,
// //     'imageList': imageList,
// //     'videoList': videoList,
// //     'brochure': brochure,
// //     'projectHighlights': projectHighlights,
// //     'projectContactInfo': projectContactInfo?.toJson(),
// //   };
// //
// //   factory AddProjectModel.fromJson(Map<String, dynamic> json) =>
// //       AddProjectModel(
// //         id: json['id'] ?? '',
// //         mediaGallery:
// //             json['mediaGallery'] != null
// //                 ? MediaGallery.fromJson(json['mediaGallery'])
// //                 : MediaGallery(images: [], videos: []),
// //         projectName: json['projectName'] ?? '',
// //         projectArea:
// //             json['projectArea'] is num
// //                 ? (json['projectArea'] as num).toDouble()
// //                 : double.tryParse(json['projectArea'].toString()) ?? 0.0,
// //
// //         projectSize:
// //             json['projectSize'] != null
// //                 ? ProjectSize.fromJson(json['projectSize'])
// //                 : ProjectSize(totalBuildings: 0, totalUnits: 0),
// //         launchDate:
// //             json['launchDate'] != null
// //                 ? DateTime.parse(json['launchDate'])
// //                 : DateTime.now(),
// //         possessionDate:
// //             json['possessionDate'] != null
// //                 ? DateTime.parse(json['possessionDate'])
// //                 : DateTime.now(),
// //         configurations:
// //             (json['configurations'] as List<dynamic>? ?? [])
// //                 .map((c) => ProjectConfiguration.fromJson(c))
// //                 .toList(),
// //         reraId: json['reraId'] ?? '',
// //         propertyTypes: json['propertyTypes'],
// //         status: json['status'] ?? 'upcoming',
// //         address: json['address'] ?? '',
// //         city: json['city'] ?? '',
// //         state: json['state'] ?? '',
// //         zipCode: json['zipCode'] ?? '',
// //         location: json['location'] ?? '',
// //         pdfPath: json['pdfPath'],
// //         nearbyLocations: List<Map<String, dynamic>>.from(
// //           json['nearbyLocations'] ?? [],
// //         ),
// //         amenities: List<String>.from(json['amenities'] ?? []),
// //
// //         brochure:
// //             json['brochure'] is String
// //                 ? json['brochure']
// //                 : json['brochure']?['url'],
// //         projectHighlights: List<String>.from(json['projectHighlights'] ?? []),
// //         projectContactInfo:
// //             json['projectContactInfo'] != null
// //                 ? ProjectContactInfo.fromJson(json['projectContactInfo'])
// //                 : null,
// //       );
// // }
// //
// // class MediaGallery {
// //   final List<String>? images;
// //   final List<String>? videos;
// //   final List<String>? documents;
// //
// //   MediaGallery({this.images, this.videos, this.documents});
// //
// //   factory MediaGallery.fromJson(Map<String, dynamic> json) {
// //     return MediaGallery(
// //       images:
// //           (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
// //       videos:
// //           (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
// //       documents:
// //           (json['documents'] as List<dynamic>?)
// //               ?.map((e) => e as String)
// //               .toList(),
// //     );
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {'images': images, 'videos': videos, 'documents': documents};
// //   }
// //
// //   MediaGallery copyWith({List<String>? images, List<String>? videos}) {
// //     return MediaGallery(
// //       images: images ?? this.images,
// //       videos: videos ?? this.videos,
// //       documents: documents ?? this.documents,
// //     );
// //   }
// // }
// //
// // class Brochure {
// //   final String? url;
// //   final String? name;
// //
// //   Brochure({this.url, this.name});
// //
// //   factory Brochure.fromJson(Map<String, dynamic> json) {
// //     return Brochure(url: json['url'] as String?, name: json['name'] as String?);
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     return {'url': url, 'name': name};
// //   }
// //
// //   Brochure copyWith({String? url, String? name}) {
// //     return Brochure(url: url ?? this.url, name: name ?? this.name);
// //   }
// // }
//
// import 'dart:convert';
//
// import 'package:housing_flutter_app/app/utils/formater/formater.dart';
//
// /// ===============================
// /// 🔹 COMMON MODELS (Shared by both)
// /// ===============================
//
// class MediaGallery {
//   final List<String> images;
//   final List<String> videos;
//   final List<String> documents;
//
//   MediaGallery({
//     this.images = const [],
//     this.videos = const [],
//     this.documents = const [],
//   });
//
//   factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
//     images: List<String>.from(json['images'] ?? []),
//     videos: List<String>.from(json['videos'] ?? []),
//     documents: List<String>.from(json['documents'] ?? []),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'images': images,
//     'videos': videos,
//     'documents': documents,
//   };
// }
//
// class ProjectSize {
//   int totalBuildings;
//   int totalUnits;
//
//   ProjectSize({required this.totalBuildings, required this.totalUnits});
//
//   factory ProjectSize.fromJson(Map<String, dynamic> json) => ProjectSize(
//     totalBuildings: json['totalBuildings'] ?? 0,
//     totalUnits: json['totalUnits'] ?? 0,
//   );
//
//   Map<String, dynamic> toJson() => {
//     'totalBuildings': totalBuildings,
//     'totalUnits': totalUnits,
//   };
// }
//
// class ProjectContactInfo {
//   String? name;
//   String? phone;
//   String? email;
//
//   ProjectContactInfo({this.name, this.phone, this.email});
//
//   factory ProjectContactInfo.fromJson(Map<String, dynamic> json) =>
//       ProjectContactInfo(
//         name: json['name'],
//         phone: json['phone'],
//         email: json['email'],
//       );
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'phone': phone,
//     'email': email,
//   };
// }
//
// class Brochure {
//   final String? url;
//   final String? name;
//
//   Brochure({this.url, this.name});
//
//   factory Brochure.fromJson(Map<String, dynamic> json) =>
//       Brochure(url: json['url'], name: json['name']);
//
//   Map<String, dynamic> toJson() => {'url': url, 'name': name};
// }
//
// /// ===============================
// /// 🔹 VARIANTS / CONFIGURATIONS
// /// ===============================
//
// class ProjectVariant {
//   String name;
//   double builtUpArea;
//   double carpetArea;
//   double price;
//   double? pricePerSqFt;
//   int totalUnits;
//   int availableUnits;
//   List<String> specifications;
//   List<String> images;
//   List<String> videos;
//
//   ProjectVariant({
//     required this.name,
//     required this.builtUpArea,
//     required this.carpetArea,
//     required this.price,
//     this.pricePerSqFt,
//     required this.totalUnits,
//     required this.availableUnits,
//     this.specifications = const [],
//     this.images = const [],
//     this.videos = const [],
//   });
//
//   factory ProjectVariant.fromJson(Map<String, dynamic> json) => ProjectVariant(
//     name: json['name'] ?? '',
//     builtUpArea: (json['builtUpArea'] ?? 0).toDouble(),
//     carpetArea: (json['carpetArea'] ?? 0).toDouble(),
//     price: (json['price'] ?? 0).toDouble(),
//     pricePerSqFt: json['pricePerSqFt']?.toDouble(),
//     totalUnits: json['totalUnits'] ?? 0,
//     availableUnits: json['availableUnits'] ?? 0,
//     specifications: List<String>.from(json['specifications'] ?? []),
//     images: List<String>.from(json['images'] ?? []),
//     videos: List<String>.from(json['videos'] ?? []),
//   );
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'builtUpArea': builtUpArea,
//     'carpetArea': carpetArea,
//     'price': price,
//     'pricePerSqFt': pricePerSqFt,
//     'totalUnits': totalUnits,
//     'availableUnits': availableUnits,
//     'specifications': specifications,
//     'images': images,
//     'videos': videos,
//   };
// }
//
// class ProjectConfiguration {
//   int bhk;
//   List<ProjectVariant> variants;
//
//   ProjectConfiguration({required this.bhk, this.variants = const []});
//
//   factory ProjectConfiguration.fromJson(Map<String, dynamic> json) =>
//       ProjectConfiguration(
//         bhk: json['bhk'] ?? 0,
//         variants:
//             (json['variants'] as List<dynamic>? ?? [])
//                 .map((v) => ProjectVariant.fromJson(v))
//                 .toList(),
//       );
//
//   Map<String, dynamic> toJson() => {
//     'bhk': bhk,
//     'variants': variants.map((v) => v.toJson()).toList(),
//   };
// }
//
// /// ===============================
// /// 🔹 MODEL FOR ADDING PROJECT (used for API POST/PUT)
// /// ===============================
//
import 'dart:io';

import '../../../../app/utils/formater/formater.dart';

class AddProjectModel {
  String? id;
  String projectName;
  double projectArea;
  ProjectSize projectSize;
  DateTime launchDate;
  DateTime possessionDate;
  List<ProjectConfiguration> configurations;
  String reraId;
  String? propertyTypes;
  String status;
  String address;
  String city;
  String state;
  String zipCode;
  String location;
  List<Map<String, dynamic>> nearbyLocations;
  List<String> amenities;
  List<String> projectHighlights;
  MediaGallery? mediaGallery;
  List<String> imageList;
  List<String> videoList;
  List<String> documentList;
  String? brochure;
  String? pdfPath;
  ProjectContactInfo? projectContactInfo;

  AddProjectModel({
    this.id,
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
    this.nearbyLocations = const [],
    this.amenities = const [],
    this.projectHighlights = const [],
    this.mediaGallery,
    this.imageList = const [],
    this.videoList = const [],
    this.documentList = const [],
    this.brochure,
    this.pdfPath,
    this.projectContactInfo,
  });

  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'projectArea': projectArea,
    'projectSize': projectSize.toJson(),
    'launchDate': launchDate.toIso8601String(),
    'possessionDate': possessionDate.toIso8601String(),
    'reraId': reraId,
    'propertyTypes': propertyTypes,
    'status': status,
    'address': address,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'location': location,
    'configurations': configurations.map((c) => c.toJson()).toList(),
    'nearbyLocations': nearbyLocations,
    'amenities': amenities,
    'projectHighlights': projectHighlights,
    'mediaGallery': mediaGallery?.toJson(),
    'imageList': imageList,
    'videoList': videoList,
    'documentList': documentList,
    'brochure': brochure,
    'pdfPath': pdfPath,
    'projectContactInfo': projectContactInfo?.toJson(),
  };
}

// /// ===============================
// /// 🔹 MODEL FOR FETCHING PROJECT (used for GET/List/Detail)
// /// ===============================
//
// class ProjectItem {
//   final String id;
//   final String projectId;
//   final String projectName;
//   final String projectArea;
//   final ProjectSize? projectSize;
//   final String? launchDate;
//   final String? possessionDate;
//   final List<ProjectConfiguration> configuration;
//   final String reraId;
//   final String propertyTypes;
//   final ProjectContactInfo? projectContactInfo;
//   final String status;
//   final String address;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String? location;
//   final List<NearbyLocation> nearbyLocations;
//
//   final List<String> amenities;
//   final List<String> projectHighlights;
//   final MediaGallery? mediaGallery;
//   final List<Brochure> brochures;
//   final bool isVerified;
//   final bool isActive;
//   final String? createdAt;
//   final String? updatedAt;
//
//   ProjectItem({
//     required this.id,
//     required this.projectId,
//     required this.projectName,
//     required this.projectArea,
//     required this.projectSize,
//     required this.launchDate,
//     required this.possessionDate,
//     required this.configuration,
//     required this.reraId,
//     required this.propertyTypes,
//     required this.projectContactInfo,
//     required this.status,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.location,
//     required this.nearbyLocations,
//     required this.amenities,
//     required this.projectHighlights,
//     required this.mediaGallery,
//     required this.brochures,
//     required this.isVerified,
//     required this.isActive,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
//     id: json['id'] ?? '',
//     projectId: json['projectId'] ?? '',
//     projectName: json['projectName'] ?? '',
//     projectArea: json['projectArea']?.toString() ?? '',
//     projectSize:
//         json['projectSize'] != null
//             ? ProjectSize.fromJson(json['projectSize'])
//             : null,
//     launchDate: json['launchDate'],
//     possessionDate: json['possessionDate'],
//     configuration:
//         (json['configurations'] as List<dynamic>? ?? [])
//             .map((v) => ProjectConfiguration.fromJson(v))
//             .toList(),
//     reraId: json['reraId'] ?? '',
//     propertyTypes: json['propertyTypes'] ?? '',
//     projectContactInfo:
//         json['projectContactInfo'] != null
//             ? ProjectContactInfo.fromJson(json['projectContactInfo'])
//             : null,
//     status: json['status'] ?? '',
//     address: json['address'] ?? '',
//     city: json['city'] ?? '',
//     state: json['state'] ?? '',
//     zipCode: json['zipCode'] ?? '',
//     location: json['location'],
//     nearbyLocations: (json['nearbyLocations'] as List ?? [])
//         .map((e) => NearbyLocation.fromJson(e))
//         .toList(),
//
//     amenities: List<String>.from(json['amenities'] ?? []),
//     projectHighlights: List<String>.from(json['projectHighlights'] ?? []),
//     mediaGallery:
//         json['mediaGallery'] != null
//             ? MediaGallery.fromJson(json['mediaGallery'])
//             : null,
//     brochures:
//         (json['brochures'] as List<dynamic>? ?? [])
//             .map((e) => Brochure.fromJson(e))
//             .toList(),
//     isVerified: json['isVerified'] ?? false,
//     isActive: json['isActive'] ?? false,
//     createdAt: json['createdAt'],
//     updatedAt: json['updatedAt'],
//   );
//
//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'projectId': projectId,
//     'projectName': projectName,
//     'projectArea': projectArea,
//     'projectSize': projectSize?.toJson(),
//     'launchDate': launchDate,
//     'possessionDate': possessionDate,
//     'configurations': configuration.map((v) => v.toJson()).toList(),
//     'reraId': reraId,
//     'propertyTypes': propertyTypes,
//     'projectContactInfo': projectContactInfo?.toJson(),
//     'status': status,
//     'address': address,
//     'city': city,
//     'state': state,
//     'zipCode': zipCode,
//     'location': location,
//     'nearbyLocations': nearbyLocations.map((e) => e.toJson()).toList(),
//
//     'amenities': amenities,
//     'projectHighlights': projectHighlights,
//     'mediaGallery': mediaGallery?.toJson(),
//     'brochures': brochures.map((e) => e.toJson()).toList(),
//     'isVerified': isVerified,
//     'isActive': isActive,
//     'createdAt': createdAt,
//     'updatedAt': updatedAt,
//   };
//
// }
// extension ProjectItemPriceRange on ProjectItem {
//   String getPriceRange() {
//     final prices = configuration
//         .expand((config) => config.variants)
//         .map((variant) => variant.price)
//         .where((p) => p > 0)
//         .toList();
//
//     if (prices.isEmpty) return "Price not available";
//
//     final minPrice = prices.reduce((a, b) => a < b ? a : b);
//     final maxPrice = prices.reduce((a, b) => a > b ? a : b);
//
//     return minPrice == maxPrice
//         ? Formatter.formatPrice(minPrice)
//         : "${Formatter.formatPrice(minPrice)} - ${Formatter.formatNumber(maxPrice)}";
//   }
// }
//
// class NearbyLocation {
//   final String name;
//   final String distance;
//
//   NearbyLocation({required this.name, required this.distance});
//
//   factory NearbyLocation.fromJson(Map<String, dynamic> json) => NearbyLocation(
//     name: json['name'] ?? '',
//     distance: json['distance'] ?? '',
//   );
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'distance': distance,
//   };
// }

/// ===============================
/// 🔹 COMMON MODELS
/// ===============================

class MediaGallery {
  final List<String> images;
  final List<String> videos;
  final List<String> documents;

  MediaGallery({
    this.images = const [],
    this.videos = const [],
    this.documents = const [],
  });

  factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
    images: List<String>.from(json['images'] ?? []),
    videos: List<String>.from(json['videos'] ?? []),
    documents: List<String>.from(json['documents'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'images': images,
    'videos': videos,
    'documents': documents,
  };
}

class ProjectSize {
  int totalBuildings;
  int totalUnits;

  ProjectSize({required this.totalBuildings, required this.totalUnits});

  factory ProjectSize.fromJson(Map<String, dynamic> json) => ProjectSize(
    totalBuildings: json['totalBuildings'] ?? 0,
    totalUnits: json['totalUnits'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'totalBuildings': totalBuildings,
    'totalUnits': totalUnits,
  };
}

class ProjectContactInfo {
  String? name;
  String? phone;
  String? email;

  ProjectContactInfo({this.name, this.phone, this.email});

  factory ProjectContactInfo.fromJson(Map<String, dynamic> json) =>
      ProjectContactInfo(
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
      );

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
  };
}

class Brochure {
  final String? url;
  final String? name;

  Brochure({this.url, this.name});

  factory Brochure.fromJson(Map<String, dynamic> json) =>
      Brochure(url: json['url'], name: json['name']);

  Map<String, dynamic> toJson() => {'url': url, 'name': name};
}

class SizeRange {
  final double minSize;
  final double maxSize;

  SizeRange({required this.minSize, required this.maxSize});

  factory SizeRange.fromJson(Map<String, dynamic> json) => SizeRange(
    minSize: (json['minSize'] ?? 0).toDouble(),
    maxSize: (json['maxSize'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {'minSize': minSize, 'maxSize': maxSize};
}

class ScoreDetails {
  final double totalScore;
  final double? mediaScore;
  final double? planBonus;
  final double? basePerformance;
  final double? premiumBonus;
  final double? statusBonus;
  final double? launchBonus;
  final double? sizeBonus;
  final double? favoritesScore;
  final double? inquiriesScore;
  final double? viewsScore;
  final int? imagesCount;
  final int? videosCount;
  final int? documentsCount;
  final int? brochuresCount;

  ScoreDetails({
    required this.totalScore,
    this.mediaScore,
    this.planBonus,
    this.basePerformance,
    this.premiumBonus,
    this.statusBonus,
    this.launchBonus,
    this.sizeBonus,
    this.favoritesScore,
    this.inquiriesScore,
    this.viewsScore,
    this.imagesCount,
    this.videosCount,
    this.documentsCount,
    this.brochuresCount,
  });

  factory ScoreDetails.fromJson(Map<String, dynamic> json) => ScoreDetails(
    totalScore: (json['totalScore'] ?? 0).toDouble(),
    mediaScore: (json['mediaScore'] ?? 0).toDouble(),
    planBonus: (json['planBonus'] ?? 0).toDouble(),
    basePerformance: (json['basePerformance'] ?? 0).toDouble(),
    premiumBonus: (json['premiumBonus'] ?? 0).toDouble(),
    statusBonus: (json['statusBonus'] ?? 0).toDouble(),
    launchBonus: (json['launchBonus'] ?? 0).toDouble(),
    sizeBonus: (json['sizeBonus'] ?? 0).toDouble(),
    favoritesScore: (json['favoritesScore'] ?? 0).toDouble(),
    inquiriesScore: (json['inquiriesScore'] ?? 0).toDouble(),
    viewsScore: (json['viewsScore'] ?? 0).toDouble(),
    imagesCount: json['imagesCount'] ?? 0,
    videosCount: json['videosCount'] ?? 0,
    documentsCount: json['documentsCount'] ?? 0,
    brochuresCount: json['brochuresCount'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'totalScore': totalScore,
    'mediaScore': mediaScore,
    'planBonus': planBonus,
    'basePerformance': basePerformance,
    'premiumBonus': premiumBonus,
    'statusBonus': statusBonus,
    'launchBonus': launchBonus,
    'sizeBonus': sizeBonus,
    'favoritesScore': favoritesScore,
    'inquiriesScore': inquiriesScore,
    'viewsScore': viewsScore,
    'imagesCount': imagesCount,
    'videosCount': videosCount,
    'documentsCount': documentsCount,
    'brochuresCount': brochuresCount,
  };
}

/// ===============================
/// 🔹 VARIANTS / CONFIGURATIONS
/// ===============================

class ProjectVariant {
  String name;
  double builtUpArea;
  double carpetArea;
  double price;
  double? pricePerSqFt;
  int totalUnits;
  int availableUnits;
  List<String> specifications;
  List<String> images;
  List<String> videos;
  List<String> models;
  String? threeDModel;
  String? variantId;

  ProjectVariant({
    required this.name,
    required this.builtUpArea,
    required this.carpetArea,
    required this.price,
    this.pricePerSqFt,
    required this.totalUnits,
    required this.availableUnits,
    this.specifications = const [],
    this.images = const [],
    this.videos = const [],
    this.models = const [],
    this.threeDModel,
    this.variantId,
  });

  factory ProjectVariant.fromJson(Map<String, dynamic> json) {
    final media = json['variantMedia'] ?? {};
    return ProjectVariant(
      name: json['name'] ?? '',
      builtUpArea: (json['builtUpArea'] ?? 0).toDouble(),
      carpetArea: (json['carpetArea'] ?? 0).toDouble(),
      price: (json['price'] ?? 0).toDouble(),
      pricePerSqFt: json['pricePerSqFt']?.toDouble(),
      totalUnits: json['totalUnits'] ?? 0,
      availableUnits: json['availableUnits'] ?? 0,
      specifications: List<String>.from(json['specifications'] ?? []),
      images: List<String>.from(media['images'] ?? json['images'] ?? []),
      videos: List<String>.from(media['videos'] ?? json['videos'] ?? []),
      models: List<String>.from(media['models'] ?? []),
      threeDModel: json['threeDModel'],
      variantId: json['variantId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'builtUpArea': builtUpArea,
    'carpetArea': carpetArea,
    'price': price,
    'pricePerSqFt': pricePerSqFt,
    'totalUnits': totalUnits,
    'availableUnits': availableUnits,
    'specifications': specifications,
    'images': images,
    'videos': videos,
    'models': models,
    'threeDModel': threeDModel,
    'variantId': variantId,
  };
}

class ProjectConfiguration {
  int bhk;
  List<ProjectVariant> variants;

  ProjectConfiguration({required this.bhk, this.variants = const []});

  factory ProjectConfiguration.fromJson(Map<String, dynamic> json) =>
      ProjectConfiguration(
        bhk: json['bhk'] ?? 0,
        variants:
            (json['variants'] as List<dynamic>? ?? [])
                .map((v) => ProjectVariant.fromJson(v))
                .toList(),
      );

  Map<String, dynamic> toJson() => {
    'bhk': bhk,
    'variants': variants.map((v) => v.toJson()).toList(),
  };
}

/// ===============================
/// 🔹 MODEL FOR FETCHING PROJECT
/// ===============================

class ProjectItem {
  final String id;
  final String projectId;
  final String projectName;
  final String projectArea;
  final ProjectSize? projectSize;
  final SizeRange? sizeRange;
  final String? launchDate;
  final String? possessionDate;
  final List<ProjectConfiguration> configuration;
  final String reraId;
  final String propertyTypes;
  final ProjectContactInfo? projectContactInfo;
  final String status;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String? location;
  final List<NearbyLocation> nearbyLocations;
  final List<String> amenities;
  final List<String> projectHighlights;
  final MediaGallery? mediaGallery;
  final List<Brochure> brochures;
  final bool isVerified;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  // 🔸 Additional fields
  final String? createdBy;
  final String? updatedBy;
  final String? ownerName;
  final String? ownerEmail;
  final String? ownerPhone;
  final String? approvalStatus;
  final String? approvalComment;
  final String? approvedBy;
  final String? approvedAt;
  final String? verifiedBy;
  final String? verifiedAt;
  final String? assignedTo;
  final int? totalViews;
  final int? totalInquiries;
  final int? totalShares;
  final int? totalFavorites;
  final int? totalReports;
  final bool? isHiddenDueToReports;
  final String? lastReportedAt;
  final double? advancedScore;
  final ScoreDetails? scoreDetails;

  ProjectItem({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.projectArea,
    required this.projectSize,
    this.sizeRange,
    required this.launchDate,
    required this.possessionDate,
    required this.configuration,
    required this.reraId,
    required this.propertyTypes,
    required this.projectContactInfo,
    required this.status,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.location,
    required this.nearbyLocations,
    required this.amenities,
    required this.projectHighlights,
    required this.mediaGallery,
    required this.brochures,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
    this.updatedBy,
    this.ownerName,
    this.ownerEmail,
    this.ownerPhone,
    this.approvalStatus,
    this.approvalComment,
    this.approvedBy,
    this.approvedAt,
    this.verifiedBy,
    this.verifiedAt,
    this.assignedTo,
    this.totalViews,
    this.totalInquiries,
    this.totalShares,
    this.totalFavorites,
    this.totalReports,
    this.isHiddenDueToReports,
    this.lastReportedAt,
    this.advancedScore,
    this.scoreDetails,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) => ProjectItem(
    id: json['id'] ?? '',
    projectId: json['projectId'] ?? '',
    projectName: json['projectName'] ?? '',
    projectArea: json['projectArea']?.toString() ?? '',
    projectSize:
        json['projectSize'] != null
            ? ProjectSize.fromJson(json['projectSize'])
            : null,
    sizeRange:
        json['sizeRange'] != null
            ? SizeRange.fromJson(json['sizeRange'])
            : null,
    launchDate: json['launchDate'],
    possessionDate: json['possessionDate'],
    configuration:
        (json['configurations'] as List<dynamic>? ?? [])
            .map((v) => ProjectConfiguration.fromJson(v))
            .toList(),
    reraId: json['reraId'] ?? '',
    propertyTypes: json['propertyTypes'] ?? '',
    projectContactInfo:
        json['projectContactInfo'] != null
            ? ProjectContactInfo.fromJson(json['projectContactInfo'])
            : null,
    status: json['status'] ?? '',
    address: json['address'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    zipCode: json['zipCode']?.toString() ?? '',
    location: json['location'],
    nearbyLocations:
        (json['nearbyLocations'] as List? ?? [])
            .map((e) => NearbyLocation.fromJson(e))
            .toList(),
    amenities: List<String>.from(json['amenities'] ?? []),
    projectHighlights: List<String>.from(json['projectHighlights'] ?? []),
    mediaGallery:
        json['mediaGallery'] != null
            ? MediaGallery.fromJson(json['mediaGallery'])
            : null,
    brochures:
        (json['brochures'] as List<dynamic>? ?? [])
            .map((e) => Brochure.fromJson(e))
            .toList(),
    isVerified: json['isVerified'] ?? false,
    isActive: json['isActive'] ?? false,
    createdAt: json['createdAt'],
    updatedAt: json['updatedAt'],
    createdBy: json['created_by'],
    updatedBy: json['updated_by'],
    ownerName: json['ownerName'],
    ownerEmail: json['ownerEmail'],
    ownerPhone: json['ownerPhone'],
    approvalStatus: json['approval_status'],
    approvalComment: json['approval_comment'],
    approvedBy: json['approved_by'],
    approvedAt: json['approved_at'],
    verifiedBy: json['verifiedBy'],
    verifiedAt: json['verifiedAt'],
    assignedTo: json['assignedTo'],
    totalViews: json['totalViews'],
    totalInquiries: json['totalInquiries'],
    totalShares: json['totalShares'],
    totalFavorites: json['totalFavorites'],
    totalReports: json['totalReports'],
    isHiddenDueToReports: json['isHiddenDueToReports'],
    lastReportedAt: json['lastReportedAt'],
    advancedScore: (json['advancedScore'] ?? 0).toDouble(),
    scoreDetails:
        json['scoreDetails'] != null
            ? ScoreDetails.fromJson(json['scoreDetails'])
            : null,
  );

  /// ✅ Added complete toJson method
  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'projectName': projectName,
    'projectArea': projectArea,
    'projectSize': projectSize?.toJson(),
    'sizeRange': sizeRange?.toJson(),
    'launchDate': launchDate,
    'possessionDate': possessionDate,
    'configurations': configuration.map((v) => v.toJson()).toList(),
    'reraId': reraId,
    'propertyTypes': propertyTypes,
    'projectContactInfo': projectContactInfo?.toJson(),
    'status': status,
    'address': address,
    'city': city,
    'state': state,
    'zipCode': zipCode,
    'location': location,
    'nearbyLocations': nearbyLocations.map((e) => e.toJson()).toList(),
    'amenities': amenities,
    'projectHighlights': projectHighlights,
    'mediaGallery': mediaGallery?.toJson(),
    'brochures': brochures.map((e) => e.toJson()).toList(),
    'isVerified': isVerified,
    'isActive': isActive,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'ownerName': ownerName,
    'ownerEmail': ownerEmail,
    'ownerPhone': ownerPhone,
    'approval_status': approvalStatus,
    'approval_comment': approvalComment,
    'approved_by': approvedBy,
    'approved_at': approvedAt,
    'verifiedBy': verifiedBy,
    'verifiedAt': verifiedAt,
    'assignedTo': assignedTo,
    'totalViews': totalViews,
    'totalInquiries': totalInquiries,
    'totalShares': totalShares,
    'totalFavorites': totalFavorites,
    'totalReports': totalReports,
    'isHiddenDueToReports': isHiddenDueToReports,
    'lastReportedAt': lastReportedAt,
    'advancedScore': advancedScore,
    'scoreDetails': scoreDetails?.toJson(),
  };
}

extension ProjectItemPriceRange on ProjectItem {
  String getPriceRange() {
    final prices =
        configuration
            .expand((config) => config.variants)
            .map((variant) => variant.price)
            .where((p) => p > 0)
            .toList();

    if (prices.isEmpty) return "Price not available";

    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    return minPrice == maxPrice
        ? Formatter.formatPrice(minPrice)
        : "${Formatter.formatPrice(minPrice)} - ${Formatter.formatNumber(maxPrice)}";
  }
}

extension ProjectItemMapper on ProjectItem {
  AddProjectModel toAddProjectModel() {
    return AddProjectModel(
      id: id,
      projectName: projectName,
      projectArea: double.tryParse(projectArea) ?? 0.0,

      projectSize: projectSize ?? ProjectSize(totalBuildings: 0, totalUnits: 0),

      launchDate:
          launchDate != null
              ? DateTime.tryParse(launchDate!) ?? DateTime.now()
              : DateTime.now(),

      possessionDate:
          possessionDate != null
              ? DateTime.tryParse(possessionDate!) ?? DateTime.now()
              : DateTime.now(),

      configurations: configuration,

      reraId: reraId,
      propertyTypes: propertyTypes,
      status: status,

      address: address,
      city: city,
      state: state,
      zipCode: zipCode,
      location: location ?? "",

      nearbyLocations:
          nearbyLocations
              .map((e) => {"name": e.name, "distance": e.distance})
              .toList(),

      amenities: amenities,
      projectHighlights: projectHighlights,

      mediaGallery: mediaGallery,

      /// Extract only URLs from brochures list
      imageList: mediaGallery?.images ?? [],
      videoList: mediaGallery?.videos ?? [],
      documentList: mediaGallery?.documents ?? [],

      brochure: brochures.isNotEmpty ? brochures.first.url : null,
      pdfPath:
          (mediaGallery?.documents != null &&
                  mediaGallery!.documents.isNotEmpty)
              ? mediaGallery?.documents.first
              : null,

      projectContactInfo: projectContactInfo,
    );
  }
}

class NearbyLocation {
  final String name;
  final String distance;

  NearbyLocation({required this.name, required this.distance});

  factory NearbyLocation.fromJson(Map<String, dynamic> json) => NearbyLocation(
    name: json['name'] ?? '',
    distance: json['distance'] ?? '',
  );

  Map<String, dynamic> toJson() => {'name': name, 'distance': distance};
}

class MediaItem {
  final File? file;
  final String? url;
  final bool isExisting;

  MediaItem.file(this.file) : url = null, isExisting = false;

  MediaItem.url(this.url) : file = null, isExisting = true;

  String get path => file?.path ?? url ?? '';
  bool get isFile => file != null;
  bool get isUrl => url != null;
}
