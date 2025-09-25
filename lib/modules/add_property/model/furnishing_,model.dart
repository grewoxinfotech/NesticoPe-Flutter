// ignore: file_names
class FurnishingItemModel {
  final String key;
  final String title;
  int quantity;

  FurnishingItemModel({
    required this.key,
    required this.title,
    this.quantity = 1,
  });
}