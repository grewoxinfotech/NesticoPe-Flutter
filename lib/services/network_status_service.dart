import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkStatusService extends GetxService {
  final RxBool _isConnected = false.obs;
  final Rx<ConnectivityResult> _connectivityResult =
      ConnectivityResult.none.obs;

  // Getters for the observable variables
  ConnectivityResult get connectivityStatus => _connectivityResult.value;
  bool get isConnected => _isConnected.value;

  Future<NetworkStatusService> init() async {
    try {
      // Check initial connectivity status
      final connectivityResult = await Connectivity().checkConnectivity();
      _connectivityResult.value =
          connectivityResult.isNotEmpty
              ? connectivityResult.first
              : ConnectivityResult.none;

      // Assume connected if we have any connectivity
      _isConnected.value =
          connectivityResult.isNotEmpty &&
          connectivityResult.first != ConnectivityResult.none;

      // Listen to connectivity changes
      Connectivity().onConnectivityChanged.listen((result) {
        _connectivityResult.value =
            result.isNotEmpty ? result.first : ConnectivityResult.none;
        _isConnected.value =
            result.isNotEmpty && result.first != ConnectivityResult.none;
      });
    } catch (e) {}

    return this;
  }
}
