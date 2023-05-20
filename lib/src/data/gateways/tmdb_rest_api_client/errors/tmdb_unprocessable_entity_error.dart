part of 'errors.dart';

class TMDBUnprocessableEntityError implements Exception {
  const TMDBUnprocessableEntityError(this.errors);

  final List<String> errors;

  factory TMDBUnprocessableEntityError.fromJsonResponse(
      Map<String, dynamic> json) {
    const errorKey = _TMDBErrorKeys.errors;
    final errors = json[errorKey] as List<String>;
    return TMDBUnprocessableEntityError(errors);
  }

  @override
  String toString() => errors.first;
}
