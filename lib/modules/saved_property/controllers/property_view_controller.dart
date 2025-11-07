import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';
import '../../../data/network/property/models/viewed_item_model.dart';
import '../../../data/network/property/services/property_view_service.dart';
import '../../property/controllers/property_controller.dart';

class PropertyViewController extends GetxController {
  final PropertyViewService _service = PropertyViewService();
  final PropertyController _propertyController = Get.find<PropertyController>();

  /// Reactive list of viewed property IDs
  RxList<PropertyView> viewedProperties = <PropertyView>[].obs;

  /// Loaded property details (lazy-loaded)
  RxList<Items> properties = <Items>[].obs;

  /// Loading states
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  /// Pagination or incremental loading support
  final int batchSize = 5;
  int currentIndex = 0;

  @override
  void onInit() {
    super.onInit();
    fetchViewedProperties();
  }

  /// Fetch viewed property IDs only
  Future<void> fetchViewedProperties() async {
    try {
      isLoading.value = true;

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';
      final data = await _service.fetchViewedPropertyIds(userId);
      if (data?.data?.property != null && data!.data!.property.isNotEmpty) {
        viewedProperties.assignAll(data.data!.property);
      }
      properties.clear();
      currentIndex = 0;

      // Load first batch automatically
      // await loadNextBatch();
    } catch (e) {
      print('Error in PropertyViewController.fetchViewedProperties: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next batch of viewed properties (lazy loading)
  // Future<void> loadNextBatch() async {
  //   if (isLoadingMore.value) return;
  //   if (currentIndex >= viewedProperties.length) return;
  //
  //   try {
  //     isLoadingMore.value = true;
  //
  //     final endIndex = (currentIndex + batchSize).clamp(
  //       0,
  //       viewedProperties.length,
  //     );
  //     final batch = viewedProperties.sublist(currentIndex, endIndex);
  //
  //     for (final id in batch) {
  //       final property = await _propertyController.getPropertyById(id);
  //       if (property != null) {
  //         properties.add(property);
  //       }
  //     }
  //
  //     properties.refresh();
  //     currentIndex = endIndex;
  //   } catch (e) {
  //     print('Error loading next batch: $e');
  //   } finally {
  //     isLoadingMore.value = false;
  //   }
  // }

  /// Check if a property has been viewed
  bool isPropertyViewed(String propertyId) {
    return viewedProperties.contains(propertyId);
  }

  /// Clear everything
  void clearViewedProperties() {
    viewedProperties.clear();
    properties.clear();
    currentIndex = 0;
  }
}
