import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/domain/entities/entities.dart';

part 'movie_details_events.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvents, MovieDetailsState> {
  late final MoviesRepository _moviesRepository;

  MovieDetailsBloc({required MoviesRepository moviesRepository}) : super(LoadingMovieDetails()) {
    _moviesRepository = moviesRepository;

    on<GetMovieDetails>(_fetchMovieDetails);
  }

  Future<void> _fetchMovieDetails(GetMovieDetails event, Emitter emitter) async {
    emitter(LoadingMovieDetails());

    try {
      var movieDetails = await _moviesRepository.getMovieDetails(event.movieId);
      var movieCredits = await _moviesRepository.getMovieCredits(event.movieId);
      emitter(LoadedMovieDetails(movieCredits: movieCredits, movieDetails: movieDetails));
    } on Exception catch (e) {
      emitter(MovieDetailsErrorState(error: e));
    }
  }
} 