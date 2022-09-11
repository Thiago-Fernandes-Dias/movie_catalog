import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';

part 'home_movie_list_state.dart';

abstract class HomeMovieListCubit extends Cubit<HomeMovieListState> {
  HomeMovieListCubit() : super(LoadingMovieLists());

  Future<void> getHomeMovieLists();
}

class HomeMovieListCubitImpl extends HomeMovieListCubit {
  HomeMovieListCubitImpl(this.moviesRepository);
  
  final MoviesRepository moviesRepository;

  @override
  Future<void> getHomeMovieLists() async {
    try {
      var topRatedMovies = await moviesRepository.getTopRatedMovies(1);
      var mostPopularMovies = await moviesRepository.getPopularMovies(1);
      emit(LoadedMovieList(topRatedMovies: topRatedMovies.results, 
                           mostPopularMovies: mostPopularMovies.results));
    } on Exception catch (e) {
      emit(HomeMovieListErrorState(error: e));
    }
  }
}