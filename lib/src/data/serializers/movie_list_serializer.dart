part of 'serializer.dart';

class MovieListKeys {
  static const String page = 'page';
  static const String results = 'results';
  static const String totalPages = 'total_pages';
  static const String totalResults = 'total_results';
}

class MovieListSerializer implements Serializer<MovieList, Map<String, dynamic>> {
  @override
  MovieList from(Map<String, dynamic> json) {
    final rawMovieInfos = List<Map<String, dynamic>>.from(json[MovieListKeys.results] as List);
    final movieInfos = rawMovieInfos.map(movieInfoSerializer.from).toList();

    final page = json[MovieListKeys.page] as int;
    final totalPages = json[MovieListKeys.totalPages] as int;
    final totalResults = json[MovieListKeys.totalResults] as int;

    return MovieList(
      page: page,
      results: movieInfos,
      totalPages: totalPages,
      totalResults: totalResults,
    );
  }

  @override
  Map<String, dynamic> to(MovieList object) {
    return {
      MovieListKeys.page: object.page,
      MovieListKeys.results: object.results,
      MovieListKeys.totalPages: object.totalPages,
      MovieListKeys.totalResults: object.totalResults,
    };
  }
}

final movieListSerializer = MovieListSerializer();