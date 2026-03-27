import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/property/models/property_model.dart';
import 'package:nesticope_app/data/network/property/services/seller_property_service.dart';

class TopSellerPropertyController extends PaginatedController<Items> {
  final SellerPropertyService _service = SellerPropertyService();

  TopSellerPropertyController({required this.sellerId});

  final String sellerId;
  RxInt total = 0.obs;
  final filters = <String, String>{};

  @override
  Future<PaginationResponse<Items>> fetchItems(int page) async {
    try {
      final response = await _service.fetchProperties(
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
