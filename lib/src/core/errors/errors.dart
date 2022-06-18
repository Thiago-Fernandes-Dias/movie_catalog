part 'tmdb_error.dart';

abstract class BaseError implements Exception {
  final String message;
  
  const BaseError({required this.message});

  String toString() => "Error: $message";
}