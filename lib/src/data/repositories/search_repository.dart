part of 'repositories.dart';

abstract class SearchRepository {
  Future<MovieList> searchMoviesByTitle(String movieTitle);
}

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this.tmdbClient);

  final TMDBRestApiClient tmdbClient;

  @override
  Future<MovieList> searchMoviesByTitle(String movieTitle) async {
    var response = await tmdbClient.get('search/movie?query=$movieTitle');
    return movieListSerializer.from(response);
  }
}
