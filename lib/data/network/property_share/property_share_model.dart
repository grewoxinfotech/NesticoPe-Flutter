import '../interest_form/interest_form_model.dart';

class PropertyShareModel {
  final String? id;
  final String? updatedBy;
  final int? clicks;
  final int? leads;
  final String? status;
  final String? propertyId;
  final String? resellerId;
  final String? platform;
  final String? shareType;
  final String? interestFormId;
  final String? shareUrl;
  final String? createdBy;
  final String? updatedAt;
  final String? createdAt;

  PropertyShareModel({
    this.id,
    this.updatedBy,
    this.clicks,
    this.leads,
    this.status,
    this.propertyId,
    this.resellerId,
    this.platform,
    this.shareType,
    this.interestFormId,
    this.shareUrl,
    this.createdBy,
    this.updatedAt,
    this.createdAt,
  });

  factory PropertyShareModel.fromJson(Map<String, dynamic> json) {
    return PropertyShareModel(
      id: json['id'] ?? '',
      updatedBy: json['updated_by'],
      clicks: json['clicks'] ?? 0,
      leads: json['leads'] ?? 0,
      status: json['status'] ?? '',
      propertyId: json['propertyId'] ?? '',
      resellerId: json['resellerId'] ?? '',
      platform: json['platform'] ?? '',
      shareType: json['shareType'] ?? '',
      interestFormId: json['interestFormId'] ?? '',
      shareUrl: json['shareUrl'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null && id!.isNotEmpty) 'id': id,
      if (propertyId != null && propertyId!.isNotEmpty)
        'propertyId': propertyId,
      if (resellerId != null && resellerId!.isNotEmpty)
        'resellerId': resellerId,
      if (platform != null && platform!.isNotEmpty) 'platform': platform,
      if (shareType != null && shareType!.isNotEmpty) 'shareType': shareType,
      if (interestFormId != null && interestFormId!.isNotEmpty)
        'interestFormId': interestFormId,
      if (status != null && status!.isNotEmpty) 'status': status,
      if (clicks != null) 'clicks': clicks,
      if (leads != null) 'leads': leads,
      if (shareUrl != null && shareUrl!.isNotEmpty) 'shareUrl': shareUrl,
      if (createdBy != null && createdBy!.isNotEmpty) 'created_by': createdBy,
      if (updatedBy != null && updatedBy!.isNotEmpty) 'updated_by': updatedBy,
      if (createdAt != null && createdAt!.isNotEmpty) 'createdAt': createdAt,
      if (updatedAt != null && updatedAt!.isNotEmpty) 'updatedAt': updatedAt,
    };
  }
}

class MultiShareData {
  final String id;
  final String slug;
  final String url;
  final List<String> propertyIds;
  final List<MultiShareItem> items;

  MultiShareData({
    required this.id,
    required this.slug,
    required this.url,
    required this.propertyIds,
    required this.items,
  });

  factory MultiShareData.fromJson(Map<String, dynamic> json) {
    final rawPropertyIds = json['propertyIds'];

    return MultiShareData(
      id: json['id']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
      url: json['url']?.toString() ?? '',

      propertyIds:
          rawPropertyIds is List
              ? rawPropertyIds.map((e) => e.toString()).toList()
              : rawPropertyIds is String && rawPropertyIds.isNotEmpty
              ? [rawPropertyIds]
              : [],

      items:
          json['items'] is List
              ? (json['items'] as List)
                  .map((e) => MultiShareItem.fromJson(e))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'url': url,
      'propertyIds': propertyIds,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class MultiShareItem {
  final String id;
  final String propertyType;
  final String listingType;
  final String city;
  final String? state;
  final String image;
  final num price;
  final bool pricePerMonth;
  final String link;

  MultiShareItem({
    required this.id,
    required this.propertyType,
    required this.listingType,
    required this.city,
    this.state,
    required this.image,
    required this.price,
    required this.pricePerMonth,
    required this.link,
  });

  factory MultiShareItem.fromJson(Map<String, dynamic> json) {
    return MultiShareItem(
      id: json['id'] ?? '',
      propertyType: json['propertyType'] ?? '',
      listingType: json['listingType'] ?? '',
      city: json['city'] ?? '',
      state: json['state'],
      image: json['image'] ?? '',
      price: json['price'] ?? 0,
      pricePerMonth: json['pricePerMonth'] ?? false,
      link: json['link'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyType': propertyType,
      'listingType': listingType,
      'city': city,
      'state': state,
      'image': image,
      'price': price,
      'pricePerMonth': pricePerMonth,
      'link': link,
    };
  }
}

class CreateMultiShareRequest {
  final String resellerId;
  final List<String> propertyIds;
  final List<CustomFormField> formFields;

  CreateMultiShareRequest({
    required this.resellerId,
    required this.propertyIds,
    required this.formFields,
  });

  factory CreateMultiShareRequest.fromJson(Map<String, dynamic> json) {
    return CreateMultiShareRequest(
      resellerId: json['resellerId'] ?? '',
      propertyIds: List<String>.from(json['propertyIds'] ?? []),
      formFields:
          (json['formFields'] as List<dynamic>?)
              ?.map((e) => CustomFormField.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resellerId': resellerId,
      'propertyIds': propertyIds,
      'formFields': formFields.map((e) => e.toJson()).toList(),
    };
  }
}

// class FormFieldItem {
//   final String id;
//   final String name;
//   final String label;
//   final String type;
//   final bool required;
//   final int order;
//   final String placeholder;
//
//   FormFieldItem({
//     required this.id,
//     required this.name,
//     required this.label,
//     required this.type,
//     required this.required,
//     required this.order,
//     required this.placeholder,
//   });
//
//   factory FormFieldItem.fromJson(Map<String, dynamic> json) {
//     return FormFieldItem(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       label: json['label'] ?? '',
//       type: json['type'] ?? '',
//       required: json['required'] ?? false,
//       order: json['order'] ?? 0,
//       placeholder: json['placeholder'] ?? '',
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'label': label,
//       'type': type,
//       'required': required,
//       'order': order,
//       'placeholder': placeholder,
//     };
//   }
// }
