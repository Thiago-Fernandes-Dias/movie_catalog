import '../../../serializers/serializer.dart';
import '../enums/enums.dart';

part 'tmdb_request_error.dart';
part 'tmdb_unprocessable_entity_error.dart';

class _TMDBErrorKeys {
  static const String statusMessage = 'status_message';
  static const String statusCode = 'status_code';
  static const String errors = 'errors';
}
