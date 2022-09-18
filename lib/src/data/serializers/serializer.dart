import '../../core/faults/errors/errors.dart';
import '../../domain/entities/entities.dart';
import '../../domain/enums/movie_status.dart';
import '../gateways/tmdb_rest_api_client/enums/enums.dart';

part 'cast_serializer.dart';
part 'companies_serializer.dart';
part 'countries_serializer.dart';
part 'credits_serializer.dart';
part 'genres_serializer.dart';
part 'movie_details_serializer.dart';
part 'movie_info_serializer.dart';
part 'movie_list_serializer.dart';
part 'movie_status_serializer.dart';
part 'tmdb_error_code_serializer.dart';

/// Middleware that parses a type [T] to/from a JSON representation in [Map].
abstract class Serializer<T extends Object, U> {
  T from(U json);
  U to(T object);
}
