import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

/// Class containing API related constants
class ApiConstants {
  // Manual override options (comment/uncomment as needed):
  // static const String baseURL = "http://housing.grewox.com/api/v1"; // Live

  static const String url = "http://192.168.1.10:19725";
  // static const String url = "https://nesticopeapi.grewoxinfotech.com";
  // static const String url = "https://commentary-flush-reprints-prison.trycloudflare.com";

  // static const String url =
  //     "https://bow-dir-facility-adjusted.trycloudflare.com";
  static const String baseURL = "$url/api/v1"; // Real Device (WiFi)
  static const String ticketChat = url; // Real Device (WiFi)

  // Notification Endpoints
  static String get notifications => "$baseURL/notification";
  static String get notificationsMarkAsRead =>
      "$baseURL/notification/mark-all-read";

  // Auth Endpoints
  static String get auth => "$baseURL/auth";

  static String get deleteAccount => "$baseURL/deleteAccount";

  static String get loginEndpoint => "$auth/login";

  static String get registerEndpoint => "$auth/signup";

  static String get verifyOtpEndpoint => "$auth/verify-otp";

  static String get resendOtpEndpoint => "$auth/resend-otp";

  static String get sellerRegister => "$auth/seller-register";

  static String get covertToSeller => "$auth/convert-buyer-to-seller";

  static String get convertToReseller => "$auth/convert-buyer-to-reseller";

  static String get convertToContractor => "$auth/convert-buyer-to-contractor";

  static String get aadharInitiateVerification =>
      "$auth/initiate-aadhaar-verification";

  static String get aadharVerifyOtp => "$auth/verify-aadhaar-otp";

  static String get digitalSignature => "$baseURL/digitalsignature";

  static String get sendNotificationId => "$baseURL/user/notification/token";

  static String get removeNotificationId => "$baseURL/user/notification/token";

  static String get referralGet => "$baseURL/referral/my-stats";

  static String get referral => "$baseURL/referral";

  static String get generateResellerCertificate =>
      "$baseURL/certificate/generate-and-save-certificate";

  static String get generateReferCode => "$baseURL/referral/generate-code";

  static String get getUserProfile => "$baseURL/user/profile";

  static String get getSellerDashboard => "$baseURL/insight/seller";

  static String get getSellerProfile => "$baseURL/insight/seller";

  static String get getProfile => "$baseURL/user/profile";

  static String get recommmendedPorperties =>
      "$baseURL/property/personalized-recommendations";

  static String get subscriptionPlan => "$baseURL/subscriptionPlan";
  static String get searchHistory => "$baseURL/searchHistory";

  static String get subscription => "$baseURL/subscription";
  static String get subscriptionPlanInquiry =>
      "$baseURL/subscriptionPlanInquiry";

  // Lead
  static String get leads => "$baseURL/lead";

  static String get visit => "$baseURL/visit";

  static String get news => "$baseURL/newsArticle";

  static String get platformService => "$baseURL/platformService";

  static String get propertyRecommend =>
      "$baseURL/property/personalized-recommendations";

  static String get builderProject => "$baseURL/builderproject";

  static String get propertyReport => "$baseURL/propertyReport";

  static String get resellerSuccessStory => "$baseURL/resellerSuccessStory";

  static String get resellerCityWiseReseller =>
      "$baseURL/insight/citywise-leaderboard";

  static String get resellerGetAllCity =>
      "$baseURL/cityInsights/reseller-cities";

  static String get locationPriceMetrics => "$baseURL/locationPriceMetrics";

  static String get review => "$baseURL/review";

  static String get overAllRating => "$baseURL/review/property";

  static String get sharePropertyLink => "$baseURL/propertyShare/simple";

  static String get user => "$baseURL/user";

  static String get topProperties => "$baseURL/property/top/properties";

  static String get topProject => "$baseURL/builderproject/top/projects";

  static String get interestForm => "$baseURL/interestForm";

  static String get propertyShare => "$baseURL/propertyShare";

  static String get multiPropertyShare => "$baseURL/propertyShare/bundles";

  static String get resellerDashboard => "$baseURL/insight/reseller";
  static String get propertyInquiry => "$baseURL/property/inquiries/all";
  static String get propertyByIDInquiry => "$baseURL/property/inquiry";

  static String get leadVisit => "$baseURL/visit";
  static String get leadNegotiablePrice => "$baseURL/propertyNegotiablePrice";

  static String get property => "$baseURL/property";

  static String get fackLead => "$baseURL/lead/reseller";

