import 'dart:async';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import '../../../data/network/property/models/favorite_item_model.dart';
import '../../../data/network/property/services/propertry_favorite_service.dart';

class PropertyFavoriteController extends GetxController {
  final PropertyFavoriteService _favoriteService = PropertyFavoriteService();

  /// Observables
  final RxBool isLoading = false.obs;
  final Rx<FavoriteResponseModel?> favoriteResponse =
      Rx<FavoriteResponseModel?>(null);

  /// Reactive favorites (property IDs)
  final RxSet<String> favorites = <String>{}.obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    final user = await SecureStorage.getUserData();
    final userId = user?.user?.id ?? '';
    await getFavorite(userId);
  }

  /// --- API CALLS ---

  /// Fetch favorites from API and update local set
  Future<void> getFavorite(String userId) async {
    try {
      isLoading.value = true;

      final response = await _favoriteService.getFavorite(userId);

      if (response != null && response.success) {
        favoriteResponse.value = response;

        final ids =
            response.data?.favorite.map((e) => e.propertyId).toList() ?? [];

        favorites
          ..clear()
          ..addAll(ids);

        print("✅ Favorites loaded: ${favorites.length}");
      } else {
        // Get.snackbar('Error', 'Failed to fetch favorites');
        favorites.clear();
      }
    } catch (e) {
      print("❌ Exception in getFavorite: $e");
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  /// --- LOCAL MANAGEMENT ---

  bool isFavorite(String propertyId) => favorites.contains(propertyId);

  Future<void> addFavorite(String id) async {
    favorites.add(id);
    final success = await _favoriteService.addFavorite(id);
  }

  Future<void> removeFavorite(String propertyId) async {
    await _favoriteService.addFavorite(propertyId);
    favoriteResponse.value?.data?.favorite.removeWhere(
      (element) => element.propertyId == propertyId,
    );
    favorites.remove(propertyId);
    print("🗑️ Removed from favorites: $propertyId");
  }

  void addAllFavorites(List<String> items) {
    favorites
      ..clear()
      ..addAll(items);
    print("✅ Added all favorites (${items.length})");
  }

  /// --- TOGGLE FAVORITE ---

  Future<void> toggleFavorite(String propertyId) async {
    try {
      if (isFavorite(propertyId)) {
        removeFavorite(propertyId);
      } else {
        addFavorite(propertyId);
      }
      favorites.refresh();
    } catch (e) {
      print("❌ Exception in toggleFavorite: $e");
    }
  }

  /// --- UTILITY ---

  Future<void> refreshFavorites(String userId) async {
    await getFavorite(userId);
  }
}
