part of 'errors.dart';

class NetworkConnectionError extends BaseError {
  NetworkConnectionError({
    required String message,
    required this.networkErrorType,
  }) : super(
          type: ErrorType.gatewayInconsistentState,
          message: message,
        );

  final NetworkErrorType networkErrorType;

  NetworkConnectionError.noNetwork()
      : this(
          message: 'No network connection. You should turn on the Wi-Fi or '
              'Mobile Data in your device.',
          networkErrorType: NetworkErrorType.noNetworkConnection,
        );

  NetworkConnectionError.noInternet()
      : this(
          message:
              'No internet connection. You should try to connect to another '
              'Wi-Fi network.',
          networkErrorType: NetworkErrorType.noInternetConnection,
        );
}
