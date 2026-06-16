
import 'dart:convert';

class LeadVisitData {
  final bool? success;
  final String? message;
  final LeadVisitResponseData? data;

  LeadVisitData({
    this.success,
    this.message,
    this.data,
  });

  factory LeadVisitData.fromMap(Map<String, dynamic> map) {
    return LeadVisitData(
      success: map['success'],
      message: map['message'],
      data: map['data'] != null
          ? LeadVisitResponseData.fromMap(map['data'])
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

  factory LeadVisitData.fromJson(String source) =>
      LeadVisitData.fromMap(json.decode(source));

  String toJson() => json.encode(toMap());
}

class LeadVisitResponseData {
  final List<LeadVisitItem>? items;
  final int? total;
  final int? currentPage;
  final int? totalPages;
  final bool? hasMore;
  final bool? fetchedAll;

  LeadVisitResponseData({
    this.items,
    this.total,
    this.currentPage,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory LeadVisitResponseData.fromMap(Map<String, dynamic> map) {
    return LeadVisitResponseData(
      items: map['items'] != null
          ? List<LeadVisitItem>.from(
          map['items'].map((x) => LeadVisitItem.fromMap(x)))
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

class LeadVisitItem {
  final String? id;
  final String? createdBy;
  final String? updatedBy;
  final String? propertyId;
  final String? buyerId;
  final String? sellerId;
  final String? visitDate;
  final String? timeSlot;
  final String? status;
  final String? notes;
  final String? buyerFeedback;
  final String? sellerFeedback;
  final String? cancellationReason;
  final int? rescheduleCount;
  final bool? buyerAttended;
  final bool? sellerAttended;
  final String? followUpDate;
  final String? interestedLevel;
  final String? createdAt;
  final String? updatedAt;
  final String? entity;
final BuilderProject? builderProject;
final dynamic property;
final dynamic user;

  LeadVisitItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.propertyId,
    this.buyerId,
    this.sellerId,
    this.visitDate,
    this.timeSlot,
    this.status,
  
  // ...
  this.entity,
  this.builderProject,
  this.property,
  this.user,

    this.notes,
    this.buyerFeedback,
    this.sellerFeedback,
    this.cancellationReason,
    this.rescheduleCount,
    this.buyerAttended,
    this.sellerAttended,
    this.followUpDate,
    this.interestedLevel,
    this.createdAt,
    this.updatedAt,
  });

  factory LeadVisitItem.fromMap(Map<String, dynamic> map) {
    return LeadVisitItem(
      id: map['id'],
      createdBy: map['created_by'],
      updatedBy: map['updated_by'],
      propertyId: map['property_id'],
      buyerId: map['buyer_id'],
      sellerId: map['seller_id'],
      visitDate: map['visitDate'],
      timeSlot: map['timeSlot'],
      status: map['status'],
      notes: map['notes'],
      buyerFeedback: map['buyerFeedback'],
      sellerFeedback: map['sellerFeedback'],
      cancellationReason: map['cancellationReason'],
      rescheduleCount: map['rescheduleCount'],
      buyerAttended: map['buyerAttended'],
      sellerAttended: map['sellerAttended'],
      followUpDate: map['followUpDate'],
        entity: map['entity'],
    property: map['property'],
    user: map['user'],
    builderProject: map['builderProject'] != null
        ? BuilderProject.fromMap(map['builderProject'])
        : null,
      interestedLevel: map['interestedLevel'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'property_id': propertyId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'visitDate': visitDate,
      'timeSlot': timeSlot,
      'entity': entity,
'property': property,
'user': user,
'builderProject': builderProject?.toMap(),
      'status': status,
      'notes': notes,
      'buyerFeedback': buyerFeedback,
      'sellerFeedback': sellerFeedback,
      'cancellationReason': cancellationReason,
      'rescheduleCount': rescheduleCount,
      'buyerAttended': buyerAttended,
      'sellerAttended': sellerAttended,
      'followUpDate': followUpDate,
      'interestedLevel': interestedLevel,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}



class BuilderProject {
  final String? id;
  final String? projectName;
  final String? propertyTypes;
  final String? location;
  final String? city;

  BuilderProject({
    this.id,
    this.projectName,
    this.propertyTypes,
    this.location,
    this.city,
  });

  factory BuilderProject.fromMap(Map<String, dynamic> map) {
    return BuilderProject(
      id: map['id'],
      projectName: map['projectName'],
      propertyTypes: map['propertyTypes'],
      location: map['location'],
      city: map['city'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'projectName': projectName,
      'propertyTypes': propertyTypes,
      'location': location,
      'city': city,
    };
  }
}