  static String get topSeller => "$baseURL/user/sellers/top";

  static String get calendar => "$baseURL/calendar";

  static String get calendarCategory => "$baseURL/calendarCategory";

  static String get ticket => "$baseURL/ticket";

  static String get topContractor => "$baseURL/user/contractors/top";

  ///-----------------------------Contractor----------------------------------//

  static String get contractorDashboard => "$baseURL/insight/contractor";

  static String get contractorService => "$baseURL/contractorService";

  static String get contractorServiceCategory =>
      "$baseURL/contractorServiceCategory";

  static String get contractorServiceByCategory =>
      "$baseURL/contractorService/by-category";
  static String get contractorServicesCity =>
      "$baseURL/cityInsights/contractor-cities";

  static String get resellerPropertyShare => "$baseURL/propertyShare/reference";

  static String get contractorInquiry => "$baseURL/contractorInquiry";
  static String get contractorInquiryQuotation =>
      "$baseURL/contractorquotation";

  static String get contractorProject => "$baseURL/contractorProjects";
  static String get contractorProjectPhotos =>
      "$baseURL/contractor-project-photos";

  static String get contractorProjectMilestone => "$baseURL/projectmilestone";

  static String get contractorProjectMilestonePayment =>
      "$baseURL/milestonepayment";

  static String get contractorLeadFollowUp => "$baseURL/followup";
  static String get myContractorProfileReview =>
      "$baseURL/review/check/contractor_service";

  static String get contractorCompare =>
      "$baseURL/contractorService/contractor";

  static String get contractorUserProfile => "$baseURL/user/profiles";

  static String get contractorEmployees => "$baseURL/employee";

  static String get contractorTopServiceCategory =>
      "$baseURL/contractorServiceCategory/top";

  //---------------------------------other-----------------------------//

  static String get cityInsights => "$baseURL/cityInsights/existing/city";

  static String get trendingCityInsights => "$baseURL/cityInsights/trending";

  static String get platformReview => "$baseURL/review";

  static const String logoutEndpoint = "/auth/logout";
  static const String resetPasswordEndpoint = "/auth/reset-password";

  // User Endpoints
  static const String userEndpoint = "/user";
  static const String userProfileEndpoint = "/user/profile";

  // Property Endpoints
  static const String propertiesEndpoint = "/properties";
  static const String featuredPropertiesEndpoint = "/properties/featured";
  static const String recommendedPropertiesEndpoint = "/properties/recommended";
  static const String propertiesByCategoryEndpoint = "/properties/category";

  //Trending area

  static const String trendingAreaAPi = '/cityInsights/trending/areas?city';

  // Bookings Endpoints
  static const String bookingsEndpoint = "/bookings";

  // Favorites Endpoints
  static const String favoritesEndpoint = "/favorites";

  // Reviews Endpoints
  static const String reviewsEndpoint = "/reviews";

  // headers from api
  static const String contentType = "Content-type";
  static const String applicationJson = "application/json";

  // headers for auth
  static const String authorization = "Authorization";

  static Future<Map<String, String>> getHeaders() async {
    final token = await SecureStorage.getToken();
    print("header_token: $token");
    return {contentType: applicationJson, authorization: "Bearer $token"};
  }

  static Future<Map<String, String>> getUpdatedHeaders() async {
    final token = await SecureStorage.getUpdatePhoneToken();
    print("header_token Updated token for otp verification: $token");
    return {contentType: applicationJson, authorization: "Bearer $token"};
  }

  static Future<Map<String, String>> getHeadersWithoutToken() async {
    // final token = await SecureStorage.getToken();
    // print("header_token: $token");
    return {contentType: applicationJson};
  }
}

///http://192.168.1.5:19725/api/v1/certificate/generate-and-save-certificate
///
/// payload
///{
//     "userId": "1lH7F520ZTMd9ZZ9ihxCU0i",
//     "certificateData": {
//         "firstName": "",
//         "lastName": "",
//         "username": "rs1",
//         "email": "rs1@yopmail.com",
//         "phone": "2548796542"
//     }
// }

///response
///
/// {
//     "success": true,
//     "message": "Certificate generated and saved successfully",
//     "data": {
//         "certificateId": "BzjmgaqQ1ANANEGRBRzcSUM",
//         "certificateUrl": "https://crmmediabucket.s3.amazonaws.com/RealEstate/superadmin/reseller/common/1lH7F520ZTMd9ZZ9ihxCU0i/certificate/2026-01/reseller_certificate_1768967368494_rs1.pdf.pdf"
//     }
// }
