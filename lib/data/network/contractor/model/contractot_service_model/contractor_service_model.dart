class ContractorServiceResponse {
  final bool success;
  final String message;
  final ContractorServiceData data;

  ContractorServiceResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ContractorServiceResponse.fromJson(Map<String, dynamic> json) {
    return ContractorServiceResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: ContractorServiceData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  Map<String, dynamic> toMap() => toJson();
}

class ContractorServiceData {
  List<ContractorServiceItem> items;
  final int total;
  final int currentPage;
  final int totalPages;
  final bool hasMore;
  final bool fetchedAll;

  ContractorServiceData({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
    required this.fetchedAll,
  });

  factory ContractorServiceData.fromJson(Map<String, dynamic> json) {
    return ContractorServiceData(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => ContractorServiceItem.fromJson(e))
              .toList() ??
          [],
      total: json['total'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 1,
      hasMore: json['hasMore'] ?? false,
      fetchedAll: json['fetchedAll'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}

class ContractorServiceItem {
  String? id;
  String? createdBy;
  String? updatedBy;
  String category;
  String contractorId;
  String serviceName;
  String description;
  int? totalReviews;
  String? averageRating;
  int? warningCount;
  bool isActive;
  bool? isBlocked;
  String? blockReason;
  String? blockedAt;
  ContractorMetaData meta;
  String createdAt;
  String updatedAt;

  ContractorServiceItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    required this.category,
    required this.contractorId,
    required this.serviceName,
    required this.description,
    this.totalReviews,
    this.averageRating,
    this.warningCount,
    required this.isActive,
    this.isBlocked,
    this.blockReason,
    this.blockedAt,
    required this.meta,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ContractorServiceItem.fromJson(Map<String, dynamic> json) {
    return ContractorServiceItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'] ?? '',
      category: json['category'] ?? '',
      contractorId: json['contractor_id'] ?? '',
      serviceName: json['serviceName'] ?? '',
      description: json['description'] ?? '',
      totalReviews: json['totalReviews'] ?? 0,
      averageRating: json['averageRating']?.toString() ?? '0.0',
      warningCount: json['warningCount'] ?? 0,
      isActive: json['isActive'] ?? false,
      isBlocked: json['isBlocked'] ?? false,
      blockReason: json['blockReason'],
      blockedAt: json['blockedAt'],
      meta: ContractorMetaData.fromJson(json['meta'] ?? {}),
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'category': category,
      'contractor_id': contractorId,
      'serviceName': serviceName,
      'description': description,
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'warningCount': warningCount,
      'isActive': isActive,
      'isBlocked': isBlocked,
      'blockReason': blockReason,
      'blockedAt': blockedAt,
      'meta': meta.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Map<String, dynamic> toMap() => toJson();
}

class ContractorMetaData {

   String priceModel;
   int minPriceRange;
   int maxPriceRange;
   String workAvailability;
   bool provideMaterials;
   String brandsUsed;
   bool equipmentProvided;
   bool insuranceAvailable;
   List<String> acceptedPaymentModes;
   int advanceRequiredPercentage;
   String billingType;

   ContractorMetaData({

    required this.priceModel,
    required this.minPriceRange,
    required this.maxPriceRange,
    required this.workAvailability,
    required this.provideMaterials,
    required this.brandsUsed,
    required this.equipmentProvided,
    required this.insuranceAvailable,
    required this.acceptedPaymentModes,
    required this.advanceRequiredPercentage,
    required this.billingType,
  });

  factory ContractorMetaData.fromJson(Map<String, dynamic> json) {
    return ContractorMetaData(

      priceModel: json['priceModel'] ?? '',
      minPriceRange: json['minPrice'] ?? 0,
      maxPriceRange: json['maxPrice'] ?? 0,
      workAvailability: json['workAvailability'] ?? '',
      provideMaterials: json['provideMaterials'] ?? false,
      brandsUsed: json['brandsUsed'] ?? '',
      equipmentProvided: json['equipmentProvided'] ?? false,
      insuranceAvailable: json['insuranceAvailable'] ?? false,
      acceptedPaymentModes: List<String>.from(
        json['acceptedPaymentModes'] ?? [],
      ),
      advanceRequiredPercentage: json['advanceRequiredPercentage'] ?? 0,
      billingType: json['billingType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {

      'priceModel': priceModel,
      'minPrice': minPriceRange,
      'maxPrice': maxPriceRange,
      'workAvailability': workAvailability,
      'provideMaterials': provideMaterials,
      'brandsUsed': brandsUsed,
      'equipmentProvided': equipmentProvided,
      'insuranceAvailable': insuranceAvailable,
      'acceptedPaymentModes': acceptedPaymentModes,
      'advanceRequiredPercentage': advanceRequiredPercentage,
      'billingType': billingType,
    };
  }

  String get priceRange {
    if (minPriceRange == 0 && maxPriceRange == 0) {
      return 'No Price Range';
    } else if (minPriceRange == 0) {
      return 'Upto ₹$maxPriceRange';
    } else if (maxPriceRange == 0) {
      return 'From ₹$minPriceRange';
    } else {
      return '₹$minPriceRange - ₹$maxPriceRange';
    }
  }

  Map<String, dynamic> toMap() => toJson();
}
