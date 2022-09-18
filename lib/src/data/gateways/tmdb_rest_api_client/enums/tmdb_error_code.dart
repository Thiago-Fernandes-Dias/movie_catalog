part of 'enums.dart';

enum TMDBErrorCode implements Comparable<TMDBErrorCode> {
  invalidId(6),
  resourceNotFound(34);

  final int code;

  const TMDBErrorCode(this.code);

  @override
  int compareTo(TMDBErrorCode other) => code - other.code;
}
