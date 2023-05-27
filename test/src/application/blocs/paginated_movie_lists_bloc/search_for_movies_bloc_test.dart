import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_list/src/application/blocs/paginated_movie_lists_bloc/paginated_movie_lists_bloc.dart';
import 'package:movie_list/src/application/blocs/paginated_movie_lists_bloc/search_for_movies_bloc.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  group('SearchForMoviesBlocImpl', () {
    late final SearchRepository searchRepository;

    setUpAll(() {
      searchRepository = MockSearchRepository();
      when(() => searchRepository.searchMoviesByTitle(any(), 1)).thenAnswer((_) async => movieListPage1);
      when(() => searchRepository.searchMoviesByTitle(any(), 2)).thenAnswer((_) async => movieListPage2);
    });

    tearDownAll(() => reset(searchRepository));

    SearchForMoviesBlocImpl createBloc() => SearchForMoviesBlocImpl(searchRepository);

    blocTest(
      'Emits [LoadingInitialPage, LoadedMoviesState] when the searchTerm is set',
      build: createBloc,
      act: (bloc) => bloc.searchTerm = 'term',
      expect: () => [
        LoadingInitialPage(),
        LoadedMoviesState(
          movies: movieListPage1.results,
          currentPage: movieListPage1.page,
          totalPages: movieListPage1.totalPages,
        ),
      ],
    );

    blocTest(
      'Emits the LoadingNextPage when the LoadNextPageEvent is added and then emits the LoadedMoviesState with the '
      'movies of the first two pages',
      build: createBloc,
      act: (bloc) {
        bloc.searchTerm = 'term';
        bloc.add(LoadNextMovieEvent());
      },
      expect: () => [
        LoadingInitialPage(),
        LoadedMoviesState(
          movies: movieListPage1.results,
          currentPage: movieListPage1.page,
          totalPages: movieListPage1.totalPages,
        ),
        LoadingNextPage(
          movies: movieListPage1.results,
          currentPage: movieListPage1.page,
          totalPages: movieListPage1.totalPages,
        ),
        LoadedMoviesState(
          movies: [...movieListPage1.results, ...movieListPage2.results],
          currentPage: movieListPage2.page,
          totalPages: movieListPage1.totalPages,
        )
      ],
    );

    blocTest(
      'Reset the movie pages loaded in the movies field if the search term changes',
      build: createBloc,
      act: (bloc) {
        bloc.searchTerm = 'term1';
        bloc.add(LoadNextMovieEvent());
        bloc.searchTerm = 'term2';
      },
      expect: () {
        return [
          LoadingInitialPage(),
          LoadedMoviesState(
            movies: movieListPage1.results,
            currentPage: movieListPage1.page,
            totalPages: movieListPage1.totalPages,
          ),
          LoadingNextPage(
            movies: movieListPage1.results,
            currentPage: movieListPage1.page,
            totalPages: movieListPage1.totalPages,
          ),
          LoadedMoviesState(
            movies: [...movieListPage1.results, ...movieListPage2.results],
            currentPage: movieListPage2.page,
            totalPages: movieListPage1.totalPages,
          ),
          PaginatedMovieListsInitial(),
          LoadingInitialPage(),
          LoadedMoviesState(
            movies: movieListPage1.results,
            currentPage: movieListPage1.page,
            totalPages: movieListPage1.totalPages,
          ),
        ];
      },
    );
  });
}
