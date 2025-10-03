// class FavoriteManager {
//   static final FavoriteManager _instance = FavoriteManager._internal();
//   factory FavoriteManager() => _instance;
//   FavoriteManager._internal();
//
//   final Set<String> _favorites = {};
//
//   bool isFavorite(String item) => _favorites.contains(item);
//
//   void addFavorite(String item) {
//     _favorites.add(item);
//   }
//
//   void removeFavorite(String item) {
//     _favorites.remove(item);
//   }
//
//   void addAllFavorites(List<String> items) {
//     _favorites.clear();
//     _favorites.addAll(items);
//   }
//
//   Set<String> get favorites => _favorites;
// }

import 'package:get/get.dart';

class FavoriteManager {
  static final FavoriteManager _instance = FavoriteManager._internal();
  factory FavoriteManager() => _instance;
  FavoriteManager._internal();

  // Reactive set
  final RxSet<String> _favorites = <String>{}.obs;

  bool isFavorite(String item) => _favorites.contains(item);

  void addFavorite(String item) => _favorites.add(item);

  void removeFavorite(String item) => _favorites.remove(item);

  void addAllFavorites(List<String> items) {
    _favorites.clear();
    _favorites.addAll(items);
  }

  RxSet<String> get favorites => _favorites;
}
