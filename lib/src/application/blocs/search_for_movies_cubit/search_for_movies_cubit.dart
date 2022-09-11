import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/repositories.dart';
import '../../../domain/entities/entities.dart';

part 'search_for_movies_state.dart';

abstract class SearchForMoviesCubit extends Cubit<SearchForMoviesState> {
  SearchForMoviesCubit() : super(SearchForMoviesIdleState());

  Future<void> searchMoviesBySearchTerm(String term); 
  void cancelSearch();
}

class SearchForMoviesCubitImpl extends SearchForMoviesCubit {
  SearchForMoviesCubitImpl(this.searchRepository);

  final SearchRepository searchRepository;
  
  @override
  Future<void> searchMoviesBySearchTerm(String term) async {
    emit(LoadingSearchResult(searchTerm: term));
    try {
      var searchResult = await searchRepository.searchMoviesByTitle(term);
      if (state is SearchForMoviesIdleState) {
        return;
      }
      emit(LoadedSearchResult(searchResult: searchResult, searchTerm: term));
    } on Exception catch (e) {
      emit(SearchForMoviesErrorState(error: e));
    }
  }

  @override
  void cancelSearch() {
    emit(SearchForMoviesIdleState());
  }
}