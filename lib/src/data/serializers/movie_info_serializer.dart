part of 'serializer.dart';

class MovieInfoKeys {
  static const String id = 'id';
  static const String releaseDate = 'release_date';
  static const String title = 'title';
  static const String posterPath = 'poster_path';
}

class MovieInfoSerializer implements Serializer<MovieInfo, Map<String, dynamic>> {
  @override
  MovieInfo from(Map<String, dynamic> json) {
    final id = json[MovieInfoKeys.id] as int;
    final releaseDate = json[MovieInfoKeys.releaseDate] as String?;
    final title = json[MovieInfoKeys.title] as String;
    final posterPath = json[MovieInfoKeys.posterPath] as String?;

    return MovieInfo(
      id: id,
      releaseDate: releaseDate,
      title: title,
      posterPath: posterPath,
    );
  }

  @override
  Map<String, dynamic> to(MovieInfo object) {
    return {
      MovieInfoKeys.id: object.id,
      MovieInfoKeys.posterPath: object.posterPath,
      MovieInfoKeys.releaseDate: object.releaseDate,
      MovieInfoKeys.title: object.title,
    };
  }
}

final movieInfoSerializer = MovieInfoSerializer();