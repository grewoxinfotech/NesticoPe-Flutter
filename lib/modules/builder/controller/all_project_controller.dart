import 'package:get/get.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/care/pagination/models/pagination_models.dart';
import '../../../data/network/builder/model/builder_model.dart';
import '../../../data/network/builder/service/builder_service.dart';

class AllProjectController extends PaginatedController<ProjectItem> {
  final BuilderService _service = BuilderService();

  /// Store applied filters
  final RxMap<String, String> appliedFilters = <String, String>{}.obs;

  /// Apply filters from filter screen
  Future<void> applyFilters(Map<String, String> filters) async {
    appliedFilters.assignAll(filters);
    await loadInitial();
  }

  /// Main API call (pagination)
  @override
  Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
    try {
      // API call → make sure your service supports filters + pagination
      final response = await _service.fetchProjects(
        page: page,
        filters: appliedFilters,
      );

      return response; // must return PaginationResponse<ProjectItem>
    } catch (e) {
      print("Error Could not load projects: ${e.toString()}");
      rethrow;
    }
  }
}
