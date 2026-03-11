import 'package:connectivity_plus/connectivity_plus.dart';

/// Network Connectivity Service
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _subscription;

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  /// Check if device is connected to internet
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result.contains(ConnectivityResult.mobile) || 
           result.contains(ConnectivityResult.wifi) ||
           result.contains(ConnectivityResult.ethernet);
  }

  /// Get connection status stream
  Stream<bool> getConnectionStatusStream() {
    return _connectivity.onConnectivityChanged.map(
      (result) => result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.ethernet),
    );
  }

  /// Listen to connectivity changes
  void startListening(
    Function(bool) onConnectionChanged,
  ) {
    _subscription = getConnectionStatusStream().listen(onConnectionChanged);
  }

  /// Stop listening to connectivity changes
  void stopListening() {
    _subscription?.cancel();
  }

  /// Dispose
  void dispose() {
    _subscription?.cancel();
  }
}

import 'dart:async';
