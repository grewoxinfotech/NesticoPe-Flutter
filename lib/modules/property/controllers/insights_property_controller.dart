import 'package:get/get.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/network/property/models/property_model.dart';
import '../../../data/network/property/services/property_service.dart';

class InsightsPropertyController extends PaginatedController<Items> {
  final String city;
  final PropertyService _service = PropertyService();

  InsightsPropertyController({required this.city});

  Map<String, String>? filters = {};

  /// Selected property IDs
  final selectedPropertyIds = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    filters = {'city': city};
    loadInitial();
  }

  void toggleSelection(String id) {
    if (selectedPropertyIds.contains(id)) {
      selectedPropertyIds.remove(id);
    } else {
      selectedPropertyIds.add(id);
    }
  }

  void clearSelection() {
    selectedPropertyIds.clear();
  }

  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    final response = await _service.fetchProperties(
      page: page,
      filters: filters,
    );
    return response;
  }
}
