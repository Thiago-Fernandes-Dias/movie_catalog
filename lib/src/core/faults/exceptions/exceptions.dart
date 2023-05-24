import 'package:equatable/equatable.dart';

part 'request_unknown_exception.dart';
part 'request_timeout_exception.dart';
part 'internet_connection_exception.dart';

class BaseException extends Equatable implements Exception {
  BaseException(this.message) {
    for (final observer in observers) {
      observer.call(this);
    }
  }

  final String message;

  static List<BaseExceptionObserver> observers = [];

  @override
  List<Object?> get props => [message];
}

typedef BaseExceptionObserver = void Function(BaseException exception);
