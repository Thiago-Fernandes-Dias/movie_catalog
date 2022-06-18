part of 'repositories.dart';

abstract class SearchRepository {
  Future<MovieList> seachMoviesByTitle(String movieTitle);
}

class SearchRepositoryImpl implements SearchRepository {
  final _httpClient = HttpClient();

  @override
  Future<MovieList> seachMoviesByTitle(String movieTitle) async {
    var response = await _httpClient.get("${env.tmdbApiUrl}/search/movie?query=$movieTitle");
    if (response.statusCode != 200) throw TMDBError.fromJsonResponse(response.data);
    return movieListSerializer.from(response.data);
  }
}