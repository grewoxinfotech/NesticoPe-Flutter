import 'package:get/get.dart';
import 'package:nesticope_app/data/database/secure_storage_service.dart';
import 'package:nesticope_app/data/network/property/models/inquiry_model.dart';
import '../../../data/network/property/services/property_contacted_service.dart';
import '../../property/controllers/property_controller.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class PropertyContactedController extends GetxController {
  final PropertyContactedService _service = PropertyContactedService();

  /// Reactive list of contacted property IDs
  RxList<String> contactedPropertyIds = <String>[].obs;

  /// Reactive list of full Inquiry objects
  RxList<Inquiry> inquiries = <Inquiry>[].obs;

  /// Loaded property details (lazy-loaded)
  // RxList<Items> properties = <Items>[].obs;

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
      final uniqueIds = inquiryList.where((e) => e.details != null && e.details!.id != null && e.details!.id!.isNotEmpty).toList(); // Remove duplicates
      contactedPropertyIds.assignAll(uniqueIds.map((e) => e.propertyId).toSet().toList());

      // Reset and load first batch of property details
      // properties.clear();
      currentIndex = 0;
      // await loadNextBatch();
    } catch (e) {
      print(
        'Error in Property Contacted Controller fetch Contacted Properties: $e',
      );
    } finally {
      isLoading.value = false;
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
    // properties.clear();
    currentIndex = 0;
  }

  Future<bool> addInquiry(Map<String, dynamic> data, String id) async {
    final success = await _service.addInquiry(data, id);
    if (success) {

      contactedPropertyIds.add(id);
      inquiries.refresh();
      fetchContactedProperties();
    
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Success',
        message: 'Inquiry submitted successfully',
        contentType: ContentType.success,
      );

      // Optionally, you could also fetch and add the full Inquiry object
      // after a successful addition.
    } else {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to submit inquiry',
        contentType: ContentType.failure,
      );
    }
    return success;
  }
}
