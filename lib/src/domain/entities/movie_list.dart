part of 'entities.dart';

class MovieList extends Equatable {
  final int page;
  final List<MovieInfo> results;
  final int totalPages;
  final int totalResults;

  const MovieList({
    required this.page,
    required this.results,
    required this.totalResults,
    required this.totalPages,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    var parsedMovieInfo = <MovieInfo>[];
    json['results'].forEach((element) {
      if (![null, ''].contains(element['release_date'])) {
        parsedMovieInfo.add(MovieInfo.fromJson(element));
      }
    });

    return MovieList(
      page: json['page'],
      results: parsedMovieInfo,
      totalResults: json['total_results'],
      totalPages: json['total_pages'],
    );
  }

  @override
  List<Object?> get props => [page, results, totalResults, totalPages];
}

MovieList parseMovieList(String jsonString) => MovieList.fromJson(jsonDecode(jsonString));
