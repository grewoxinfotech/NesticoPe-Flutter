import '../../../../modules/add_property/model/add_property_model.dart';

class VisitItem {
  final String id;
  final String? createdBy;
  final String? updatedBy;
  final String propertyId;
  final String buyerId;
  final String sellerId;
  final DateTime visitDate;
  final String timeSlot;
  final String status;
  final String? notes;
  final String? buyerFeedback;
  final String? sellerFeedback;
  final String? cancellationReason;
  final int rescheduleCount;
  final bool? buyerAttended;
  final bool? sellerAttended;
  final DateTime? followUpDate;
  final String? interestedLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final VisitProperty? property;

  VisitItem({
    required this.id,
    this.createdBy,
    this.updatedBy,
    required this.propertyId,
    required this.buyerId,
    required this.sellerId,
    required this.visitDate,
    required this.timeSlot,
    required this.status,
    this.notes,
    this.buyerFeedback,
    this.sellerFeedback,
    this.cancellationReason,
    required this.rescheduleCount,
    this.buyerAttended,
    this.sellerAttended,
    this.followUpDate,
    this.interestedLevel,
    required this.createdAt,
    required this.updatedAt,
    this.property,
  });

  factory VisitItem.fromJson(Map<String, dynamic> json) {
    return VisitItem(
      id: json['id'] ?? '',
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      propertyId: json['property_id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      visitDate: DateTime.parse(json['visitDate']),
      timeSlot: json['timeSlot'] ?? '',
      status: json['status'] ?? '',
      notes: json['notes'],
      buyerFeedback: json['buyerFeedback'],
      sellerFeedback: json['sellerFeedback'],
      cancellationReason: json['cancellationReason'],
      rescheduleCount: json['rescheduleCount'] ?? 0,
      buyerAttended: json['buyerAttended'],
      sellerAttended: json['sellerAttended'],
      followUpDate:
          json['followUpDate'] != null
              ? DateTime.parse(json['followUpDate'])
              : null,
      interestedLevel: json['interestedLevel'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      property:
          json['property'] != null
              ? VisitProperty.fromJson(json['property'])
              : null,
    );
  }
}

class VisitProperty {
  final String id;
  final String propertyType;
  final String listingType;
  final String location;
  final String city;
  final PropertyMedia? propertyMedia;

  VisitProperty({
    required this.id,
    required this.propertyType,
    required this.listingType,
    required this.location,
    required this.city,
    this.propertyMedia,
  });

  factory VisitProperty.fromJson(Map<String, dynamic> json) {
    return VisitProperty(
      id: json['id'] ?? '',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      propertyMedia:
          json['propertyMedia'] != null
              ? PropertyMedia.fromJson(json['propertyMedia'])
              : null,
    );
  }
}
