part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class SearchMovies extends HomeEvent {
  final String searchTerm;
  const SearchMovies({required this.searchTerm});
}

class GetMovieLists extends HomeEvent {}