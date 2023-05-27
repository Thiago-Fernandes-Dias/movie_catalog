import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';
import 'paginated_movie_lists_bloc.dart';

class TopRatedMoviesBloc extends PaginatedMovieListsBloc {
  TopRatedMoviesBloc(this._moviesRepository);

  late final MoviesRepository _moviesRepository;

  @override
  Future<MovieList> fetchMovieListPage(int page) async {
    return await _moviesRepository.getTopRatedMovies(page);
  }
}
