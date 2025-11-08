import 'package:get/get.dart';
import '../../../../data/network/reseller/reseller_fack_leads/model/reseller_fack_lead_model.dart';
import '../../../../data/network/reseller/reseller_fack_leads/service/reseller_fack_lead_service.dart';

class ResellerFakeLeadController extends GetxController {
  final _service = ResellerFakeLeadService();

  /// Observables
  var isLoading = false.obs;
  var fakeLeadStats = Rxn<ResellerFakeLeadStatsData>();
  var errorMessage = ''.obs;

  /// Fetch reseller fake lead stats by ID
  Future<void> fetchFakeLeadStats(String resellerId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _service.fetchFakeLeadStats(resellerId);

      if (response != null && response.success) {
        fakeLeadStats.value = response.data;
      } else {
        errorMessage.value = response?.message ?? 'Failed to fetch data';
      }
    } catch (e) {
      errorMessage.value = 'Something went wrong: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data (for pull-to-refresh or retry)
  Future<void> refreshData(String resellerId) async {
    await fetchFakeLeadStats(resellerId);
  }
}
