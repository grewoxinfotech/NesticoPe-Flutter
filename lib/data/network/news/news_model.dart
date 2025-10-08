class NewsModel {
  bool? success;
  String? message;
  NewsMessage? data;

  NewsModel({this.success, this.message, this.data});

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data:
          json['data'] != null
              ? NewsMessage.fromJson(json['data'] as Map<String, dynamic>)
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'message': message,
    'data': data?.toJson(),
  };
}

class NewsMessage {
  List<NewsItem>? items;
  Pagination? pagination;

  NewsMessage({this.items, this.pagination});

  factory NewsMessage.fromJson(Map<String, dynamic> json) {
    return NewsMessage(
      items:
          (json['items'] as List?)
              ?.map((x) => NewsItem.fromJson(x as Map<String, dynamic>))
              .toList(),
      pagination: Pagination(
        total: TypeConverter.parseInt(json['total']),
        current: TypeConverter.parseInt(json['currentPage']),
        totalPages: TypeConverter.parseInt(json['totalPages']),
        hasMore: json['hasMore'] as bool?,
        fetchedAll: json['fetchedAll'] as bool?,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((x) => x.toJson()).toList(),
    'pagination': pagination?.toJson(),
  };
}

class Pagination {
  int? total;
  int? current;
  int? totalPages;
  bool? hasMore;
  bool? fetchedAll;

  Pagination({
    this.total,
    this.current,
    this.totalPages,
    this.hasMore,
    this.fetchedAll,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: TypeConverter.parseInt(json['total']),
      current: TypeConverter.parseInt(json['currentPage']),
      totalPages: TypeConverter.parseInt(json['totalPages']),
      hasMore: json['hasMore'] as bool?,
      fetchedAll: json['fetchedAll'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
    'total': total,
    'current': current,
    'totalPages': totalPages,
    'hasMore': hasMore,
    'fetchedAll': fetchedAll,
  };
}

class NewsItem {
  String? id;
  String? createdBy;
  String? updatedBy;
  String? title;
  String? slug;
  String? content;
  String? summary;
  String? coverImage;
  String? category;
  List<String>? tags;
  String? author;
  String? authorDesignation;
  int? readTime;
  String? publishDate;
  String? status;
  bool? featured;
  String? metaTitle;
  String? metaDescription;
  int? viewCount;
  int? shareCount;
  String? createdAt;
  String? updatedAt;

  NewsItem({
    this.id,
    this.createdBy,
    this.updatedBy,
    this.title,
    this.slug,
    this.content,
    this.summary,
    this.coverImage,
    this.category,
    this.tags,
    this.author,
    this.authorDesignation,
    this.readTime,
    this.publishDate,
    this.status,
    this.featured,
    this.metaTitle,
    this.metaDescription,
    this.viewCount,
    this.shareCount,
    this.createdAt,
    this.updatedAt,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String?,
      createdBy: json['created_by'] as String?,
      updatedBy: json['updated_by'] as String?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      content: json['content'] as String?,
      summary: json['summary'] as String?,
      coverImage: json['coverImage'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List?)?.map((e) => e as String).toList(),
      author: json['author'] as String?,
      authorDesignation: json['authorDesignation'] as String?,
      readTime: TypeConverter.parseInt(json['readTime']),
      publishDate: json['publishDate'] as String?,
      status: json['status'] as String?,
      featured: json['featured'] as bool?,
      metaTitle: json['metaTitle'] as String?,
      metaDescription: json['metaDescription'] as String?,
      viewCount: TypeConverter.parseInt(json['viewCount']),
      shareCount: TypeConverter.parseInt(json['shareCount']),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_by': createdBy,
    'updated_by': updatedBy,
    'title': title,
    'slug': slug,
    'content': content,
    'summary': summary,
    'coverImage': coverImage,
    'category': category,
    'tags': tags,
    'author': author,
    'authorDesignation': authorDesignation,
    'readTime': readTime,
    'publishDate': publishDate,
    'status': status,
    'featured': featured,
    'metaTitle': metaTitle,
    'metaDescription': metaDescription,
    'viewCount': viewCount,
    'shareCount': shareCount,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

/// Safe converter for numbers
class TypeConverter {
  static int? parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
