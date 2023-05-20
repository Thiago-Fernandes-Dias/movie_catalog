part of 'exceptions.dart';

class RequestTimeoutException extends BaseException {
  RequestTimeoutException([String? message]) : super(message ?? 'Request timeout. Try again later.');
}
