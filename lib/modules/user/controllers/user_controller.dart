import 'package:get/get.dart';
import '../../../data/network/auth/model/user_model.dart';
import '../../../data/network/user/service/user_service.dart';

class UserController extends GetxController {
  final UserService _userService = UserService();

  // Cache users by ID to avoid redundant API calls
  final RxMap<String, User> _userCache = <String, User>{}.obs;

  // Reactive user data
  Rxn<User> user = Rxn<User>();

  // Loading state
  RxBool isLoading = false.obs;

  // Error message
  RxString errorMessage = ''.obs;

  /// Fetch user by ID with caching
  Future<void> fetchUserById(String id) async {
    // Check cache first
    if (_userCache.containsKey(id)) {
      user.value = _userCache[id];
      errorMessage.value = '';
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final fetchedUser = await _userService.getUserById(id);

      if (fetchedUser != null) {
        user.value = fetchedUser;
        _userCache[id] = fetchedUser; // Cache for future use
      } else {
        errorMessage.value = 'User not found';
        user.value = null;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      user.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get user from cache without API call
  User? getCachedUser(String id) {
    return _userCache[id];
  }

  /// Reset user data
  void clearUser() {
    user.value = null;
    errorMessage.value = '';
  }

  /// Clear entire cache (useful for logout or refresh)
  void clearCache() {
    _userCache.clear();
  }
}
