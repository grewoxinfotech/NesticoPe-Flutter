import 'dart:async';
import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/banner/model/banner_model.dart';
import 'package:nesticope_app/data/network/banner/service/banner_service.dart';

class BannerHomeController extends PaginatedController<BannerItem> {
  final BannerService _service = BannerService();
  final Map<String, String> filters = {};

  @override
  void onInit() {
    super.onInit();
    loadInitial();
  }

  @override
  Future<PaginationResponse<BannerItem>> fetchItems(int page) async {
    return _service.fetchBanners(page: page, limit: 12, filters: filters);
  }

  void refreshForHome() {
    refreshList();
  }
}
