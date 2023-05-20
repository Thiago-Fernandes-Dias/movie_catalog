part of 'home_movie_list_cubit.dart';

sealed class HomeMovieListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingMovieLists extends HomeMovieListState {}

class LoadedMovieList extends HomeMovieListState {
  LoadedMovieList({
    required this.topRatedMovies,
    required this.mostPopularMovies,
  });

  final List<MovieInfo> topRatedMovies;
  final List<MovieInfo> mostPopularMovies;

  @override
  List<Object?> get props => [...super.props, topRatedMovies, mostPopularMovies];
}

class HomeMovieListErrorState extends HomeMovieListState {
  HomeMovieListErrorState({required this.exception});

  final BaseException exception;

  @override
  List<Object?> get props => [...super.props, exception];
}

class LoadingSearchResults extends HomeMovieListState {
  LoadingSearchResults({required this.searchTerm});

  final String searchTerm;

  @override
  List<Object?> get props => [...super.props, searchTerm];
}

class LoadedSearchResults extends HomeMovieListState {
  LoadedSearchResults({required this.searchResults, required this.searchTerm}); 

  final List<MovieInfo> searchResults;
  final String searchTerm;

  @override
  List<Object?> get props => [...super.props, searchResults, searchTerm];
}

class MovieSearchError extends HomeMovieListState {
  MovieSearchError({required this.exception, required this.searchTerm});

  final String searchTerm;
  final BaseException exception;

  @override
  List<Object?> get props => [...super.props, searchTerm, exception];
}