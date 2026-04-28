import 'package:get/get.dart';
import 'package:nesticope_app/app/care/pagination/controller/pagination_controller.dart';
import 'package:nesticope_app/app/care/pagination/models/pagination_models.dart';
import 'package:nesticope_app/data/network/history/model/search_history_model.dart';
import 'package:nesticope_app/data/network/history/service/search_history_service.dart';
import 'package:nesticope_app/utils/logger/app_logger.dart';

import '../../../data/network/history/model/success_story_model.dart';
import '../../../data/network/history/service/success_story_service.dart';

class SearchHistoryController extends PaginatedController<BuyerSideResellerSuccessStoryItem> {
  final Rxn<SearchHistoryResponse> searchHistoryResponse = Rxn<SearchHistoryResponse>();

  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  int currentIndex = 0;
  final int batchSize = 10;
  @override
  onInit() {
    super.onInit();
    loadInitial();
    fetchSearchHistory();
  }

  Future<bool> addSearchHistory(Map<String, dynamic> data) async {
    try {
      bool success = await SearchHistoryService.service.addSearchHistory(data);
      await fetchSearchHistory();
      return success;
    } catch (e) {
      print("Error in controller while adding search history: $e");
      return false;
    }
  }

  Future<void> fetchSearchHistory() async {
    try {
      isLoading.value = true;
      final historyData =
          await SearchHistoryService.service.fetchSearchHistory();
      searchHistoryResponse.value = SearchHistoryResponse.fromJson(historyData);

      AppLogger.structured(
        "Fetched search history data in controller:",
        historyData,
      );
      AppLogger.structured(
        "Fetched search history controller data in controller:", SearchHistoryResponse.fromJson(historyData),
      );
    } catch (e) {
      print("Error in controller while fetching search history: $e");
      // return {};
    }
    finally{
      isLoading.value = false;
    }
  }

  Future<void> deleteAllHistory() async {
    final success = await SearchHistoryService.service.deletedSearchHistory();
    if (success) {

     searchHistoryResponse.value?.data.item.clear();
    await fetchSearchHistory();
    }
  }

  @override
  Future<PaginationResponse<BuyerSideResellerSuccessStoryItem>> fetchItems(int page) {
    try{
      final response=SuccessStoryService.service.fetchResellerSuccessStories(status: 'published',limit: 10,module: 'reseller');
      AppLogger.structured("Buyer Side Success Stories", response);
      return response;
    }catch(e){

      rethrow;
    }
  }
}
