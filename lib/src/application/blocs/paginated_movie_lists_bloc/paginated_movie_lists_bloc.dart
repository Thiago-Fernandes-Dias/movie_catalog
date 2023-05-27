import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/faults/exceptions/exceptions.dart';
import '../../../domain/entities/entities.dart';

part 'paginated_movie_lists_events.dart';
part 'paginated_movie_lists_state.dart';

abstract class PaginatedMovieListsBloc extends Bloc<PaginatedMovieListsEvents, PaginatedMovieListsState> {
  PaginatedMovieListsBloc() : super(PaginatedMovieListsInitial()) {
    on<LoadNextMovieEvent>(loadNextPageHandler, transformer: sequential());
  }

  Future<MovieList> fetchMovieListPage(int page);

  Future<void> loadNextPageHandler(LoadNextMovieEvent event, Emitter<PaginatedMovieListsState> emitter) async {
    final state = this.state;
    if (state is PaginatedMovieListsInitial) {
      emitter(LoadingInitialPage());
      await _loadFirstPage(emitter);
    } else if (state is LoadedMoviesState) {
      final newState = LoadingNextPage(
        movies: state.movies,
        currentPage: state.currentPage,
        totalPages: state.totalPages,
      );
      emitter(newState);
      await _updateWithNextPage(newState, emitter);
    }
  }

  Future<void> _updateWithNextPage(LoadingNextPage loadingPageState, Emitter<PaginatedMovieListsState> emitter) async {
    try {
      final nextPage = loadingPageState.currentPage + 1;
      if (nextPage > loadingPageState.totalPages) return;
      final movieList = await fetchMovieListPage(nextPage);
      final newState = LoadedMoviesState(
        movies: [...loadingPageState.movies, ...movieList.results],
        currentPage: nextPage,
        totalPages: movieList.totalPages,
      );
      emitter(newState);
    } on BaseException catch (exception) {
      final errorState = LoadingNextPageError(
        exception,
        currentPage: loadingPageState.currentPage,
        totalPages: loadingPageState.totalPages,
        movies: loadingPageState.movies,
      );
      emitter(errorState);
    }
  }

  Future<void> _loadFirstPage(Emitter<PaginatedMovieListsState> emitter) async {
    try {
      final movieList = await fetchMovieListPage(1);
      final newState = LoadedMoviesState(
        movies: movieList.results,
        currentPage: movieList.page,
        totalPages: movieList.totalPages,
      );
      emitter(newState);
    } on BaseException catch (exception) {
      emitter(LoadingInitialPageError(exception));
    }
  }
}
