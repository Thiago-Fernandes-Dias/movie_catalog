part of 'movie_details_cubit.dart';

abstract class MovieDetailsState {
  final MovieDetails? movieDetails;
  final Credits? movieCredits;
  final Exception? error;

  const MovieDetailsState({
    this.movieDetails,
    this.movieCredits,
    this.error,
  });
}

class LoadingMovieDetails extends MovieDetailsState {}

class MovieDetailsErrorState extends MovieDetailsState {
  const MovieDetailsErrorState({required super.error});
}

class LoadedMovieDetails extends MovieDetailsState {
  const LoadedMovieDetails({
    required super.movieCredits,
    required super.movieDetails,
  });
}