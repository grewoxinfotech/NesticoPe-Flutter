class PhotoImageModel {
  final String path;
  String label;
  bool isCover;

  PhotoImageModel({
    required this.path,
    this.label = 'Other',
    this.isCover = false,
  });

  PhotoImageModel copyWith({
    String? path,
    String? label,
    bool? isCover,
  }) {
    return PhotoImageModel(
      path: path ?? this.path,
      label: label ?? this.label,
      isCover: isCover ?? this.isCover,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'label': label,
      'isCover': isCover,
    };
  }
}