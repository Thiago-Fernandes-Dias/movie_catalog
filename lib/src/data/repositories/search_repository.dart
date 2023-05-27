part of 'repositories.dart';

abstract class SearchRepository {
  Future<MovieList> searchMoviesByTitle(String movieTitle, int page);
}

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this.tmdbClient);

  final TMDBRestApiClient tmdbClient;

  @override
  Future<MovieList> searchMoviesByTitle(String movieTitle, int page) async {
    var response = await tmdbClient.get('search/movie?query=$movieTitle&page=$page');
    return movieListSerializer.from(response);
  }
}
