import 'package:movie_list/src/models/models.dart';

part 'cast_serializer.dart';
part 'companies_serializer.dart';
part 'genres_serializer.dart';
part 'movie_details_serializer.dart';
part 'movie_info_serializer.dart';
part 'movie_list_serializer.dart';

/// Middleware that parses a type [T] to/from a JSON representation in [Map].
abstract class Serializer<T extends Object, U> {
  T from(U json);
  U to(T object);
}
