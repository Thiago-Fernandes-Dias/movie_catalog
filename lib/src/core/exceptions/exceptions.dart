import 'package:equatable/equatable.dart';

part 'validation_exception.dart';

abstract class BaseException extends Equatable implements Exception {
  const BaseException({
    required this.type,
    this.message,
    this.debugInfo,
    this.debugData,
  });

  final String? message;
  final String? debugInfo;
  final ExceptionType type;
  final dynamic debugData;

  @override
  List<Object?> get props => [message, debugInfo, type, debugData];
}

enum ExceptionType {
  emptyField,
  fieldLengthExceeded,
  failedToOpenUrl,
}