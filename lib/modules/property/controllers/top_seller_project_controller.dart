import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/builder/model/builder_model.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/data/network/property/services/top_seller_project_service.dart';

class TopSellerProjectController extends PaginatedController<ProjectItem> {
  final SellerProjectService _service = SellerProjectService();

  TopSellerProjectController({required this.sellerId});

  final String sellerId;
  RxInt total = 0.obs;
  final filters = <String, String>{};

  @override
  Future<PaginationResponse<ProjectItem>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProject(
        page: page,
        sellerId: sellerId,
        filters: filters,
      );
      total.value = response.meta.total;
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
