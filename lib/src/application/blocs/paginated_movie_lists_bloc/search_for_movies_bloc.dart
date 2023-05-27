import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';
import 'paginated_movie_lists_bloc.dart';

abstract class SearchForMoviesBloc extends PaginatedMovieListsBloc {}

class SearchForMoviesBlocImpl extends SearchForMoviesBloc {
  SearchForMoviesBlocImpl(this._searchRepository);

  final SearchRepository _searchRepository;

  String? _searchTerm;

  @override
  Future<MovieList> fetchMovieListPage(int page) async {
    return await _searchRepository.searchMoviesByTitle(_searchTerm ?? '', page);
  }

  set searchTerm(String value) {
    if (value != _searchTerm) {
      add(ResetPaginationEvent());
    }
    _searchTerm = value;
    add(LoadNextMovieEvent());
  }
}
