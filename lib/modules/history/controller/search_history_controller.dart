import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/history/model/search_history_model.dart';
import 'package:housing_flutter_app/data/network/history/service/search_history_service.dart';
import 'package:housing_flutter_app/utils/logger/app_logger.dart';

class SearchHistoryController extends GetxController {
  final Rxn<SearchHistoryResponse> searchHistoryResponse = Rxn<SearchHistoryResponse>();

  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  int currentIndex = 0;
  final int batchSize = 10;
  @override
  onInit() {
    super.onInit();
    fetchSearchHistory();
  }

  Future<bool> addSearchHistory(Map<String, dynamic> data) async {
    try {
      bool success = await SearchHistoryService.service.addSearchHistory(data);
      fetchSearchHistory();
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
     fetchSearchHistory();
     searchHistoryResponse.value?.data.item.clear();

    }
  }
}
