import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final MoviesRepository _moviesRepository;
  late final SearchRepository _searchRepository;

  HomeBloc({
    required MoviesRepository moviesRepository, 
    required SearchRepository searchRepository,
  }) : super(LoadingMovieLists()) {

    _moviesRepository = moviesRepository;
    _searchRepository = searchRepository;

    on<SearchMovies>(_searchMoviesBySearchTerm);
    on<GetMovieLists>(_getHomeMovieLists);
  }
  
  Future<void> _getHomeMovieLists(_, Emitter emitter) async {
    try {
      var topRatedMovies = await _moviesRepository.getTopRatedMovies(1);
      var mostPopularMovies = await _moviesRepository.getPopularMovies(1);
      emitter(FechedMovieLists(topRated: topRatedMovies, mostPopular: mostPopularMovies));
    } on Exception catch (e) {
      emitter(HomeErrorState(e));
    }
  }

  Future<void> _searchMoviesBySearchTerm(SearchMovies event, Emitter emitter) async {
    try {
      var searchResult = await _searchRepository.seachMoviesByTitle(event.searchTerm);
      emitter(FetchedSearchResult(searchResult: searchResult, searchTerm: event.searchTerm));
    } on Exception catch (e) {
      emitter(HomeErrorState(e));
    }
  }
}