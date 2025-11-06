// class ProjectVariant {
//   String name;
//   double builtUpArea;
//   double carpetArea;
//   double price;
//   double? pricePerSqFt;
//   int totalUnits;
//   int availableUnits;
//   List<String> specifications;
//
//   /// ✅ Added new optional fields
//   List<String>? images;
//   List<String>? videos;
//
//   ProjectVariant({
//     required this.name,
//     required this.builtUpArea,
//     required this.carpetArea,
//     required this.price,
//     this.pricePerSqFt,
//     required this.totalUnits,
//     required this.availableUnits,
//     List<String>? specifications,
//     this.images,
//     this.videos,
//   }) : specifications = specifications ?? [];
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
//     // ✅ Include image & video lists in toJson
//     'images': images,
//     'videos': videos,
//   };
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
//
//     // ✅ Safely parse image & video lists (nullable)
//     images: json['images'] != null ? List<String>.from(json['images']) : null,
//     videos: json['videos'] != null ? List<String>.from(json['videos']) : null,
//   );
// }
//
// class ProjectConfiguration {
//   int bhk;
//   List<ProjectVariant> variants;
//
//   ProjectConfiguration({required this.bhk, List<ProjectVariant>? variants})
//     : variants = variants ?? [];
//
//   Map<String, dynamic> toJson() => {
//     'bhk': bhk,
//     'variants': variants.map((v) => v.toJson()).toList(),
//   };
//
//   factory ProjectConfiguration.fromJson(Map<String, dynamic> json) =>
//       ProjectConfiguration(
//         bhk: json['bhk'] ?? 1,
//         variants:
//             (json['variants'] as List<dynamic>? ?? [])
//                 .map((v) => ProjectVariant.fromJson(v))
//                 .toList(),
//       );
// }
//
// class ProjectSize {
//   int totalBuildings;
//   int totalUnits;
//
//   ProjectSize({required this.totalBuildings, required this.totalUnits});
//
//   Map<String, dynamic> toJson() => {
//     'totalBuildings': totalBuildings,
//     'totalUnits': totalUnits,
//   };
//
//   factory ProjectSize.fromJson(Map<String, dynamic> json) => ProjectSize(
//     totalBuildings: json['totalBuildings'] ?? 0,
//     totalUnits: json['totalUnits'] ?? 0,
//   );
// }
//
// class ProjectContactInfo {
//   String? name;
//   String? phone;
//   String? email;
//
//   ProjectContactInfo({this.name, this.phone, this.email});
//
//   Map<String, dynamic> toJson() => {
//     'name': name,
//     'phone': phone,
//     'email': email,
//   };
//
//   factory ProjectContactInfo.fromJson(Map<String, dynamic> json) =>
//       ProjectContactInfo(
//         name: json['name'],
//         phone: json['phone'],
//         email: json['email'],
//       );
// }
//
// class AddProjectModel {
//   String? id;
//   MediaGallery mediaGallery;
//   String projectName;
//   double projectArea;
//   ProjectSize projectSize;
//   DateTime launchDate;
//   DateTime possessionDate;
//   List<ProjectConfiguration> configurations;
//   String reraId;
//   String? propertyTypes;
//   String status;
//   String address;
//   String city;
//   String state;
//   String zipCode;
//   String location;
//   List<Map<String, dynamic>> nearbyLocations;
//   List<String> amenities;
//   List<String> imageList;
//   List<String> videoList;
//   String? brochure;
//   String? pdfPath;
//   List<String> projectHighlights;
//   ProjectContactInfo? projectContactInfo;
//
//   AddProjectModel({
//     this.id,
//     required this.mediaGallery,
//     required this.projectName,
//     required this.projectArea,
//     required this.projectSize,
//     required this.launchDate,
//     required this.possessionDate,
//     required this.configurations,
//     required this.reraId,
//     this.propertyTypes,
//     this.status = 'upcoming',
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.location,
//     List<Map<String, dynamic>>? nearbyLocations,
//     List<String>? amenities,
//     this.brochure,
//     this.pdfPath,
//     List<String>? projectHighlights,
//     this.projectContactInfo,
//     List<String>? imageList,
//     List<String>? videoList,
//   }) : nearbyLocations = nearbyLocations ?? [],
//        amenities = amenities ?? [],
//        projectHighlights = projectHighlights ?? [],
//        imageList = imageList ?? [],
//        videoList = videoList ?? [];
//
//   Map<String, dynamic> toJson() => {
//     'projectName': projectName,
//     'projectArea': projectArea,
//     'projectSize': projectSize.toJson(), // ✅ fixed here
//     'launchDate': launchDate.toIso8601String(),
//     'possessionDate': possessionDate.toIso8601String(),
//     'reraId': reraId,
//     'propertyTypes': propertyTypes,
//     'status': status,
//     'address': address,
//     'city': city,
//     'state': state,
//     'zipCode': zipCode,
//     'location': location,
//     'pdfPath': pdfPath,
//     'nearbyLocations': nearbyLocations,
//     'configurations': configurations.map((c) => c.toJson()).toList(),
//     'amenities': amenities,
//     'imageList': imageList,
//     'videoList': videoList,
//     'brochure': brochure,
//     'projectHighlights': projectHighlights,
//     'projectContactInfo': projectContactInfo?.toJson(),
//   };
//
//   factory AddProjectModel.fromJson(Map<String, dynamic> json) =>
//       AddProjectModel(
//         id: json['id'] ?? '',
//         mediaGallery:
//             json['mediaGallery'] != null
//                 ? MediaGallery.fromJson(json['mediaGallery'])
//                 : MediaGallery(images: [], videos: []),
//         projectName: json['projectName'] ?? '',
//         projectArea:
//             json['projectArea'] is num
//                 ? (json['projectArea'] as num).toDouble()
//                 : double.tryParse(json['projectArea'].toString()) ?? 0.0,
//
//         projectSize:
//             json['projectSize'] != null
//                 ? ProjectSize.fromJson(json['projectSize'])
//                 : ProjectSize(totalBuildings: 0, totalUnits: 0),
//         launchDate:
//             json['launchDate'] != null
//                 ? DateTime.parse(json['launchDate'])
//                 : DateTime.now(),
//         possessionDate:
//             json['possessionDate'] != null
//                 ? DateTime.parse(json['possessionDate'])
//                 : DateTime.now(),
//         configurations:
//             (json['configurations'] as List<dynamic>? ?? [])
//                 .map((c) => ProjectConfiguration.fromJson(c))
//                 .toList(),
//         reraId: json['reraId'] ?? '',
//         propertyTypes: json['propertyTypes'],
//         status: json['status'] ?? 'upcoming',
//         address: json['address'] ?? '',
//         city: json['city'] ?? '',
//         state: json['state'] ?? '',
//         zipCode: json['zipCode'] ?? '',
//         location: json['location'] ?? '',
//         pdfPath: json['pdfPath'],
//         nearbyLocations: List<Map<String, dynamic>>.from(
//           json['nearbyLocations'] ?? [],
//         ),
//         amenities: List<String>.from(json['amenities'] ?? []),
//
//         brochure:
//             json['brochure'] is String
//                 ? json['brochure']
//                 : json['brochure']?['url'],
//         projectHighlights: List<String>.from(json['projectHighlights'] ?? []),
//         projectContactInfo:
//             json['projectContactInfo'] != null
//                 ? ProjectContactInfo.fromJson(json['projectContactInfo'])
//                 : null,
//       );
// }
//
// class MediaGallery {
//   final List<String>? images;
//   final List<String>? videos;
//   final List<String>? documents;
//
//   MediaGallery({this.images, this.videos, this.documents});
//
//   factory MediaGallery.fromJson(Map<String, dynamic> json) {
//     return MediaGallery(
//       images:
//           (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
//       videos:
//           (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),
//       documents:
//           (json['documents'] as List<dynamic>?)
//               ?.map((e) => e as String)
//               .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'images': images, 'videos': videos, 'documents': documents};
//   }
//
//   MediaGallery copyWith({List<String>? images, List<String>? videos}) {
//     return MediaGallery(
//       images: images ?? this.images,
//       videos: videos ?? this.videos,
//       documents: documents ?? this.documents,
//     );
//   }
// }
//
// class Brochure {
//   final String? url;
//   final String? name;
//
//   Brochure({this.url, this.name});
//
//   factory Brochure.fromJson(Map<String, dynamic> json) {
//     return Brochure(url: json['url'] as String?, name: json['name'] as String?);
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'url': url, 'name': name};
//   }
//
//   Brochure copyWith({String? url, String? name}) {
//     return Brochure(url: url ?? this.url, name: name ?? this.name);
//   }
// }

