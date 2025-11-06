
class ProjectVariant {
  String name;
  double builtUpArea;
  double carpetArea;
  double price;
  double? pricePerSqFt;
  int totalUnits;
  int availableUnits;
  List<String> specifications;

  /// ✅ Added new optional fields
  List<String>? images;
  List<String>? videos;

  ProjectVariant({
    required this.name,
    required this.builtUpArea,
    required this.carpetArea,
    required this.price,
    this.pricePerSqFt,
    required this.totalUnits,
    required this.availableUnits,
    List<String>? specifications,
    this.images,
    this.videos,
  }) : specifications = specifications ?? [];

  Map<String, dynamic> toJson() => {
    'name': name,
    'builtUpArea': builtUpArea,
    'carpetArea': carpetArea,
    'price': price,
    'pricePerSqFt': pricePerSqFt,
    'totalUnits': totalUnits,
    'availableUnits': availableUnits,
    'specifications': specifications,
    // ✅ Include image & video lists in toJson
    'images': images,
    'videos': videos,
  };

  factory ProjectVariant.fromJson(Map<String, dynamic> json) => ProjectVariant(
    name: json['name'] ?? '',
    builtUpArea: (json['builtUpArea'] ?? 0).toDouble(),
    carpetArea: (json['carpetArea'] ?? 0).toDouble(),
    price: (json['price'] ?? 0).toDouble(),
    pricePerSqFt: json['pricePerSqFt']?.toDouble(),
    totalUnits: json['totalUnits'] ?? 0,
    availableUnits: json['availableUnits'] ?? 0,
    specifications: List<String>.from(json['specifications'] ?? []),

    // ✅ Safely parse image & video lists (nullable)
    images: json['images'] != null
        ? List<String>.from(json['images'])
        : null,
    videos: json['videos'] != null
        ? List<String>.from(json['videos'])
        : null,
  );
}

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
//   ProjectVariant({
//     required this.name,
//     required this.builtUpArea,
//     required this.carpetArea,
//     required this.price,
//     this.pricePerSqFt,
//     required this.totalUnits,
//     required this.availableUnits,
//     List<String>? specifications,
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
//   );
// }

class ProjectConfiguration {
  int bhk;
  List<ProjectVariant> variants;

  ProjectConfiguration({required this.bhk, List<ProjectVariant>? variants})
    : variants = variants ?? [];

  Map<String, dynamic> toJson() => {
    'bhk': bhk,
    'variants': variants.map((v) => v.toJson()).toList(),
  };

  factory ProjectConfiguration.fromJson(Map<String, dynamic> json) =>
      ProjectConfiguration(
        bhk: json['bhk'] ?? 1,
        variants:
            (json['variants'] as List<dynamic>? ?? [])
                .map((v) => ProjectVariant.fromJson(v))
                .toList(),
      );
}

class ProjectSize {
  int totalBuildings;
  int totalUnits;

  ProjectSize({required this.totalBuildings, required this.totalUnits});

  Map<String, dynamic> toJson() => {
    'totalBuildings': totalBuildings,
    'totalUnits': totalUnits,
  };

  factory ProjectSize.fromJson(Map<String, dynamic> json) => ProjectSize(
    totalBuildings: json['totalBuildings'] ?? 0,
    totalUnits: json['totalUnits'] ?? 0,
  );
}

class ProjectContactInfo {
  String? name;
  String? phone;
  String? email;

  ProjectContactInfo({this.name, this.phone, this.email});

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
  };

  factory ProjectContactInfo.fromJson(Map<String, dynamic> json) =>
      ProjectContactInfo(
        name: json['name'],
        phone: json['phone'],
        email: json['email'],
      );
}

class ProjectModel {
  String? id;
  MediaGallery mediaGallery;
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
  List<String> imageList;
  List<String> videoList;
  String? brochure;
  String? pdfPath;
  List<String> projectHighlights;
  ProjectContactInfo? projectContactInfo;

