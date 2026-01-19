import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:housing_flutter_app/app/care/pagination/models/pagination_models.dart';

import '../../../app/care/pagination/controller/pagination_controller.dart';
import '../../../app/constants/color_res.dart';
import '../../../data/network/contractor/model/contractot_service_model/contractor_category_model.dart';
import '../../../data/network/contractor/model/new_hire_contractor.dart';
import '../../../data/network/contractor/service/hire_contractor_service.dart';


class HireContractorNewController extends PaginatedController<OverAllContractorItem> {
  // Observable variables
  var isLoading = false.obs;
  var categories = <OverAllContractorItem>[].obs;
  RxMap<String, String> filters = <String, String>{}.obs;
  var errorMessage = ''.obs;


  @override
  void onInit() {
    super.onInit();

    ever(filters, (_) => refreshList());
    loadInitial();

  }
  @override
  Future<PaginationResponse<OverAllContractorItem>> fetchItems(int page) async {

    final response = await HireContractorService.contractorMyService
        .fetchAllContractorByCategory(page:page,limit:24);
    print("Fetched items for all contractor: ${response.items.map((e) => e.toMap(),)}");
    return response;
  }

  Future<void> refreshService() async {
    try {
      isRefreshing.value = true;
      refreshList();
      await Future.delayed(const Duration(seconds: 1));

      // Update metrics with new values
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh ',
        backgroundColor: Colors.red,
        colorText: ColorRes.white,
      );
    } finally {
      isRefreshing.value = false;
    }
  }
}


