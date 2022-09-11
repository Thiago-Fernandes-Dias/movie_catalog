part of 'repositories.dart';

abstract class SearchRepository {
  Future<MovieList> searchMoviesByTitle(String movieTitle);
}

class SearchRepositoryImpl implements SearchRepository {
  final _httpClient = HttpClient();

  @override
  Future<MovieList> searchMoviesByTitle(String movieTitle) async {
    var response = await _httpClient.get('${env.tmdbApiUrl}/search/movie?query=$movieTitle');
    if (response.statusCode != 200) throw TMDBError.fromJsonResponse(response.data);
    return movieListSerializer.from(response.data);
  }
}