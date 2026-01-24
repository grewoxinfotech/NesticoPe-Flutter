import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../data/network/contractor/service/hire_contractor_service.dart';
import '../../../widgets/messages/snack_bar.dart';

class HireContractorController
    extends PaginatedController<ContractorServiceCategory> {
  // Observable variables
  var isLoading = false.obs;
  var categories = <ContractorServiceCategory>[].obs;
  RxMap<String, String> filters = <String, String>{}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    filters.value = {'isActive': true.toString()};
    ever(filters, (_) => refreshList());
    loadInitial();
  }

  Future<void> applyFilters(Map<String, String> filter) async {
    filters.assignAll(filter);

    log("Apply Filter in Inquiry Contractor Section ${filters} ");
    // await loadInitial();
    refreshList();
  }

  @override
  Future<PaginationResponse<ContractorServiceCategory>> fetchItems(
    int page,
  ) async {
    final response = await HireContractorService.contractorMyService
        .getContractorCategory(page: page, filter: filters.value);
    print("Fetched items: ${response.items.length}");
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
        title: "Error",
        message: 'Failed to refresh ',
        contentType: ContentType.failure,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
}
