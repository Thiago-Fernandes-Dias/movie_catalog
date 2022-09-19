part of 'mixins.dart';

mixin DeviceNetworkConnectionMixin {
  Future<void> verifyNetworkConnection() async {
    final connectedToNetworkValues = [
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
    ];
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectedToNetworkValues.contains(connectivityResult)) {
      await _verifyInternetConnection();
      return;
    }
    throw NetworkConnectionError.noNetwork();
  }

  Future<void> _verifyInternetConnection() async {
    final hasConnection = await InternetConnectionCheckerPlus().hasConnection;
    if (hasConnection) return;
    throw NetworkConnectionError.noInternet();
  }
}
