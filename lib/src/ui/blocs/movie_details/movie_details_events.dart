part of 'movie_details_bloc.dart';

abstract class MovieDetailsEvents {
  const MovieDetailsEvents();
}

class GetMovieDetails extends MovieDetailsEvents {
  final String movieId;
  const GetMovieDetails(this.movieId);
}