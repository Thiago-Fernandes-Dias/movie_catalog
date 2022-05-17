part of 'serializer.dart';

class GenresKeys {
  static const String id = 'id';
  static const String name = 'name';
}

class GenresSerializer implements Serializer<Genres, Map<String, dynamic>> {
  @override
  Genres from(Map<String, dynamic> json) {
    final name = json[GenresKeys.name] as String;
    final id = json[GenresKeys.id] as int;

    return Genres(name: name, id: id);
  }

  @override
  Map<String, dynamic> to(Genres object) {
    return {
      GenresKeys.id: object.id,
      GenresKeys.name: object.name,
    };
  }
}

final genresSerializer = GenresSerializer();