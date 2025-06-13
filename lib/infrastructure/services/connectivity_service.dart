import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

abstract class ConnectivityService {
  Stream<bool> get isConnected;
  Future<bool> checkConnectivity();
}

@LazySingleton(as: ConnectivityService)
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  final StreamController<bool> _connectivityController = StreamController<bool>.broadcast();

  ConnectivityServiceImpl(this._connectivity) {
    _initConnectivityListener();
  }

  @override
  Stream<bool> get isConnected => _connectivityController.stream;

  @override
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    final isConnected = _isConnectedResult(result);
    _connectivityController.add(isConnected);
    return isConnected;
  }

  void _initConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = results.any((result) => _isConnectedResult([result]));
      _connectivityController.add(isConnected);
    });
  }

  bool _isConnectedResult(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );
  }

  void dispose() {
    _connectivityController.close();
  }
}
