import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../widgets/snack_bar/custom_snackbar.dart';

class NetworkStatusService extends GetxService {
  final RxBool _isConnected = true.obs;
  final Rx<ConnectivityResult> _connectivityResult = ConnectivityResult.none.obs;
  bool _wasDisconnected = false;
  
  // Debouncing timers to prevent rapid redirections
  Timer? _disconnectTimer;
  Timer? _reconnectTimer;
  
  // Stability check - wait before redirecting
  static const Duration _disconnectDelay = Duration(seconds: 3);
  static const Duration _reconnectDelay = Duration(seconds: 2);
  
  // Callbacks to execute when internet reconnects
  final List<VoidCallback> _reconnectionCallbacks = [];
  
  // Getters for the observable variables
  ConnectivityResult get connectivityStatus => _connectivityResult.value;
  bool get isConnected => _isConnected.value;

  Future<NetworkStatusService> init() async {
    try {
      // Check initial connectivity status
      final connectivityResult = await Connectivity().checkConnectivity();
      _connectivityResult.value = connectivityResult.isNotEmpty 
          ? connectivityResult.first 
          : ConnectivityResult.none;
      
      // Set initial connection state based on connectivity type
      _isConnected.value = connectivityResult.isNotEmpty &&
          connectivityResult.first != ConnectivityResult.none;
      
      // Listen to connectivity changes only (WiFi/Mobile on/off)
      // This is more reliable than InternetConnection for detecting true disconnection
      Connectivity().onConnectivityChanged.listen((result) {
        final newConnectivityResult = result.isNotEmpty 
            ? result.first 
            : ConnectivityResult.none;
        
        _connectivityResult.value = newConnectivityResult;
        
        // Only trigger when connectivity type changes (WiFi/Mobile/None)
        final hasConnectivity = newConnectivityResult != ConnectivityResult.none;
        _handleConnectionChange(hasConnectivity);
      });
    } catch (e) {
      print('Error initializing network status service: $e');
    }
    
    return this;
  }
  
  /// Handle connection state changes with debouncing
  void _handleConnectionChange(bool hasConnectivity) {
    print('🌐 Connectivity changed: $hasConnectivity');
    
    if (hasConnectivity) {
      // Cancel any pending disconnect timer
      _disconnectTimer?.cancel();
      _disconnectTimer = null;
      
      // Immediate reconnection - user has WiFi/Mobile back
      if (!_isConnected.value) {
        _isConnected.value = true;
        _onReconnected();
      }
    } else {
      // Cancel any pending reconnect timer
      _reconnectTimer?.cancel();
      _reconnectTimer = null;
      
      // Wait longer before showing no internet screen
      // This ensures it's truly disconnected, not just switching networks
      _disconnectTimer?.cancel();
      _disconnectTimer = Timer(_disconnectDelay, () {
        // Double check - still no connectivity?
        if (!hasConnectivity && _isConnected.value) {
          _isConnected.value = false;
          _onDisconnected();
        }
      });
    }
  }
  
  /// Called when internet disconnects
  void _onDisconnected() {
    _wasDisconnected = true;
    _redirectToNoInternetScreen();
  }
  
  /// Called when internet reconnects
  void _onReconnected() {
    if (_wasDisconnected) {
      _handleReconnection();
      _wasDisconnected = false;
    }
  }
  
  /// Redirect to no internet screen
  void _redirectToNoInternetScreen() {
    // Check if we're not already on no internet screen
    if (Get.currentRoute != '/no-internet') {
      print('❌ No internet - Redirecting to NoInternetScreen');
      Get.offAllNamed('/no-internet');
    }
  }
  
  /// Handle reconnection - restart from splash
  void _handleReconnection() {
    print('✅ Internet restored - Restarting from splash');
    
    // Small delay for better UX
    Future.delayed(const Duration(milliseconds: 500), () {
      // Clear all screens and go to splash
      Get.offAllNamed('/splash');
      
      // Execute callbacks after navigation
      Future.delayed(const Duration(milliseconds: 500), () {
        _executeReconnectionCallbacks();
      });
    });
  }
  
  /// Show no internet snackbar
  void _showNoInternetSnackbar() {
    final context = Get.overlayContext;
    if (context != null) {
      CustomSnackBar.show(
        context,
        message: 'No Internet Connection',
        type: SnackBarType.error,
        duration: const Duration(seconds: 4),
      );
    }
  }
  
  /// Show internet restored snackbar
  void _showInternetRestoredSnackbar() {
    final context = Get.overlayContext;
    if (context != null) {
      CustomSnackBar.show(
        context,
        message: 'Internet Connection Restored',
        type: SnackBarType.success,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  /// Register a callback to execute when internet reconnects
  void addReconnectionCallback(VoidCallback callback) {
    _reconnectionCallbacks.add(callback);
  }
  
  /// Remove a reconnection callback
  void removeReconnectionCallback(VoidCallback callback) {
    _reconnectionCallbacks.remove(callback);
  }
  
  /// Clear all reconnection callbacks
  void clearReconnectionCallbacks() {
    _reconnectionCallbacks.clear();
  }
  
  /// Execute all registered callbacks
  void _executeReconnectionCallbacks() {
    print('🔄 Executing ${_reconnectionCallbacks.length} reconnection callbacks');
    for (final callback in _reconnectionCallbacks) {
      try {
        callback();
      } catch (e) {
        print('Error executing reconnection callback: $e');
      }
    }
  }
  
  @override
  void onClose() {
    _disconnectTimer?.cancel();
    _reconnectTimer?.cancel();
    _reconnectionCallbacks.clear();
    super.onClose();
  }
}
