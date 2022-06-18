part of 'repositories.dart';

abstract class MoviesRepository {
  Future<MovieDetails> getMovieDetails(String movieId);
  Future<MovieList> getTopRatedMovies(int page);
  Future<MovieList> getPopularMovies(int page);
  Future<Credits> getMovieCredits(String movieId);
}

class MoviesRepositoryImpl implements MoviesRepository {
  final _httpClient = HttpClient();

  @override
  Future<MovieDetails> getMovieDetails(String movieId) async {
    var response = await _httpClient.get("${env.tmdbApiUrl}/movie/$movieId");      
    if (response.statusCode != 200) throw TMDBError.fromJsonResponse(response.data);
    return movieDetailsSerializer.from(response.data);
  }
  
  @override
  Future<MovieList> getTopRatedMovies(int page) async {
    var response = await _httpClient.get("${env.tmdbApiUrl}/movie/top_rated?page=$page");
    if (response.statusCode != 200) throw TMDBError.fromJsonResponse(response.data);
    return movieListSerializer.from(response.data);
  }
  
  @override
  Future<MovieList> getPopularMovies(int page) async {
    var response = await _httpClient.get("${env.tmdbApiUrl}/movie/popular?page=$page");
    if (response.statusCode != 200) throw TMDBError.fromJsonResponse(response.data);
    return movieListSerializer.from(response.data);
  }
  
  @override
  Future<Credits> getMovieCredits(String movieId) async {
    var response = await _httpClient.get("${env.tmdbApiUrl}/movie/credits");
    if (response.statusCode != 200) throw TMDBError.fromJsonResponse(response.data);
    return creditsSerializer.from(response.data);
  }
}
