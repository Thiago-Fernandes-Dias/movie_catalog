part of 'home_movie_list_cubit.dart';

abstract class HomeMovieListState extends Equatable {
  const HomeMovieListState();

  @override
  List<Object?> get props => [];
}

class LoadingMovieLists extends HomeMovieListState {}

class LoadedMovieList extends HomeMovieListState {
  final MovieList topRatedMovies;
  final MovieList mostPopularMovies;

  const LoadedMovieList({
    required this.topRatedMovies,
    required this.mostPopularMovies,
  });

  @override
  List<Object?> get props {
    return [...super.props, topRatedMovies, mostPopularMovies];
  } 
}

class HomeMovieListErrorState extends HomeMovieListState {
  final Exception error;
  const HomeMovieListErrorState(this.error);
}