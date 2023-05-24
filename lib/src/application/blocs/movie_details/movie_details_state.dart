part of 'movie_details_cubit.dart';

abstract class MovieDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingMovieDetails extends MovieDetailsState {}

class MovieDetailsErrorState extends MovieDetailsState {
  MovieDetailsErrorState({required this.exception});

  final BaseException exception;

  @override
  List<Object?> get props => [...super.props, exception];
}

class LoadedMovieDetails extends MovieDetailsState {
  LoadedMovieDetails({
    required this.movieCredits,
    required this.movieDetails,
  });

  final MovieDetails movieDetails;
  final Credits movieCredits;

  @override
  List<Object?> get props => [...super.props, movieCredits, movieDetails];
}
