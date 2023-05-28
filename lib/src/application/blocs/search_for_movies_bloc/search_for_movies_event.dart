part of 'search_for_movies_bloc.dart';

abstract class SearchForMoviesEvent extends Equatable {
  const SearchForMoviesEvent();

  @override
  List<Object> get props => [];
}

class SearchForMoviesByName extends SearchForMoviesEvent {
  final String searchTerm;

  const SearchForMoviesByName({required this.searchTerm});

  @override
  List<Object> get props => [...super.props, searchTerm];
}

class ChangeSearchResultsPage extends SearchForMoviesEvent {
  final int page;

  const ChangeSearchResultsPage({required this.page});

  @override
  List<Object> get props => [...super.props, page];
}

class CancelSearch extends SearchForMoviesEvent {}
