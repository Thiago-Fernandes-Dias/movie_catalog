import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'inconsistent_state_error.dart';
part 'serialization_error.dart';

@immutable
abstract class BaseError extends Error with EquatableMixin {
  BaseError({required this.type, required this.message});

  final ErrorType type;
  final String message;

  @override
  List<Object?> get props => [message, type];

  @override
  String toString() => '$type - $message';
}

enum ErrorType {
  // InconsistentStateError
  insistentErrorState,
  repositoryInconsistentState,
  serviceInconsistentState,
  gatewayInconsistentState,

  // SerializationError
  serialization,
}