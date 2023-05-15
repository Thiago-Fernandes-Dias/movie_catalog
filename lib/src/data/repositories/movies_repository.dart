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
    final url = '$_path/$movieId';
    final response = await tmdbClient.get(url);
    final movieDetails = movieDetailsSerializer.from(response);
    return movieDetails;
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
    final url = '$_path/$movieId/credits';
    final response = await tmdbClient.get(url);
    final credits = creditsSerializer.from(response);
    return credits;
  }

  final _path = 'movie';
}
