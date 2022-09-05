part of 'search_for_movies_cubit.dart';

abstract class SearchForMoviesState extends Equatable {
  const SearchForMoviesState({this.searchResult, this.searchTerm, this.error});

  final String? searchTerm;
  final MovieList? searchResult;
  final Exception? error;

  @override
  List<Object?> get props {
    return [
      searchTerm,
      searchResult,
      error,
    ];
  }

  bool get searching {
    final loadingSearchResult = this is LoadingSearchResult;
    final loadedSearchResult = this is LoadedSearchResult;
    final getter = loadedSearchResult || loadingSearchResult;
    return getter;
  }
}

class SearchForMoviesIdleState extends SearchForMoviesState {}

class LoadingSearchResult extends SearchForMoviesState {
  const LoadingSearchResult({required super.searchTerm});
}

class LoadedSearchResult extends SearchForMoviesState {
  const LoadedSearchResult({
    required super.searchResult,
    required super.searchTerm,
  });
}

class SearchForMoviesErrorState extends SearchForMoviesState {
  const SearchForMoviesErrorState({required super.error});
}