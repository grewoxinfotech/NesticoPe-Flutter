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
  Referrel_Model dummyReferral = Referrel_Model(
    success: true,
    message: "Referral data fetched successfully",
    data: [
      Data(
        id: "1",
        createdBy: "admin_001",
        updatedBy: "admin_002",
        referrerId: "user_101",
        referredUsers: "user_202,user_203,user_204",
        referralCode: "REF12345",
        referralLink: "https://example.com/referral/REF12345",
        status: "active",
        referralType: "signup_bonus",
        referrerReward: 20,
        expiryDate: "2025-12-31",
        totalReferrals: 3,
        totalRewards: "1500",
        isExpired: false,
        approvalStatus: "approved",
        approvalComment: null,
        createdAt: "2025-01-01T10:00:00Z",
        updatedAt: "2025-10-01T12:00:00Z",
      ),
    ],
  );


  void referralCodeGenerator(bool generate)
  {
    isGenerate.value=generate;
    isGenerate.refresh();

  }

  void fetchReferralService()
  {
    Referral_Service.instance.fetchReferrals();
  }

}