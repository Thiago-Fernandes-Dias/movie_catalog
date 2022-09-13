part of 'tmdb_rest_api_client.dart';

class _TMDBErrorKeys {
  static const String statusMessage = 'status_message';
  static const String statusCode = 'status_code';
  static const String errors = 'errors';
}

class TMDBInvalidRequestError implements Exception  {
  const TMDBInvalidRequestError({required this.message, required this.code});

  final int code;
  final String message;

  factory TMDBInvalidRequestError.fromJsonResponse(Map<String, dynamic> json) {
    const smKey = _TMDBErrorKeys.statusMessage;
    const scKey = _TMDBErrorKeys.statusCode;
    final message = json[smKey] as String;
    final code = json[scKey] as int;
    return TMDBInvalidRequestError(message: message, code: code);
  }

  @override
  String toString() => message;
}

class TMDBUnprocessableEntityError implements Exception {
  const TMDBUnprocessableEntityError(this.errors);

  final List<String> errors;

  factory TMDBUnprocessableEntityError.fromJsonResponse(Map<String, dynamic> json) {
    const errorKey = _TMDBErrorKeys.errors;
    final errors = json[errorKey] as List<String>;
    return TMDBUnprocessableEntityError(errors);
  }
}

class TMDBUnknownError implements Exception {
  const TMDBUnknownError(this.message);

  final String message;

  @override
  String toString() => message;
}