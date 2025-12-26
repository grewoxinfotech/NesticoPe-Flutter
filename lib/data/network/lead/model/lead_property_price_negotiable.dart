import 'dart:convert';

class LeadPriceNegotiable {
  final bool? success;
  final String? message;
  final NegotiableData? data;

  LeadPriceNegotiable({
    this.success,
    this.message,
    this.data,
  });

  factory LeadPriceNegotiable.fromMap(Map<String, dynamic> map) {
    return LeadPriceNegotiable(
      success: map['success'] as bool?,
      message: map['message'] as String?,
      data: map['data'] != null ? NegotiableData.fromMap(map['data']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory LeadPriceNegotiable.fromJson(String source) =>
      LeadPriceNegotiable.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class NegotiableData {
  final List<NegotiableItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  NegotiableData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory NegotiableData.fromMap(Map<String, dynamic> map) {
    return NegotiableData(
      items: map['items'] != null
          ? List<NegotiableItem>.from(
          map['items'].map((x) => NegotiableItem.fromMap(x)))
          : [],
      total: map['total'] as int?,
      currentPage: map['currentPage'] as int?,
      totalPages: map['totalPages'] as int?,
      hasMore: map['hasMore'] as bool?,
      fetchedAll: map['fetchedAll'] as bool?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'items': items?.map((x) => x.toMap()).toList(),
      'total': total,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'hasMore': hasMore,
      'fetchedAll': fetchedAll,
    };
  }
}

class NegotiableItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? propertyId;
  final String? buyerId;
  final String? sellerId;
  final String? negotiablePrice;
  final String? previousNegotiablePrice;
  final String? newStatus;
  final String? oldStatus;
  final String? rejectionReason;
  final String? createdAt;
  final String? updatedAt;

  NegotiableItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.propertyId,
    this.buyerId,
    this.sellerId,
    this.negotiablePrice,
    this.previousNegotiablePrice,
    this.newStatus,
    this.oldStatus,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  factory NegotiableItem.fromMap(Map<String, dynamic> map) {
    return NegotiableItem(
      id: map['id'],
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      propertyId: map['propertyId'],
      buyerId: map['buyerId'],
      sellerId: map['sellerId'],
      negotiablePrice: map['negotiablePrice'],
      previousNegotiablePrice: map['previousNegotiablePrice'],
      newStatus: map['newStatus'],
      oldStatus: map['oldStatus'],
      rejectionReason: map['rejectionReason'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'propertyId': propertyId,
      'buyerId': buyerId,
      'sellerId': sellerId,
      'negotiablePrice': negotiablePrice,
      'previousNegotiablePrice': previousNegotiablePrice,
      'newStatus': newStatus,
      'oldStatus': oldStatus,
      'rejectionReason': rejectionReason,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