  ProjectModel({
    this.id,
    required this.mediaGallery,
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
    List<Map<String, dynamic>>? nearbyLocations,
    List<String>? amenities,
    this.brochure,
    this.pdfPath,
    List<String>? projectHighlights,
    this.projectContactInfo,
    List<String>? imageList,
    List<String>? videoList,

  }) : nearbyLocations = nearbyLocations ?? [],
       amenities = amenities ?? [],
       projectHighlights = projectHighlights ?? [],
       imageList = imageList ?? [],
       videoList = videoList ?? [];

  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'projectArea': projectArea,
    'projectSize': projectSize.toJson(), // ✅ fixed here
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
    'pdfPath': pdfPath,
    'nearbyLocations': nearbyLocations,
    'configurations': configurations.map((c) => c.toJson()).toList(),
    'amenities': amenities,
    'imageList': imageList,
    'videoList': videoList,
    'brochure': brochure,
    'projectHighlights': projectHighlights,
    'projectContactInfo': projectContactInfo?.toJson(),
  };

  factory ProjectModel.fromJson(Map<String, dynamic> json) => ProjectModel(
    id: json['id'] ?? '',
    mediaGallery:
        json['mediaGallery'] != null
            ? MediaGallery.fromJson(json['mediaGallery'])
            : MediaGallery(images: [], videos: []),
    projectName: json['projectName'] ?? '',
    projectArea:
        json['projectArea'] is num
            ? (json['projectArea'] as num).toDouble()
            : double.tryParse(json['projectArea'].toString()) ?? 0.0,

    projectSize:
        json['projectSize'] != null
            ? ProjectSize.fromJson(json['projectSize'])
            : ProjectSize(totalBuildings: 0, totalUnits: 0),
    launchDate:
        json['launchDate'] != null
            ? DateTime.parse(json['launchDate'])
            : DateTime.now(),
    possessionDate:
        json['possessionDate'] != null
            ? DateTime.parse(json['possessionDate'])
            : DateTime.now(),
    configurations:
        (json['configurations'] as List<dynamic>? ?? [])
            .map((c) => ProjectConfiguration.fromJson(c))
            .toList(),
    reraId: json['reraId'] ?? '',
    propertyTypes: json['propertyTypes'],
    status: json['status'] ?? 'upcoming',
    address: json['address'] ?? '',
    city: json['city'] ?? '',
    state: json['state'] ?? '',
    zipCode: json['zipCode'] ?? '',
    location: json['location'] ?? '',
    pdfPath: json['pdfPath'],
    nearbyLocations: List<Map<String, dynamic>>.from(
      json['nearbyLocations'] ?? [],
    ),
    amenities: List<String>.from(json['amenities'] ?? []),

    brochure:
        json['brochure'] is String
            ? json['brochure']
            : json['brochure']?['url'],
    projectHighlights: List<String>.from(json['projectHighlights'] ?? []),
    projectContactInfo:
        json['projectContactInfo'] != null
            ? ProjectContactInfo.fromJson(json['projectContactInfo'])
            : null,
  );
}

class MediaGallery {
  final List<String>? images;
  final List<String>? videos;
  final List<String>? documents;


  MediaGallery({this.images, this.videos,this.documents});

  factory MediaGallery.fromJson(Map<String, dynamic> json) {
    return MediaGallery(
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      videos:
          (json['videos'] as List<dynamic>?)?.map((e) => e as String).toList(),      documents:
          (json['documents'] as List<dynamic>?)?.map((e) => e as String).toList(),

    );
  }

  Map<String, dynamic> toJson() {
    return {'images': images, 'videos': videos,'documents':documents};
  }

  MediaGallery copyWith({List<String>? images, List<String>? videos}) {
    return MediaGallery(
      images: images ?? this.images,
      videos: videos ?? this.videos,
      documents: documents?? this.documents
    );
  }
}

class Brochure {
  final String? url;
  final String? name;

  Brochure({this.url, this.name});

  factory Brochure.fromJson(Map<String, dynamic> json) {
    return Brochure(url: json['url'] as String?, name: json['name'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'name': name};
  }

  Brochure copyWith({String? url, String? name}) {
    return Brochure(url: url ?? this.url, name: name ?? this.name);
  }
}
