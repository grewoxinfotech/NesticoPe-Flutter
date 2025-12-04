class ApiConfig {
  // static const String mapkey='AIzaSyDf3m2Riy9RKDuAocail0y1RzMxxpVoIcw';
  // static const String mapkey = 'AIzaSyCGEPHINeyNmgffpaVbGkNZU0SPbtvWuXg';
  static const String mapkey = 'AIzaSyB2IH_Qm4eUKOPIN08NgvZ2tDtXKNAEpSs';
  static const String googleMapApi =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?key=$mapkey';

  static String token = '';

  static void updateToken(String newToken) {
    print("newToken=$newToken");
    token = newToken;
  }

  static Map<String, String> header() {
    final headers = {"Content-type": "application/json"};

    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    print("Final Headers: $headers");
    return headers;
  }
}
