import 'package:housing_flutter_app/data/database/secure_storage_service.dart';

/// Class containing API related constants
class ApiConstants {
  // Base URL
  static const String baseURL = "http://housing.grewox.com/api/v1";

  // Auth Endpoints
  static const String auth = "$baseURL/auth";
  static const String loginEndpoint = "$auth/login";
  static const String registerEndpoint = "$auth/signup";
  static const String verifyOtpEndpoint = "$auth/verify-otp";
  static const String resendOtpEndpoint = "$auth/resend-otp";
  static const String sellerRegister = "$auth/seller-register";
  static const String covertToSeller = "$auth/convert-buyer-to-seller";
  static const String convertToReseller = "$auth/convert-buyer-to-reseller";
  static const String referralGet = "$baseURL/referral/my-stats";
  static const String generateReferCode = "$baseURL/referral/generate-code";

  // Leadhttp://localhost:19725/api/v1/referral/my-stats
  static const String leads = "$baseURL/lead";
  static const String news = "$baseURL/newsArticle";
  static const String platformService = "$baseURL/platformService";
  static const String propertyRecommend =
      "$baseURL/property/personalized-recommendations";
  static const String builderProject = "$baseURL/builderproject";
  static const String propertyReport = "$baseURL/propertyReport";

  //---------------------------------other-----------------------------//

  static const String cityInsights = "$baseURL/cityInsights/existing/city";
  static const String trendingCityInsights = "$baseURL/cityInsights/trending";

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

  static Future<Map<String, String>> getHeadersWithoutToken() async {
    // final token = await SecureStorage.getToken();
    // print("header_token: $token");
    return {contentType: applicationJson};
  }
}
