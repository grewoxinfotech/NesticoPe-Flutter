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

  Map<String, dynamic> toJson() => {
    'name': name,
    'builtUpArea': builtUpArea,
    'carpetArea': carpetArea,
    'price': price,
    'pricePerSqFt': pricePerSqFt,
    'totalUnits': totalUnits,
    'availableUnits': availableUnits,
    'specifications': specifications,
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
  );
}

class ProjectConfiguration {
  int bhk;
  List<ProjectVariant> variants;

  ProjectConfiguration({
    required this.bhk,
    List<ProjectVariant>? variants,
  }) : variants = variants ?? [];

  Map<String, dynamic> toJson() => {
    'bhk': bhk,
    'variants': variants.map((v) => v.toJson()).toList(),
  };

  factory ProjectConfiguration.fromJson(Map<String, dynamic> json) =>
      ProjectConfiguration(
        bhk: json['bhk'] ?? 1,
        variants: (json['variants'] as List<dynamic>? ?? [])
            .map((v) => ProjectVariant.fromJson(v))
            .toList(),
      );
}

class ProjectSize {
  int totalBuildings;
  int totalUnits;

  ProjectSize({
    required this.totalBuildings,
    required this.totalUnits,
  });
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
  })  : nearbyLocations = nearbyLocations ?? [],
        amenities = amenities ?? [],
        projectHighlights = projectHighlights ?? [],
        imageList = imageList ?? [],
        videoList = videoList ?? [];

  Map<String, dynamic> toJson() => {
    'projectName': projectName,
    'projectArea': projectArea,
    'totalBuildings': projectSize.totalBuildings,
    'totalUnits': projectSize.totalUnits,
    'launchDate': launchDate.toIso8601String(),
    'possessionDate': possessionDate.toIso8601String(),
    'reraId': reraId,
    'propertyTypes': propertyTypes,
    'status': status,
    'address': address,
    'city': city,
    'pdfPath':pdfPath,
    'state': state,
    'zipCode': zipCode,
    'location': location,
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
    projectName: json['projectName'] ?? '',
    projectArea: (json['projectArea'] ?? 0).toDouble(),
    projectSize: ProjectSize(
      totalBuildings: json['totalBuildings'] ?? 1,
      totalUnits: json['totalUnits'] ?? 1,
    ),
    launchDate: json['launchDate'] != null
        ? DateTime.parse(json['launchDate'])
        : DateTime.now(),
    possessionDate: json['possessionDate'] != null
        ? DateTime.parse(json['possessionDate'])
        : DateTime.now(),
    configurations: (json['configurations'] as List<dynamic>? ?? [])
        .map((c) => ProjectConfiguration.fromJson(c))
        .toList(),
    reraId: json['reraId'] ?? '',
    propertyTypes: json['propertyTypes'],
    status: json['status'] ?? 'upcoming',
    address: json['address'] ?? '',
    city: json['city'] ?? '',
    pdfPath: json['pdfPath']??'',
    state: json['state'] ?? '',
    zipCode: json['zipCode'] ?? '',
    location: json['location'] ?? '',
    nearbyLocations:
    List<Map<String, dynamic>>.from(json['nearbyLocations'] ?? []),
    amenities: List<String>.from(json['amenities'] ?? []),
    imageList: List<String>.from(json['imageList'] ?? []),
    videoList: List<String>.from(json['videoList'] ?? []),
    brochure: json['brochure'],
    projectHighlights:
    List<String>.from(json['projectHighlights'] ?? []),
    projectContactInfo: json['projectContactInfo'] != null
        ? ProjectContactInfo.fromJson(json['projectContactInfo'])
        : null,
  );


}