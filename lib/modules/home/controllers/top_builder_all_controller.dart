import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/top_seller_profile/model/top_builder_profile_model.dart';
import 'package:nesticope_app/data/network/top_seller_profile/service/top_seller_profile_service.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class TopBuilderAllController extends PaginatedController<BuilderItem> {
  final TopSellerService _service = TopSellerService();
  RxString createdBy = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  Future<PaginationResponse<BuilderItem>> fetchItems(int page) async {
    return _service.fetchTopBuilderProfiles(page: page, limit: 'all');
  }

  Future<void> refreshTopBuilderAll() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
}
