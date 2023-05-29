part of 'errors.dart';

class TMDBRequestError extends BaseException {
  TMDBRequestError(super.message, {required this.code});

  factory TMDBRequestError.fromJsonResponse(Map<String, dynamic> json) {
    const smKey = TMDBErrorKeys.statusMessage;
    const scKey = TMDBErrorKeys.statusCode;
    final message = json[smKey] as String;
    final code = tmdbErrorCodeSerializer.from(json[scKey] as int);
    return TMDBRequestError(message, code: code);
  }

  final TMDBErrorCode code;

  @override
  String toString() => message;

  @override
  List<Object?> get props => [...super.props, code];
}