import 'dart:convert';

/// ===============================
/// 🔹 COMMON MODELS (Shared by both)
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
  });

  factory ProjectVariant.fromJson(Map<String, dynamic> json) => ProjectVariant(
    name: json['name'] ?? '',
    builtUpArea: (json['builtUpArea'] ?? 0).toDouble(),
    carpetArea: (json['carpetArea'] ?? 0).toDouble(),
    price: (json['price'] ?? 0).toDouble(),
    pricePerSqFt: json['pricePerSqFt']?.toDouble(),
    totalUnits: json['totalUnits'] ?? 0,
    availableUnits: json['availableUnits'] ?? 0,
    specifications: List<String>.from(json['specifications'] ?? []),
    images: List<String>.from(json['images'] ?? []),
    videos: List<String>.from(json['videos'] ?? []),
  );

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
/// 🔹 MODEL FOR ADDING PROJECT (used for API POST/PUT)
/// ===============================

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
    'brochure': brochure,
    'pdfPath': pdfPath,
    'projectContactInfo': projectContactInfo?.toJson(),
  };
}

/// ===============================
/// 🔹 MODEL FOR FETCHING PROJECT (used for GET/List/Detail)
/// ===============================

class ProjectItem {
  final String id;
  final String projectId;
  final String projectName;
  final String projectArea;
  final ProjectSize? projectSize;
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
  final List<String> nearbyLocations;
  final List<String> amenities;
  final List<String> projectHighlights;
  final MediaGallery? mediaGallery;
  final List<Brochure> brochures;
  final bool isVerified;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  ProjectItem({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.projectArea,
    required this.projectSize,
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
    zipCode: json['zipCode'] ?? '',
    location: json['location'],
    nearbyLocations: List<String>.from(json['nearbyLocations'] ?? []),
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
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'projectId': projectId,
    'projectName': projectName,
    'projectArea': projectArea,
    'projectSize': projectSize?.toJson(),
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
    'nearbyLocations': nearbyLocations,
    'amenities': amenities,
    'projectHighlights': projectHighlights,
    'mediaGallery': mediaGallery?.toJson(),
    'brochures': brochures.map((e) => e.toJson()).toList(),
    'isVerified': isVerified,
    'isActive': isActive,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}
