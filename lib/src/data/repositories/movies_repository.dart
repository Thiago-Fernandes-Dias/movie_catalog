part of 'repositories.dart';

abstract class MoviesRepository {
  Future<MovieDetails> getMovieDetails(String movieId);
  Future<MovieList> getTopRatedMovies(int page);
  Future<MovieList> getPopularMovies(int page);
  Future<Credits> getMovieCredits(String movieId);
}

class MoviesRepositoryImpl implements MoviesRepository {
  const MoviesRepositoryImpl(this.tmdbClient);

  final TMDBRestApiClient tmdbClient;

  @override
  Future<MovieDetails> getMovieDetails(String movieId) async {
    try {
      final response = await tmdbClient.get('$_path/$movieId');
      final movieDetails = movieDetailsSerializer.from(response);
      return movieDetails;
    } on TMDBRequestError catch (error) {
      if (error.code == TMDBErrorCode.resourceNotFound) throw MovieNotFoundException();
      rethrow;
    }
  }

  @override
  Future<MovieList> getTopRatedMovies(int page) async {
    final path = '$_path/top_rated?page=$page';
    final response = await tmdbClient.get(path);
    final movieList = movieListSerializer.from(response);
    return movieList;
  }

  @override
  Future<MovieList> getPopularMovies(int page) async {
    final url = '$_path/popular?page=$page';
    final response = await tmdbClient.get(url);
    final movieList = movieListSerializer.from(response);
    return movieList;
  }

  @override
  Future<Credits> getMovieCredits(String movieId) async {
    try {
      final response = await tmdbClient.get('$_path/$movieId/credits');
      final credits = creditsSerializer.from(response);
      return credits;
    } on TMDBRequestError catch (error) {
      if (error.code == TMDBErrorCode.resourceNotFound) throw MovieNotFoundException();
      rethrow;
    }
  }

  final _path = 'movie';
}
