part of 'home_bloc.dart';

abstract class HomeState {
  final String? searchTerm;
  final MovieList? topRated;
  final MovieList? mostPopular;
  final MovieList? searchResult;
  final Exception? error;

  const HomeState({
    this.searchTerm,
    this.topRated,
    this.mostPopular,
    this.searchResult,
    this.error,
  });
}

class LoadingMovieLists extends HomeState {}

class LoadingSearchResult extends HomeState {
  const LoadingSearchResult({required super.searchTerm});
}

class FechedMovieLists extends HomeState {
  const FechedMovieLists({
    required super.topRated,
    required super.mostPopular,
  });
}

class FetchedSearchResult extends HomeState {
  const FetchedSearchResult({
    required super.searchResult,
    required super.searchTerm,
    super.mostPopular,
    super.topRated,
  });
}

class HomeErrorState extends HomeState {
  const HomeErrorState({required super.error});
}