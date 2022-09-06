import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/domain/entities/entities.dart';

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
    try {
      var movieDetails = await moviesRepository.getMovieDetails(movieId);
      var movieCredits = await moviesRepository.getMovieCredits(movieId);
      emit(LoadedMovieDetails(movieCredits: movieCredits, movieDetails: movieDetails));
    } on Exception catch (e) {
      emit(MovieDetailsErrorState(error: e));
    }
  }
}