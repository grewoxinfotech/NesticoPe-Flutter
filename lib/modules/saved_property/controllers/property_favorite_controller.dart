import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nesticope_app/app/constants/color_res.dart';
import 'package:nesticope_app/app/utils/helper_function/user_helper/user_helper.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:lottie/lottie.dart';
import 'package:nesticope_app/modules/auth/views/otp_login_screen.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/property/models/favorite_item_model.dart';
import '../../../data/network/property/models/inquiry_model.dart';
import '../../../data/network/property/models/viewed_item_model.dart';
import '../../../data/network/property/services/propertry_favorite_service.dart';
import '../../../data/network/property/services/property_contacted_service.dart';
import '../../../widgets/messages/snack_bar.dart';

class PropertyFavoriteController extends GetxController {
  final PropertyFavoriteService _favoriteService = PropertyFavoriteService();

  /// Observables
  final PropertyContactedService _contactedService = PropertyContactedService();
  final RxBool isLoading = false.obs;
  final Rx<FavoriteResponseModel?> favoriteResponse =
      Rx<FavoriteResponseModel?>(null);
  RxList<Inquiry> inquiryResponse = <Inquiry>[].obs;
  final RxMap<String, bool> hasSubmittedInquiryMap = <String, bool>{}.obs;

  /// Negotiable offer tracking per property
  final RxMap<String, bool> hasNegotiableOfferMap = <String, bool>{}.obs;
  final RxMap<String, String?> negotiableOfferPriceMap =
      <String, String?>{}.obs;

  /// Reactive favorites (property IDs)
  final RxSet<String> favorites = <String>{}.obs;

  @override
  void onInit() {
    loadData();
    super.onInit();
  }

  Future<void> loadData() async {
    if (isClosed) return;
    final user = await SecureStorage.getUserData();
    if (isClosed) return;
    final userId = user?.user?.id ?? '';
    if (userId.isEmpty) {
      clearAllFavoriteState();
      return;
    }
    await getFavorite(userId);
    if (isClosed) return;
    await loadFavorite();
  }

  Future<void> loadFavorite() async {
    if (isClosed) return;
    final favorites = favoriteResponse.value?.data?.favorite ?? [];

    for (final item in favorites) {
      if (isClosed) return;
      final propertyId = item.propertyId;

      if (propertyId.isNotEmpty) {
        // ✅ Fetch all inquiries
        await getAllInQuireData(propertyId);
        if (isClosed) return;

        // ✅ Check if specific inquiry exists
        await getHasInQuireData(propertyId);
        if (isClosed) return;
        await loadNegotiableMetaForProperty(propertyId);
      }
    }
  }

  Future<void> loadViews(List<PropertyView> viewedProperties) async {
    if (isClosed) return;
    List<PropertyView> favorites = viewedProperties;

    for (final item in favorites) {
      if (isClosed) return;
      final propertyId = item.details?.id ?? '';

      if (propertyId.isNotEmpty) {
        // ✅ Fetch all inquiries
        await getAllInQuireData(propertyId);
        if (isClosed) return;

        // ✅ Check if specific inquiry exists
        await getHasInQuireData(propertyId);
        if (isClosed) return;
        await loadNegotiableMetaForProperty(propertyId);
      }
    }
  }

  /// --- API CALLS ---

