part of 'search_for_movies_cubit.dart';

abstract class SearchForMoviesState extends Equatable {
  const SearchForMoviesState();

  @override
  List<Object?> get props => []; 
}

class SearchForMoviesIdleState extends SearchForMoviesState {}

class LoadingSearchResult extends SearchForMoviesState {
  const LoadingSearchResult({required this.searchTerm});

  final String searchTerm;

  @override
  List<Object?> get props => [...super.props, searchTerm];
}

class LoadedSearchResult extends SearchForMoviesState {
  const LoadedSearchResult({
    required this.searchResult,
    required this.searchTerm,
  });

  final MovieList searchResult;
  final String searchTerm;

  @override
  List<Object?> get props => [...super.props, searchResult, searchTerm];
}

class SearchForMoviesErrorState extends SearchForMoviesState {
  const SearchForMoviesErrorState(this.error);

  final Exception error;
}