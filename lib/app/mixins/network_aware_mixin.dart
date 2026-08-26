import 'package:get/get.dart';
import '../services/network_status_service.dart';

/// Mixin to make controllers network-aware
/// Automatically handles reconnection and API refresh
mixin NetworkAwareMixin on GetxController {
  NetworkStatusService? _networkService;

  @override
  void onInit() {
    super.onInit();
    _setupNetworkListener();
  }

  void _setupNetworkListener() {
    try {
      _networkService = Get.find<NetworkStatusService>();

      // Register callback for when internet reconnects
      _networkService?.addReconnectionCallback(_onInternetReconnected);
    } catch (e) {}
  }

  /// Override this method in your controller to refresh APIs when internet reconnects
  void onInternetReconnected() {
    // Default implementation - controllers can override this
  }

  void _onInternetReconnected() {
    // Call the overrideable method
    onInternetReconnected();
  }

  /// Check if internet is available
  bool get hasInternet => _networkService?.isConnected ?? true;

  @override
  void onClose() {
    // Remove callback when controller is disposed
    _networkService?.removeReconnectionCallback(_onInternetReconnected);
    super.onClose();
  }
}
