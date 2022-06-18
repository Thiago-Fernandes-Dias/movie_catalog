part of 'home_bloc.dart';

abstract class HomeState {}

class LoadingMovieLists extends HomeState {}

class LoadingSearchResult extends HomeState {
  final String searchTerm;
  LoadingSearchResult({required this.searchTerm});
}

class FechedMovieLists extends HomeState {
  final MovieList topRated;
  final MovieList mostPopular;
  FechedMovieLists({required this.topRated, required this.mostPopular});
}

class FetchedSearchResult extends HomeState {
  final MovieList searchResult;
  final String searchTerm;
  FetchedSearchResult({required this.searchResult, required this.searchTerm});
}

class HomeErrorState extends HomeState {
  final Exception error;
  HomeErrorState(this.error);
}