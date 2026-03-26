import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import 'package:nesticope_app/data/network/contractor/service/contractor_my_service.dart';
import 'package:nesticope_app/widgets/messages/snack_bar.dart';

class ContractorCategoryServiceController
    extends PaginatedController<ContractorServiceCategory> {


@override
void onInit() {
  super.onInit();
  loadInitial();
}

  @override
  Future<PaginationResponse<ContractorServiceCategory>> fetchItems(
    int page,
  ) async {
    // TODO: implement fetchItems
    final response = await ContractorMyService.contractorMyService
        .getContractorCategoryService(page: page);

    return response;
  }
    Future<void> refreshService() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      NesticoPeSnackBar.showAwesomeSnackbar(
        title: 'Error',
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
}
