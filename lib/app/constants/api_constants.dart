import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

/// Class containing API related constants
class ApiConstants {
  // Manual override options (comment/uncomment as needed):
  // static const String baseURL = "http://housing.grewox.com/api/v1"; // Live
  static const String url = "http://192.168.1.3:19725";
  static const String baseURL = "$url/api/v1"; // Real Device (WiFi)
  static const String ticketChat = url; // Real Device (WiFi)

  // Auth Endpoints
  static String get auth => "$baseURL/auth";

  static String get loginEndpoint => "$auth/login";

  static String get registerEndpoint => "$auth/signup";

  static String get verifyOtpEndpoint => "$auth/verify-otp";

  static String get resendOtpEndpoint => "$auth/resend-otp";

  static String get sellerRegister => "$auth/seller-register";

  static String get covertToSeller => "$auth/convert-buyer-to-seller";

  static String get convertToReseller => "$auth/convert-buyer-to-reseller";

  static String get convertToContractor => "$auth/convert-buyer-to-contractor";

  static String get referralGet => "$baseURL/referral/my-stats";

  static String get generateReferCode => "$baseURL/referral/generate-code";

  static String get getUserProfile => "$baseURL/user/profile";

  static String get getSellerDashboard => "$baseURL/insight/seller";

  static String get getSellerProfile => "$baseURL/insight/seller";

  static String get recommmendedPorperties => "$baseURL/property/recommended";

  static String get subscriptionPlan => "$baseURL/subscriptionPlan";

  static String get subscription => "$baseURL/subscription";

  // Lead
  static String get leads => "$baseURL/lead";

  static String get news => "$baseURL/newsArticle";

  static String get platformService => "$baseURL/platformService";

  static String get propertyRecommend =>
      "$baseURL/property/personalized-recommendations";

  static String get builderProject => "$baseURL/builderproject";

  static String get propertyReport => "$baseURL/propertyReport";

  static String get resellerSuccessStory => "$baseURL/resellerSuccessStory";

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

  static String get property => "$baseURL/property";

  static String get fackLead => "$baseURL/lead/reseller";

  static String get topSeller => "$baseURL/user/sellers/top";

  static String get calendar => "$baseURL/calendar";

  static String get calendarCategory => "$baseURL/calendarCategory";

  static String get ticket => "$baseURL/ticket";

  ///-----------------------------Contractor----------------------------------//

  static String get contractorDashboard=> "$baseURL/insight/contractor";
  static String get contractorService=> "$baseURL/contractorService";
  static String get contractorServiceCategory=> "$baseURL/contractorServiceCategory";
  static String get contractorInquiry=> "$baseURL/contractorInquiry";
  static String get contractorProject=> "$baseURL/contractorProjects";
  static String get contractorLeadFollowUp=> "$baseURL/followup";


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
    print("header_token: $token");
    return {contentType: applicationJson, authorization: "Bearer $token"};
  }

  static Future<Map<String, String>> getHeadersWithoutToken() async {
    // final token = await SecureStorage.getToken();
    // print("header_token: $token");
    return {contentType: applicationJson};
  }
}
