import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/property/models/favorite_item_model.dart';
import '../../../data/network/property/models/inquiry_model.dart';
import '../../../data/network/property/models/viewed_item_model.dart';
import '../../../data/network/property/services/propertry_favorite_service.dart';
import '../../../data/network/property/services/property_contacted_service.dart';

class PropertyFavoriteController extends GetxController {
  final PropertyFavoriteService _favoriteService = PropertyFavoriteService();

  /// Observables
    final PropertyContactedService _contactedService = PropertyContactedService();
  final RxBool isLoading = false.obs;
  final Rx<FavoriteResponseModel?> favoriteResponse =
      Rx<FavoriteResponseModel?>(null);
  RxList<Inquiry> inquiryResponse = <Inquiry>[].obs;
  final RxMap<String, bool> hasSubmittedInquiryMap = <String, bool>{}.obs;

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

    await loadFavorite();
  }
  Future<void> loadFavorite() async {
    final favorites = favoriteResponse.value?.data?.favorite ?? [];

    for (final item in favorites) {
      final propertyId = item.propertyId ?? item.details?.id ?? '';

      if (propertyId.isNotEmpty) {
        // ✅ Fetch all inquiries
        await getAllInQuireData(propertyId);

        // ✅ Check if specific inquiry exists
        await getHasInQuireData(propertyId);
      }
    }
  }
  Future<void> loadViews(List<PropertyView> viewedProperties ) async {
    List<PropertyView> favorites =viewedProperties;

    for (final item in favorites) {
      final propertyId = item.details?.id ?? item.details?.id ?? '';

      if (propertyId.isNotEmpty) {
        // ✅ Fetch all inquiries
        await getAllInQuireData(propertyId);

        // ✅ Check if specific inquiry exists
        await getHasInQuireData(propertyId);
      }
    }
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
    favoriteResponse.refresh();
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
  Future<void> getAllInQuireData(String propertyId) async {
    log('Property Id For Inquiry $propertyId');

    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';
      final inquiries = await _contactedService.fetchContactedInquiries(userId);
      inquiryResponse.assignAll(inquiries);

      final result = inquiryResponse.any((e) => e.propertyId == propertyId);

      hasSubmittedInquiryMap[propertyId] = result;
      hasSubmittedInquiryMap.refresh();
      print(
        "Inquiry Data ** ${inquiryResponse.map((e) => e.toJson()).toList()}    ${result} ",
      );
      print("Inquiry Response ** ${result} ");
    } catch (e) {
      print("Error fetching inquiries: $e");
    }
  }
  Future<bool> getHasInQuireData(String propertyId) async {
    log('Property Id For Inquiry $propertyId');

    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';
      final inquiries = await _contactedService.fetchHasInquiries(userId,itemId: propertyId);


      hasSubmittedInquiryMap[propertyId] = inquiries;
      hasSubmittedInquiryMap.refresh();
      print(
        "Inquiry Data ** ${inquiryResponse.map((e) => e.toJson()).toList()}    ${inquiries} ",
      );
      print("Inquiry Response ** ${inquiries} ");
      return inquiries;
    } catch (e) {
      print("Error fetching inquiries: $e");
      rethrow;
    }
  }
  /// --- UTILITY ---

  Future<void> refreshFavorites(String userId) async {
    await getFavorite(userId);
  }
}
