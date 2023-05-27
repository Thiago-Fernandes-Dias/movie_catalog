import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';
import 'paginated_movie_lists_bloc.dart';

class PopularMoviesBloc extends PaginatedMovieListsBloc {
  PopularMoviesBloc(this._moviesRepository);

  final MoviesRepository _moviesRepository;

  @override
  Future<MovieList> fetchMovieListPage(int page) async {
    return await _moviesRepository.getPopularMovies(page);
  }
}
