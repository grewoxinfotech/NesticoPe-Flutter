import 'package:get/get.dart';
import 'package:housing_flutter_app/data/network/referral/service/referrel_service.dart';

import '../../../data/network/referral/model/referrel_model.dart';

// Controller

class ReferralController extends GetxController {
  final referralCode = 'BF1D856F'.obs;
  final totalCodes = 1.obs;
  final activeResellers = 0.obs;
  final pendingResellers = 1.obs;
  final pointsEarned = 0.obs;
  final totalValue = 0.obs;
  final rewardsEarned = 0.obs;
  final requiredResellers = 10.obs;

  final isGenerate = false.obs;
  final isGenerated = false.obs;
  final isLoading = false.obs;
  Rxn<Referrel_Model> dummyReferral = Rxn<Referrel_Model>();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchReferralService();
  }

  Future<void> referralCodeGenerator() async {
    try {
      isGenerate.value = true;
      final success = await Referral_Service.instance.generateReferCode();
      if (success) {
        await fetchReferralService();
      }
    } catch (e) {
    } finally {
      isGenerate.value = false;
    }
  }

  Future<void> fetchReferralService() async {
    try {
      isLoading.value = true;
      final data = await Referral_Service.instance.fetchReferrals();
      dummyReferral.value = Referrel_Model.fromJson(data);
      if (dummyReferral.value != null) isGenerated.value = true;
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
}
