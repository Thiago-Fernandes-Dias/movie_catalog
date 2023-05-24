import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/faults/exceptions/exceptions.dart';
import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';

part 'movie_details_state.dart';

abstract class MovieDetailsCubit extends Cubit<MovieDetailsState> {
  MovieDetailsCubit() : super(LoadingMovieDetails());

  Future<void> fetchMovieDetails(String movieId);
}

class MovieDetailsCubitImpl extends MovieDetailsCubit {
  MovieDetailsCubitImpl(this.moviesRepository);

  final MoviesRepository moviesRepository;

  @override
  Future<void> fetchMovieDetails(String movieId) async {
    emit(LoadingMovieDetails());
    try {
      final movieDetailsFuture = moviesRepository.getMovieDetails(movieId);
      final movieCreditsFuture = moviesRepository.getMovieCredits(movieId);
      final futureResults = await Future.wait([movieDetailsFuture, movieCreditsFuture]);
      final [movieDetails, movieCredits] = futureResults;
      final loadedMovieDetails = LoadedMovieDetails(
        movieCredits: movieCredits as Credits,
        movieDetails: movieDetails as MovieDetails,
      );
      emit(loadedMovieDetails);
    } on BaseException catch (e) {
      emit(MovieDetailsErrorState(exception: e));
    }
  }
}
