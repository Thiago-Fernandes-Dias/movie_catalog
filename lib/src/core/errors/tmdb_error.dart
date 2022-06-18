part of 'errors.dart';

class TMDBError extends BaseError {
  final int code;

  const TMDBError({required super.message, required this.code});

  factory TMDBError.fromJsonResponse(Map<String, dynamic> json) {
    return TMDBError(message: json['status_message'], code: json['status_code']);
  }
}