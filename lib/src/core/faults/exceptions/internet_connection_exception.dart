part of 'exceptions.dart';

class InternetConnectionException extends BaseException {
  InternetConnectionException({String? message}) : super(message ?? 'Internet connection exception');
}
