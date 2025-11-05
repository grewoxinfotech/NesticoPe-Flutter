import 'package:get/get.dart';
import 'package:housing_flutter_app/data/database/secure_storage_service.dart';
import 'package:housing_flutter_app/data/network/property/models/inquiry_model.dart';
import '../../../data/network/property/services/property_contacted_service.dart';
import '../../property/controllers/property_controller.dart';
import 'package:housing_flutter_app/data/network/property/models/property_model.dart';

class PropertyContactedController extends GetxController {
  final PropertyContactedService _service = PropertyContactedService();
  final PropertyController _propertyController = Get.find<PropertyController>();

  /// Reactive list of contacted property IDs
  RxList<String> contactedPropertyIds = <String>[].obs;

  /// Reactive list of full Inquiry objects
  RxList<Inquiry> inquiries = <Inquiry>[].obs;

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
    fetchContactedProperties();
  }

  /// Fetch contacted property inquiries
  Future<void> fetchContactedProperties() async {
    try {
      isLoading.value = true;

      final user = await SecureStorage.getUserData();
      final userId = user?.user?.id ?? '';

      // Fetch all inquiries for user
      final inquiryList = await _service.fetchContactedInquiries(userId);
      inquiries.assignAll(inquiryList);

      // Extract only property IDs
      final ids = inquiryList.map((e) => e.propertyId).toList();
      contactedPropertyIds.assignAll(ids);

      // Reset and load first batch of property details
      properties.clear();
      currentIndex = 0;
      await loadNextBatch();
    } catch (e) {
      print(
        'Error in PropertyContactedController.fetchContactedProperties: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next batch of contacted properties (lazy loading)
  Future<void> loadNextBatch() async {
    if (isLoadingMore.value) return;
    if (currentIndex >= contactedPropertyIds.length) return;

    try {
      isLoadingMore.value = true;

      final endIndex = (currentIndex + batchSize).clamp(
        0,
        contactedPropertyIds.length,
      );
      final batch = contactedPropertyIds.sublist(currentIndex, endIndex);

      for (final id in batch) {
        final property = await _propertyController.getPropertyById(id);
        if (property != null) {
          properties.add(property);
        }
      }

      properties.refresh();
      currentIndex = endIndex;
    } catch (e) {
      print('Error loading next batch in PropertyContactedController: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Check if a property has been contacted
  bool isPropertyContacted(String propertyId) {
    return contactedPropertyIds.contains(propertyId);
  }

  /// Clear everything
  void clearContactedProperties() {
    contactedPropertyIds.clear();
    inquiries.clear();
    properties.clear();
    currentIndex = 0;
  }
}
