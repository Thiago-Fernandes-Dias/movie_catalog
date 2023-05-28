import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/faults/exceptions/exceptions.dart';
import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';

part 'search_for_movies_event.dart';
part 'search_for_movies_state.dart';

abstract class SearchForMoviesBloc extends Bloc<SearchForMoviesEvent, SearchForMoviesState> {
  SearchForMoviesBloc() : super(SearchForMoviesInitial()) {
    on<SearchForMoviesByName>(searchForMoviesByName, transformer: sequential());
    on<ChangeSearchResultsPage>(changeSearchResultsPage, transformer: sequential());
    on<CancelSearch>(cancelSearchHandler, transformer: sequential());
  }

  @protected
  Future<void> searchForMoviesByName(SearchForMoviesByName event, Emitter<SearchForMoviesState> emitter);

  @protected
  Future<void> changeSearchResultsPage(ChangeSearchResultsPage event, Emitter<SearchForMoviesState> emitter);

  @protected
  Future<void> cancelSearchHandler(CancelSearch event, Emitter<SearchForMoviesState> emitter);
}

class SearchForMoviesBlocImpl extends SearchForMoviesBloc {
  SearchForMoviesBlocImpl(this._searchRepository);

  final SearchRepository _searchRepository;

  @override
  Future<void> cancelSearchHandler(CancelSearch event, Emitter<SearchForMoviesState> emitter) async {
    emitter(SearchForMoviesInitial());
  }

  @override
  Future<void> changeSearchResultsPage(ChangeSearchResultsPage event, Emitter<SearchForMoviesState> emitter) async {
    final state = this.state;
    if (state is LoadedSearchResults) {
      final pageOutOfBoundaries = event.page < 1 || event.page > state.movieList.totalPages;
      if (pageOutOfBoundaries) return;
      emitter(LoadingSearchResults(searchTerm: state.searchTermUsed));
      await _updateSearchResults(state.searchTermUsed, event.page, emitter);
    }
  }

  @override
  Future<void> searchForMoviesByName(SearchForMoviesByName event, Emitter<SearchForMoviesState> emitter) async {
    final state = this.state;
    if (state is LoadedSearchResults && state.searchTermUsed == event.searchTerm) return;
    emitter(LoadingSearchResults(searchTerm: event.searchTerm));
    await _updateSearchResults(event.searchTerm, 1, emitter);
  }

  Future<void> _updateSearchResults(String searchTerm, int page, Emitter<SearchForMoviesState> emitter) async {
    try {
      final moviesList = await _searchRepository.searchMoviesByTitle(searchTerm, page);
      final loadedResultsState = LoadedSearchResults(
        movieList: moviesList,
        searchTermUsed: searchTerm,
      );
      emitter(loadedResultsState);
    } on BaseException catch (exception) {
      emitter(LoadingSearchResultsError(exception));
    }
  }
}
