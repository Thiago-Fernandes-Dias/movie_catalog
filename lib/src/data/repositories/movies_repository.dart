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
    var response = await tmdbClient.get('${env.tmdbApiUrl}/movie/$movieId');      
    return movieDetailsSerializer.from(response);
  }
  
  @override
  Future<MovieList> getTopRatedMovies(int page) async {
    var response = await tmdbClient.get('${env.tmdbApiUrl}/movie/top_rated?page=$page');
    return movieListSerializer.from(response);
  }
  
  @override
  Future<MovieList> getPopularMovies(int page) async {
    var response = await tmdbClient.get('${env.tmdbApiUrl}/movie/popular?page=$page');
    return movieListSerializer.from(response);
  }
  
  @override
  Future<Credits> getMovieCredits(String movieId) async {
    var response = await tmdbClient.get('${env.tmdbApiUrl}/movie/$movieId/credits');
    return creditsSerializer.from(response);
  }
}
