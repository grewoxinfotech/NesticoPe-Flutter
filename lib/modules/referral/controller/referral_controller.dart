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

  final isGenerate =false.obs;
  Referrel_Model? dummyReferral;

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchReferralService();
  }
  void referralCodeGenerator(bool generate)
  {
    isGenerate.value=generate;
    isGenerate.refresh();

  }

  Future<void> fetchReferralService()
  async {
final data  = await Referral_Service.instance.fetchReferrals();
dummyReferral=Referrel_Model.fromJson(data);
print(dummyReferral?.data?.first.totalRewards);

  }

}