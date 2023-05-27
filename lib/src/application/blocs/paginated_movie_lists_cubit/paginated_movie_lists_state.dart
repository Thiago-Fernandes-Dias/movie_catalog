part of 'paginated_movie_lists_bloc.dart';

sealed class PaginatedMovieListsState extends Equatable {
  const PaginatedMovieListsState();

  @override
  List<Object> get props => [];
}

class PaginatedMovieListsInitial extends PaginatedMovieListsState {}

class LoadingInitialPage extends PaginatedMovieListsState {}

class LoadedMoviesState extends PaginatedMovieListsState {
  final List<MovieInfo> movies;
  final int currentPage;
  final int totalPages;

  const LoadedMoviesState({
    required this.movies,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object> get props => [...super.props, movies, currentPage, totalPages];
}

class LoadingInitialPageError extends PaginatedMovieListsState {
  const LoadingInitialPageError(this.exception);

  final BaseException exception;

  @override
  List<Object> get props => [...super.props, exception];
}

class LoadingNextPage extends LoadedMoviesState {
  const LoadingNextPage({
    required super.movies,
    required super.currentPage,
    required super.totalPages,
  });
}

class LoadingNextPageError extends LoadedMoviesState {
  const LoadingNextPageError(
    this.exception, {
    required super.movies,
    required super.currentPage,
    required super.totalPages,
  });

  final BaseException exception;

  @override
  List<Object> get props => [...super.props, exception];
}
