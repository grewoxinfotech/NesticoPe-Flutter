import 'package:get/get.dart';
import '../mixins/network_aware_mixin.dart';

/// Example controller showing how to use NetworkAwareMixin
/// 
/// Usage:
/// 1. Add `with NetworkAwareMixin` to your controller
/// 2. Override `onInternetReconnected()` to refresh your APIs
/// 3. The mixin automatically handles setup and cleanup
class ExamplePropertyController extends GetxController with NetworkAwareMixin {
  final RxList<dynamic> properties = <dynamic>[].obs;
  final RxBool isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit(); // IMPORTANT: Call super.onInit() to setup network listener
    loadProperties();
  }
  
  /// Load properties from API
  Future<void> loadProperties() async {
    if (!hasInternet) {
      print('❌ No internet connection');
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Your API call here
      // final response = await PropertyService.getProperties();
      // properties.value = response.data;
      
      print('✅ Properties loaded successfully');
    } catch (e) {
      print('❌ Error loading properties: $e');
    } finally {
      isLoading.value = false;
    }
  }
  
  /// This method is automatically called when internet reconnects
  @override
  void onInternetReconnected() {
    super.onInternetReconnected(); // Optional: Call super to see debug logs
    
    print('🔄 Internet reconnected! Refreshing properties...');
    
    // Refresh all your important APIs here
    loadProperties();
    // loadOtherData();
    // refreshUserProfile();
  }
}

/// Example: Multiple controllers with network awareness
class ExampleDashboardController extends GetxController with NetworkAwareMixin {
  final RxList<dynamic> news = <dynamic>[].obs;
  final RxList<dynamic> trending = <dynamic>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }
  
  Future<void> loadDashboardData() async {
    if (!hasInternet) return;
    
    // Load all dashboard data
    await Future.wait([
      loadNews(),
      loadTrending(),
    ]);
  }
  
  Future<void> loadNews() async {
    // Your API call
    print('📰 Loading news...');
  }
  
  Future<void> loadTrending() async {
    // Your API call
    print('🔥 Loading trending...');
  }
  
  @override
  void onInternetReconnected() {
    super.onInternetReconnected();
    print('🔄 Refreshing dashboard data...');
    loadDashboardData();
  }
}

/// Example: Widget showing network status
/*
class NetworkStatusWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final networkService = Get.find<NetworkStatusService>();
    
    return Obx(() {
      if (!networkService.isConnected) {
        return Container(
          padding: EdgeInsets.all(8),
          color: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text(
                'No Internet Connection',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      }
      return SizedBox.shrink();
    });
  }
}
*/

/// Example: Manual callback registration (without mixin)
/*
class ManualNetworkController extends GetxController {
  late NetworkStatusService _networkService;
  
  @override
  void onInit() {
    super.onInit();
    
    // Get network service
    _networkService = Get.find<NetworkStatusService>();
    
    // Manually register callback
    _networkService.addReconnectionCallback(_onReconnect);
  }
  
  void _onReconnect() {
    print('🔄 Internet reconnected - refreshing data');
    // Refresh your APIs
  }
  
  @override
  void onClose() {
    // Don't forget to remove callback!
    _networkService.removeReconnectionCallback(_onReconnect);
    super.onClose();
  }
}
*/
