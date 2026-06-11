import 'package:intl/intl.dart';

class BannerItem {
  final String id;
  final String createdBy;
  final String updatedBy;
  final String title;
  final String image;
  final String url;
  final String status;
  final int order;
  final String type;
  final bool isAdvertisement;
  final bool isShowOnMobile;
 

  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerItem({
    required this.id,
    required this.title,
    required this.image,
    required this.isShowOnMobile,
    required this.url,
    required this.status,
    required this.order,
    required this.createdBy,
    required this.updatedBy,
    required this.isAdvertisement,
    // required this.isAdvertisement,
    required this.type,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    String clean(String? s) => (s ?? '').replaceAll('`', '').trim();
    DateTime? parseDate(String? s) {
      try {
        if (s == null || s.isEmpty) return null;
        return DateTime.parse(s);
      } catch (_) {
        return null;
      }
    }

    return BannerItem(
      id: json['id'] ?? '',
      title: clean(json['title']),
      image: clean(json['image']),
      url: clean(json['url']),
      isShowOnMobile: json['showOnMobile'] ?? false,
      status: clean(json['status']),
      isAdvertisement: json['advertisement'] ?? false,
      order: json['order'] ?? 0,
      type: clean(json['type']),
      createdBy: clean(json['created_by']),
      updatedBy: clean(json['updated_by']),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    String formatDate(DateTime? d) =>
        d != null ? DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(d.toUtc()) : '';
    return {
      'id': id,
      'title': title,
      'image': image,
      'url': url,
      'status': status,
      'order': order,
      'type': type,
      'advertisement': isAdvertisement,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'showOnMobile': isShowOnMobile,
      'createdAt': formatDate(createdAt),
      'updatedAt': formatDate(updatedAt),
    };
  }
}
