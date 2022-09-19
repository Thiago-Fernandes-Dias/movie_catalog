part of 'repositories.dart';

abstract class MoviesRepository {
  Future<MovieDetails> getMovieDetails(String movieId);
  Future<MovieList> getTopRatedMovies(int page);
  Future<MovieList> getPopularMovies(int page);
  Future<Credits> getMovieCredits(String movieId);
}

class MoviesRepositoryImpl
    with DeviceNetworkConnectionMixin
    implements MoviesRepository {
  const MoviesRepositoryImpl(this.tmdbClient);

  final TMDBRestApiClient tmdbClient;

  @override
  Future<MovieDetails> getMovieDetails(String movieId) async {
    try {
      final url = '${env.tmdbApiUrl}/movie/$movieId';
      final response = await tmdbClient.get(url);
      final movieDetails = movieDetailsSerializer.from(response);
      return movieDetails;
    } on TMDBRequestError catch (e) {
      if (e.code == TMDBErrorCode.invalidId) {
        throw ResourceNotFoundError('Movie not found.');
      }
      throw InconsistentStateError.repository(e.message);
    } on TimeoutException {
      throw RequestTimeoutError();
    } on Exception {
      await verifyNetworkConnection();
      rethrow;
    }
  }

  @override
  Future<MovieList> getTopRatedMovies(int page) async {
    try {
      final url = '${env.tmdbApiUrl}/movie/top_rated?page=$page';
      final response = await tmdbClient.get(url);
      final movieList = movieListSerializer.from(response);
      return movieList;
    } on Exception catch (_) {
      await verifyNetworkConnection();
      rethrow;
    }
  }

  @override
  Future<MovieList> getPopularMovies(int page) async {
    try {
      final url = '${env.tmdbApiUrl}/movie/popular?page=$page';
      final response = await tmdbClient.get(url);
      final movieList = movieListSerializer.from(response);
      return movieList;
    } on Exception catch (_) {
      await verifyNetworkConnection();
      rethrow;
    }
  }

  @override
  Future<Credits> getMovieCredits(String movieId) async {
    final url = '${env.tmdbApiUrl}/movie/$movieId/credits';
    final response = await tmdbClient.get(url);
    final credits = creditsSerializer.from(response);
    return credits;
  }
}
