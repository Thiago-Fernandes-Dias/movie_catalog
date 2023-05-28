part of 'search_for_movies_bloc.dart';

sealed class SearchForMoviesState extends Equatable {
  const SearchForMoviesState();

  @override
  List<Object> get props => [];
}

class SearchForMoviesInitial extends SearchForMoviesState {}

class LoadingSearchResults extends SearchForMoviesState {
  final String searchTerm;

  const LoadingSearchResults({required this.searchTerm});

  @override
  List<Object> get props => [...super.props, searchTerm];
}

class LoadedSearchResults extends SearchForMoviesState {
  final MovieList movieList;
  final String searchTermUsed;

  const LoadedSearchResults({
    required this.movieList,
    required this.searchTermUsed,
  });

  @override
  List<Object> get props => [...super.props, movieList, searchTermUsed];
}

class LoadingSearchResultsError extends SearchForMoviesState {
  const LoadingSearchResultsError(this.exception);

  final BaseException exception;

  @override
  List<Object> get props => [...super.props, exception];
}
