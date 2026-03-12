import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  Future<bool> get isConnected async {
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    return results.isNotEmpty && results.first != ConnectivityResult.none;
  }
}
