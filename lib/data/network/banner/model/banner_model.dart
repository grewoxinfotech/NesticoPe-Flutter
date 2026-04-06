import 'package:intl/intl.dart';

class BannerItem {
  final String id;
  final String title;
  final String image;
  final String url;
  final String status;
  final int order;
  final String type;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerItem({
    required this.id,
    required this.title,
    required this.image,
    required this.url,
    required this.status,
    required this.order,
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
      status: clean(json['status']),
      order: json['order'] ?? 0,
      type: clean(json['type']),
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
      'createdAt': formatDate(createdAt),
      'updatedAt': formatDate(updatedAt),
    };
  }
}
