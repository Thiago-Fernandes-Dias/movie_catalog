import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/faults/exceptions/exceptions.dart';
import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';

part 'home_movie_list_state.dart';

abstract class HomeMovieListCubit extends Cubit<HomeMovieListState> {
  HomeMovieListCubit() : super(LoadingMovieLists());

  Future<void> getHomeMovieLists();
  Future<void> searchForMovies(String searchTerm);
}

class HomeMovieListCubitImpl extends HomeMovieListCubit {
  HomeMovieListCubitImpl(this._moviesRepository, this._searchRepository);

  final MoviesRepository _moviesRepository;
  final SearchRepository _searchRepository;

  @override
  Future<void> getHomeMovieLists() async {
    try {
      final topRatedMovies = await _moviesRepository.getTopRatedMovies(1);
      final mostPopularMovies = await _moviesRepository.getPopularMovies(1);
      final newState = LoadedMovieList(
        topRatedMovies: topRatedMovies.results,
        mostPopularMovies: mostPopularMovies.results,
      );
      emit(newState);
    } on BaseException catch (e) {
      emit(HomeMovieListErrorState(exception: e));
    }
  }

  @override
  Future<void> searchForMovies(String searchTerm) async {
    emit(LoadingSearchResults(searchTerm: searchTerm));
    try {
      final searchResults = await _searchRepository.searchMoviesByTitle(searchTerm, 1);
      emit(LoadedSearchResults(searchResults: searchResults.results, searchTerm: searchTerm));
    } on BaseException catch (e) {
      emit(MovieSearchError(exception: e, searchTerm: searchTerm));
    }
  }
}
