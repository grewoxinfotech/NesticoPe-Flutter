// import 'dart:convert';
//
// class BuilderProjectsResponse {
//   final bool success;
//   final String message;
//   final BuilderProjectsData? data;
//
//   BuilderProjectsResponse({
//     required this.success,
//     required this.message,
//     this.data,
//   });
//
//   factory BuilderProjectsResponse.fromMap(Map<String, dynamic> map) {
//     return BuilderProjectsResponse(
//       success: map['success'] ?? false,
//       message: map['message'] ?? '',
//       data: map['data'] != null
//           ? BuilderProjectsData.fromMap(map['data'])
//           : null,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toMap(),
//     };
//   }
//
//   factory BuilderProjectsResponse.fromJson(String source) =>
//       BuilderProjectsResponse.fromMap(json.decode(source));
//
//   String toJson() => json.encode(toMap());
// }
//
// class BuilderProjectsData {
//   final List<ProjectItem> items;
//   final int total;
//   final int currentPage;
//   final int totalPages;
//   final bool hasMore;
//   final bool fetchedAll;
//
//   BuilderProjectsData({
//     required this.items,
//     required this.total,
//     required this.currentPage,
//     required this.totalPages,
//     required this.hasMore,
//     required this.fetchedAll,
//   });
//
//   factory BuilderProjectsData.fromMap(Map<String, dynamic> map) {
//     return BuilderProjectsData(
//       items: (map['items'] as List<dynamic>?)
//           ?.map((e) => ProjectItem.fromMap(e))
//           .toList() ??
//           [],
//       total: map['total'] ?? 0,
//       currentPage: map['currentPage'] ?? 1,
//       totalPages: map['totalPages'] ?? 1,
//       hasMore: map['hasMore'] ?? false,
//       fetchedAll: map['fetchedAll'] ?? false,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'items': items.map((e) => e.toMap()).toList(),
//       'total': total,
//       'currentPage': currentPage,
//       'totalPages': totalPages,
//       'hasMore': hasMore,
//       'fetchedAll': fetchedAll,
//     };
//   }
// }
//
// class ProjectItem {
//   final List<Brochure> brochures;
//   final MediaGallery? mediaGallery;
//   final String id;
//   final String? createdBy;
//   final String? updatedBy;
//   final String projectId;
//   final String projectName;
//   final String projectArea;
//   final SizeRange? sizeRange;
//   final ProjectSize? projectSize;
//   final String? launchDate;
//   final String? possessionDate;
//   final List<Configuration> configuration;
//   final String reraId;
//   final String propertyTypes;
//   final ProjectContactInfo? projectContactInfos;
//   final String status;
//   final String address;
//   final String city;
//   final String state;
//   final String zipCode;
//   final String? location;
//   final List<String> nearbyLocations;
//   final List<String> amenities;
//   final String approvalStatus;
//   final String? approvalComment;
//   final bool isVerified;
//   final List<String> projectHighlights;
//   final int totalViews;
//   final int totalInquiries;
//   final int totalShares;
//   final int totalFavorites;
//   final bool isActive;
//   final String? createdAt;
//   final String? updatedAt;
//
//   ProjectItem({
//     required this.brochures,
//     required this.mediaGallery,
//     required this.id,
//     required this.createdBy,
//     required this.updatedBy,
//     required this.projectId,
//     required this.projectName,
//     required this.projectArea,
//     required this.sizeRange,
//     required this.projectSize,
//     required this.launchDate,
//     required this.possessionDate,
//     required this.configuration,
//     required this.reraId,
//     required this.propertyTypes,
//     required this.projectContactInfos,
//     required this.status,
//     required this.address,
//     required this.city,
//     required this.state,
//     required this.zipCode,
//     required this.location,
//     required this.nearbyLocations,
//     required this.amenities,
//     required this.approvalStatus,
//     required this.approvalComment,
//     required this.isVerified,
//     required this.projectHighlights,
//     required this.totalViews,
//     required this.totalInquiries,
//     required this.totalShares,
//     required this.totalFavorites,
//     required this.isActive,
//     required this.createdAt,
//     required this.updatedAt,
//   });
//
//   factory ProjectItem.fromMap(Map<String, dynamic> map) {
//     return ProjectItem(
//       brochures: (map['brochures'] as List<dynamic>?)
//           ?.map((e) => Brochure.fromMap(e))
//           .toList() ??
//           [],
//       mediaGallery: map['mediaGallery'] != null
//           ? MediaGallery.fromMap(map['mediaGallery'])
//           : null,
//       id: map['id'] ?? '',
//       createdBy: map['created_by'],
//       updatedBy: map['updated_by'],
//       projectId: map['projectId'] ?? '',
//       projectName: map['projectName'] ?? '',
//       projectArea: map['projectArea'] ?? '',
//       sizeRange: map['sizeRange'] != null
//           ? SizeRange.fromMap(map['sizeRange'])
//           : null,
//       projectSize: map['projectSize'] != null
//           ? ProjectSize.fromMap(map['projectSize'])
//           : null,
//       launchDate: map['launchDate'],
//       possessionDate: map['possessionDate'],
//       configuration: (map['configurations'] as List<dynamic>?)
//           ?.map((e) => Configuration.fromMap(e, map['mediaGallery']))
//           .toList() ??
//           [],
//       reraId: map['reraId'] ?? '',
//       propertyTypes: map['propertyTypes'] ?? '',
//       projectContactInfos: map['projectContactInfo'] != null
//           ? ProjectContactInfo.fromMap(map['projectContactInfo'])
//           : null,
//       status: map['status'] ?? '',
//       address: map['address'] ?? '',
//       city: map['city'] ?? '',
//       state: map['state'] ?? '',
//       zipCode: map['zipCode'] ?? '',
//       location: map['location'],
//       nearbyLocations:
//       List<String>.from(map['nearbyLocations'] ?? const []),
//       amenities: List<String>.from(map['amenities'] ?? const []),
//       approvalStatus: map['approval_status'] ?? '',
//       approvalComment: map['approval_comment'],
//       isVerified: map['isVerified'] ?? false,
//       projectHighlights:
//       List<String>.from(map['projectHighlights'] ?? const []),
//       totalViews: map['totalViews'] ?? 0,
//       totalInquiries: map['totalInquiries'] ?? 0,
//       totalShares: map['totalShares'] ?? 0,
//       totalFavorites: map['totalFavorites'] ?? 0,
//       isActive: map['isActive'] ?? false,
//       createdAt: map['createdAt'],
//       updatedAt: map['updatedAt'],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'brochures': brochures.map((e) => e.toMap()).toList(),
//       'mediaGallery': mediaGallery?.toMap(),
//       'id': id,
//       'created_by': createdBy,
//       'updated_by': updatedBy,
//       'projectId': projectId,
//       'projectName': projectName,
//       'projectArea': projectArea,
//       'sizeRange': sizeRange?.toMap(),
//       'projectSize': projectSize?.toMap(),
//       'launchDate': launchDate,
//       'possessionDate': possessionDate,
//       'configurations': configuration.map((e) => e.toMap()).toList(),
//       'reraId': reraId,
//       'propertyTypes': propertyTypes,
//       'projectContactInfo': projectContactInfos?.toMap(),
//       'status': status,
//       'address': address,
//       'city': city,
//       'state': state,
//       'zipCode': zipCode,
//       'location': location,
//       'nearbyLocations': nearbyLocations,
//       'amenities': amenities,
//       'approval_status': approvalStatus,
//       'approval_comment': approvalComment,
//       'isVerified': isVerified,
//       'projectHighlights': projectHighlights,
//       'totalViews': totalViews,
//       'totalInquiries': totalInquiries,
//       'totalShares': totalShares,
//       'totalFavorites': totalFavorites,
//       'isActive': isActive,
//       'createdAt': createdAt,
//       'updatedAt': updatedAt,
//     };
//   }
// }
//
// class Brochure {
//   final String url;
//   final String name;
//
//   Brochure({required this.url, required this.name});
//
//   factory Brochure.fromMap(Map<String, dynamic> map) {
//     return Brochure(
//       url: map['url'] ?? '',
//       name: map['name'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() => {'url': url, 'name': name};
// }
//
// class MediaGallery {
//   final List<String> images;
//   final List<String> videos;
//   final List<String> documents;
//
//   MediaGallery({
//     required this.images,
//     required this.videos,
//     required this.documents,
//   });
//
//   factory MediaGallery.fromMap(Map<String, dynamic> map) {
//     return MediaGallery(
//       images: List<String>.from(map['images'] ?? const []),
//       videos: List<String>.from(map['videos'] ?? const []),
//       documents: List<String>.from(map['documents'] ?? const []),
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'images': images,
//     'videos': videos,
//     'documents': documents,
//   };
// }
//
// class SizeRange {
//   final num minSize;
//   final num maxSize;
//
//   SizeRange({required this.minSize, required this.maxSize});
//
//   factory SizeRange.fromMap(Map<String, dynamic> map) {
//     return SizeRange(
//       minSize: map['minSize'] ?? 0,
//       maxSize: map['maxSize'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'minSize': minSize,
//     'maxSize': maxSize,
//   };
// }
//
// class ProjectSize {
//   final int totalUnits;
//   final int totalBuildings;
//
//   ProjectSize({
//     required this.totalUnits,
//     required this.totalBuildings,
//   });
//
//   factory ProjectSize.fromMap(Map<String, dynamic> map) {
//     return ProjectSize(
//       totalUnits: map['totalUnits'] ?? 0,
//       totalBuildings: map['totalBuildings'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'totalUnits': totalUnits,
//     'totalBuildings': totalBuildings,
//   };
// }
//
// class Configuration {
//   final int bhk;
//   final List<Variant> variants;
//
//   Configuration({
//     required this.bhk,
//     required this.variants,
//   });
//
//   factory Configuration.fromMap(
//       Map<String, dynamic> map, Map<String, dynamic>? mediaGallery) {
//     final images =
//     List<String>.from(mediaGallery?['images'] ?? const []);
//     final videos =
//     List<String>.from(mediaGallery?['videos'] ?? const []);
//
//     return Configuration(
//       bhk: map['bhk'] ?? 0,
//       variants: (map['variants'] as List<dynamic>?)
//           ?.map((e) => Variant.fromMap(e, images, videos))
//           .toList() ??
//           [],
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'bhk': bhk,
//       'variants': variants.map((e) => e.toMap()).toList(),
//     };
//   }
// }
//
// class Variant {
//   final String name;
//   final num price;
//   final String variantId;
//   final num carpetArea;
//   final num builtUpArea;
//   final num pricePerSqFt;
//   final int totalUnits;
//   final int availableUnits;
//   final List<String> specifications;
//   final List<String> images;
//   final List<String> videos;
//
//   Variant({
//     required this.name,
//     required this.price,
//     required this.variantId,
//     required this.carpetArea,
//     required this.builtUpArea,
//     required this.pricePerSqFt,
//     required this.totalUnits,
//     required this.availableUnits,
//     required this.specifications,
//     required this.images,
//     required this.videos,
//   });
//
//   factory Variant.fromMap(
//       Map<String, dynamic> map,
//       List<String>? images,
//       List<String>? videos,
//       ) {
//     return Variant(
//       name: map['name'] ?? '',
//       price: map['price'] ?? 0,
//       variantId: map['variantId'] ?? '',
//       carpetArea: map['carpetArea'] ?? 0,
//       builtUpArea: map['builtUpArea'] ?? 0,
//       pricePerSqFt: map['pricePerSqFt'] ?? 0,
//       totalUnits: map['totalUnits'] ?? 0,
//       availableUnits: map['availableUnits'] ?? 0,
//       specifications: List<String>.from(map['specifications'] ?? const []),
//       images: List<String>.from(map['images'] ?? images ?? const []),
//       videos: List<String>.from(map['videos'] ?? videos ?? const []),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'price': price,
//       'variantId': variantId,
//       'carpetArea': carpetArea,
//       'builtUpArea': builtUpArea,
//       'pricePerSqFt': pricePerSqFt,
//       'totalUnits': totalUnits,
//       'availableUnits': availableUnits,
//       'specifications': specifications,
//       'images': images,
//       'videos': videos,
//     };
//   }
// }
//
//
// class ProjectContactInfo {
//   final String name;
//   final String email;
//   final String phone;
//
//   ProjectContactInfo({
//     required this.name,
//     required this.email,
//     required this.phone,
//   });
//
//   factory ProjectContactInfo.fromMap(Map<String, dynamic> map) {
//     return ProjectContactInfo(
//       name: map['name'] ?? '',
//       email: map['email'] ?? '',
//       phone: map['phone'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() => {
//     'name': name,
//     'email': email,
//     'phone': phone,
//   };
// }
