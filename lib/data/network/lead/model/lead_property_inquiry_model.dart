import 'dart:convert';

class PropertyInquirePanelModel {
  final bool? success;
  final String? message;
  final PropertyInquireData? data;

  PropertyInquirePanelModel({
    this.success,
    this.message,
    this.data,
  });

  factory PropertyInquirePanelModel.fromMap(Map<String, dynamic> map) {
    return PropertyInquirePanelModel(
      success: map['success'],
      message: map['message'],
      data: map['data'] != null
          ? PropertyInquireData.fromMap(map['data'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'success': success,
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory PropertyInquirePanelModel.fromJson(String source) =>
      PropertyInquirePanelModel.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class PropertyInquireData {
  final List<PropertyInquireItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  PropertyInquireData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory PropertyInquireData.fromMap(Map<String, dynamic> map) {
    return PropertyInquireData(
      items: map['items'] != null
          ? List<PropertyInquireItem>.from(
          map['items'].map((x) => PropertyInquireItem.fromMap(x)))
          : null,
      total: map['total'],
      currentPage: map['currentPage'],
      totalPages: map['totalPages'],
      hasMore: map['hasMore'],
      fetchedAll: map['fetchedAll'],
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

class PropertyInquireItem {
  final int? id;
  final String? propertyId;
  final String? userId;
  final String? name;
  final String? email;
  final String? phone;
  final String? inquiredAt;
  final String? status;
  final String? submittedAt;
  final bool? isConvertedToLead;
  final String? convertedToLeadAt;
  final PropertyInquireMeta? meta;
  final String? createdAt;
  final String? updatedAt;
  final String? entityType;
  final PropertyDetails? property;
  final PropertyUser? user;

  PropertyInquireItem({
    this.id,
    this.propertyId,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.inquiredAt,
    this.status,
    this.submittedAt,
    this.isConvertedToLead,
    this.convertedToLeadAt,
    this.meta,
    this.createdAt,
    this.updatedAt,
    this.entityType,
    this.property,
    this.user,
  });

  factory PropertyInquireItem.fromMap(Map<String, dynamic> map) {
    return PropertyInquireItem(
      id: map['id'],
      propertyId: map['propertyId'],
      userId: map['userId'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      inquiredAt: map['inquiredAt'],
      status: map['status'],
      submittedAt: map['submittedAt'],
      isConvertedToLead: map['isConvertedToLead'],
      convertedToLeadAt: map['convertedToLeadAt'],
      meta: map['meta'] != null ? PropertyInquireMeta.fromMap(map['meta']) : null,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      entityType: map['entityType'],
      property: map['property'] != null ? PropertyDetails.fromMap(map['property']) : null,
      user: map['user'] != null ? PropertyUser.fromMap(map['user']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyId': propertyId,
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'inquiredAt': inquiredAt,
      'status': status,
      'submittedAt': submittedAt,
      'isConvertedToLead': isConvertedToLead,
      'convertedToLeadAt': convertedToLeadAt,
      'meta': meta?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'entityType': entityType,
      'property': property?.toMap(),
      'user': user?.toMap(),
    };
  }
}

class PropertyInquireMeta {
  final int? negotiablePrice;
  final bool? isNegotiable;
  final String? timePeriod;
  final String? visitDate;
  final String? visitTime;

  PropertyInquireMeta({
    this.negotiablePrice,
    this.isNegotiable,
    this.timePeriod,
    this.visitDate,
    this.visitTime,
  });

  factory PropertyInquireMeta.fromMap(Map<String, dynamic> map) {
    final dynamic price = map['negotiablePrice'];
    return PropertyInquireMeta(
      negotiablePrice: price == null
          ? null
          : price is int
          ? price
          : int.tryParse(price.toString()),
      isNegotiable: map['isNegotiable'],
      timePeriod: map['timePeriod'],
      visitDate: map['visitDate'],
      visitTime: map['visitTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'negotiablePrice': negotiablePrice,
      'isNegotiable': isNegotiable,
      'timePeriod': timePeriod,
      'visitDate': visitDate,
      'visitTime': visitTime,
    };
  }
}

class PropertyDetails {
  final String? id;
  final String? propertyType;
  final String? listingType;
  final String? city;
  final num? price;
  final String? priceType;

  PropertyDetails({
    this.id,
    this.propertyType,
    this.listingType,
    this.city,
    this.price,
    this.priceType,
  });

  factory PropertyDetails.fromMap(Map<String, dynamic> map) {
    return PropertyDetails(
      id: map['id'],
      propertyType: map['propertyType'],
      listingType: map['listingType'],
      city: map['city'],
      price: map['price'],
      priceType: map['priceType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'propertyType': propertyType,
      'listingType': listingType,
      'city': city,
      'price': price,
      'priceType': priceType,
    };
  }
}

class PropertyUser {
  final String? id;
  final String? username;
  final String? email;
  final String? phone;
  final String? userType;

  PropertyUser({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.userType,
  });

  factory PropertyUser.fromMap(Map<String, dynamic> map) {
    return PropertyUser(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      phone: map['phone'],
      userType: map['userType'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'phone': phone,
      'userType': userType,
    };
  }
}
