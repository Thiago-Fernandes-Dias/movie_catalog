import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'serialization_error.dart';

@immutable
abstract class BaseError extends Error with EquatableMixin {
  BaseError({required this.message});

  final String message;

  @override
  String toString() => message;

  @override
  List<Object?> get props => [message];
}