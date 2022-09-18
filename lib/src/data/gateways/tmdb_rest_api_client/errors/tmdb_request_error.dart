part of 'errors.dart';

class TMDBRequestError implements Exception {
  const TMDBRequestError({required this.code, required this.message});

  factory TMDBRequestError.fromJsonResponse(Map<String, dynamic> json) {
    const smKey = _TMDBErrorKeys.statusMessage;
    const scKey = _TMDBErrorKeys.statusCode;
    final message = json[smKey] as String;
    final code = tmdbErrorCodeSerializer.from(json[scKey] as int);
    return TMDBRequestError(message: message, code: code);
  }

  final TMDBErrorCode code;
  final String message;

  @override
  String toString() => message;
}