  /// Fetch favorites from API and update local set
  Future<void> getFavorite(String userId) async {
    if (userId.isEmpty) {
      clearAllFavoriteState();
      return;
    }

    try {
      if (isClosed) return;
      isLoading.value = true;

      final response = await _favoriteService.getFavorite(userId);
      if (isClosed) return;

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
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: "Error",
        message: 'Something went wrong',
        contentType: ContentType.failure,
      );
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  /// --- LOCAL MANAGEMENT ---

  void clearAllFavoriteState() {
    favoriteResponse.value = null;
    favorites.clear();
    inquiryResponse.clear();
    hasSubmittedInquiryMap.clear();
    hasNegotiableOfferMap.clear();
    negotiableOfferPriceMap.clear();

    favoriteResponse.refresh();
    favorites.refresh();
    inquiryResponse.refresh();
    hasSubmittedInquiryMap.refresh();
    hasNegotiableOfferMap.refresh();
    negotiableOfferPriceMap.refresh();
  }

  bool isFavorite(String propertyId) => favorites.contains(propertyId);

  Future<void> addFavorite(String id) async {
    favorites.add(id);
    final success = await _favoriteService.addFavorite(id);
    if (success) {
      loadData();
      favoriteResponse.refresh();
      favorites.refresh();
      print("✅ Added to favorites: $id");
    } else {
      print("❌ Failed to add to favorites: $id");
    }
  }

  Future<void> removeFavorite(String propertyId) async {
    await _favoriteService.addFavorite(propertyId);
    favoriteResponse.value?.data?.favorite.removeWhere(
      (element) => element.propertyId == propertyId,
    );
    favorites.remove(propertyId);
    loadData();
    favoriteResponse.refresh();
    favorites.refresh();
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
    if (UserHelper.isGuest) {
      _showGuestFavoriteSheet(Get.context!);
      return;
    } else {
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
  }

  Future<void> getAllInQuireData(String propertyId) async {
    log('Property Id For Inquiry $propertyId');

    try {
      if (isClosed) return;
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      if (isClosed) return;
      final userId = user.user?.id ?? '';
      if (inquiryResponse.isEmpty) {
        final inquiries = await _contactedService.fetchContactedInquiries(userId);
        if (isClosed) return;
        inquiryResponse.assignAll(inquiries);
      }

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
      if (isClosed) return false;
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      if (isClosed) return false;
      final userId = user.user?.id ?? '';
      final inquiries = await _contactedService.fetchHasInquiries(
        userId,
        itemId: propertyId,
      );
      if (isClosed) return false;

      hasSubmittedInquiryMap[propertyId] = inquiries;
      hasSubmittedInquiryMap.refresh();
      print(
        "Inquiry Data ** ${inquiryResponse.map((e) => e.toJson()).toList()}    ${inquiries} ",
      );
      print("Inquiry Response ** ${inquiries} ");
      return inquiries;
    } catch (e) {
      // When the screen/app is closing or network is off, we don't want
      // cascading errors. Just return false.
      print("Error fetching inquiries: $e");
      return false;
    }
  }

  @override
  void onClose() {
    // Prevent pending async work from trying to update observables.
    super.onClose();
  }

  /// Fetch inquiries for a specific property and collect negotiable meta (for current user)
  Future<void> loadNegotiableMetaForProperty(String propertyId) async {
    try {
      final UserModel user = await SecureStorage.getUserData() ?? UserModel();
      final userId = user.user?.id ?? '';
      final list = await _contactedService.fetchInquiriesByPropertyId(userId);
      Inquiry? mine;
      for (final item in list) {
        if ((item.userId).toString() == userId &&
            item.propertyId == propertyId) {
          mine = item;
          break;
        }
      }
      final bool hasNegotiable =
          mine?.meta?.isNegotiable == true &&
          (mine?.meta?.negotiablePrice != null);
      final String? priceStr = mine?.meta?.negotiablePrice?.toString();
      hasNegotiableOfferMap[propertyId] = hasNegotiable;
      negotiableOfferPriceMap[propertyId] = hasNegotiable ? priceStr : null;
      hasNegotiableOfferMap.refresh();
      negotiableOfferPriceMap.refresh();
    } catch (e) {
      hasNegotiableOfferMap[propertyId] = false;
      negotiableOfferPriceMap[propertyId] = null;
      hasNegotiableOfferMap.refresh();
      negotiableOfferPriceMap.refresh();
      print("Error fetching negotiable meta: $e");
    }
  }

  void _showGuestFavoriteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Lottie.asset(
                    'assets/lottie/sign_in.json',
                    width: double.infinity,

                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Login Required',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: ColorRes.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please login to save properties to your wishlist and access personalized recommendations tailored to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      Get.to(() => OtpLoginScreen());
                    },
                    child: Text('Login', style: TextStyle(letterSpacing: 0.5)),
                  ),
                ),

                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text(
                    'Maybe Later',
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// --- UTILITY ---

  Future<void> refreshFavorites(String userId) async {
    await getFavorite(userId);
  }
}
