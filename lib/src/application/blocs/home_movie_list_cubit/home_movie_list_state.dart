part of 'home_movie_list_cubit.dart';

abstract class HomeMovieListState extends Equatable {
  const HomeMovieListState({
    this.topRatedMovies,
    this.mostPopularMovies,
    this.error,
  });

  final List<MovieInfo>? topRatedMovies;
  final List<MovieInfo>? mostPopularMovies;
  final Exception? error;

  @override
  List<Object?> get props => [topRatedMovies, mostPopularMovies, error];
}

class LoadingMovieLists extends HomeMovieListState {}

class LoadedMovieList extends HomeMovieListState {
  const LoadedMovieList({
    required super.topRatedMovies,
    required super.mostPopularMovies,
  });
}

class HomeMovieListErrorState extends HomeMovieListState {
  const HomeMovieListErrorState({required super.error});
}