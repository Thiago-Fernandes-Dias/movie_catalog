part of 'exceptions.dart';

enum InternetConnectionExceptionType {
  noNetwork,
  noInternet,
}

class InternetConnectionException extends BaseException {
  InternetConnectionException({String? message, required this.type})
      : super(message ?? 'Internet connection exception');

  final InternetConnectionExceptionType type;
}
