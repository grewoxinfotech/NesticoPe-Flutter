import 'dart:async';
import 'package:get/get.dart';
import 'package:nesticope_app/data/network/banner/model/banner_model.dart';
import 'package:nesticope_app/data/network/banner/service/banner_service.dart';

class BannerHomeController extends GetxController {
  final BannerService _service = BannerService();
  final RxList<BannerItem> items = <BannerItem>[].obs;
  final Map<String, String> filters = {};

  @override
  void onInit() {
    super.onInit();
    _loadActiveBanners();
  }

  void refreshForHome() {
    _loadActiveBanners();
  }

  Future<void> _loadActiveBanners() async {
    try {
      final list = await _service.fetchActiveBanners();
      list.sort((a, b) => (a.order ?? 999).compareTo(b.order ?? 999));
      items.value = list;
    } catch (_) {}
  }
}
