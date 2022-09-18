part of 'serializer.dart';

class TMDBErrorCodeSerializer implements Serializer<TMDBErrorCode, int> {
  @override
  TMDBErrorCode from(int statusCode) {
    const errorCodes = TMDBErrorCode.values;
    final matchConditionCB = (ec) => ec.code == statusCode;
    final noMatchCB = () => throw SerializationError('Invalid status code');
    final tmdbErrorCode = errorCodes.firstWhere(
      matchConditionCB,
      orElse: noMatchCB,
    );
    return tmdbErrorCode;
  }

  @override
  int to(TMDBErrorCode errorCodeEnum) => errorCodeEnum.code;
}

final tmdbErrorCodeSerializer = TMDBErrorCodeSerializer();
