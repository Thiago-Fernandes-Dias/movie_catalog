import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_list/src/application/blocs/search_for_movies_bloc/search_for_movies_bloc.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  group('SearchForMoviesBlocImpl', () {
    late final SearchRepository searchRepository;

    void mockFirstTwoPageResultPages() {
      when(() => searchRepository.searchMoviesByTitle(any(), 1)).thenAnswer((_) async => movieListPage1);
      when(() => searchRepository.searchMoviesByTitle(any(), 2)).thenAnswer((_) async => movieListPage2);
    }

    setUpAll(() {
      searchRepository = MockSearchRepository();
      mockFirstTwoPageResultPages();
    });

    tearDownAll(() => reset(searchRepository));

    SearchForMoviesBloc createBloc() => SearchForMoviesBlocImpl(searchRepository);

    const defaultQuery = 'defaultQuery';
    const anotherQuery = 'anotherQuery';

    blocTest(
      'emits [LoadingSearchResults, LoadedSearchResults] when the SearchForMoviesEvent is added',
      build: createBloc,
      act: (bloc) => bloc.add(const SearchForMoviesByName(searchTerm: defaultQuery)),
      expect: () => [
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage1, searchTermUsed: defaultQuery),
      ],
    );

    blocTest(
      'Loads the second page if a second page is requested',
      build: createBloc,
      act: (bloc) {
        return bloc
          ..add(const SearchForMoviesByName(searchTerm: defaultQuery))
          ..add(const ChangeSearchResultsPage(page: 2));
      },
      expect: () => [
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage1, searchTermUsed: defaultQuery),
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage2, searchTermUsed: defaultQuery),
      ],
    );

    blocTest(
      'Do anything if the the user tries do load another page before load the first page with by adding the '
      'SearchForMoviesEvent',
      build: createBloc,
      act: (bloc) => bloc.add(const ChangeSearchResultsPage(page: 2)),
      expect: () => [],
    );

    blocTest(
      'Stop loading more pages when the last page if reached',
      build: createBloc,
      act: (bloc) {
        return bloc
          ..add(const SearchForMoviesByName(searchTerm: defaultQuery))
          ..add(const ChangeSearchResultsPage(page: 2))
          ..add(const ChangeSearchResultsPage(page: 3));
      },
      expect: () => [
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage1, searchTermUsed: defaultQuery),
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage2, searchTermUsed: defaultQuery),
      ],
    );

    blocTest(
      'Do nothing if the user try to search with the same term',
      build: createBloc,
      act: (bloc) {
        return bloc
          ..add(const SearchForMoviesByName(searchTerm: defaultQuery))
          ..add(const ChangeSearchResultsPage(page: 2))
          ..add(const SearchForMoviesByName(searchTerm: defaultQuery));
      },
      expect: () => [
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage1, searchTermUsed: defaultQuery),
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage2, searchTermUsed: defaultQuery),
      ],
    );

    blocTest(
      'Reset the search results if the search term changes',
      build: createBloc,
      act: (bloc) {
        return bloc
          ..add(const SearchForMoviesByName(searchTerm: defaultQuery))
          ..add(const ChangeSearchResultsPage(page: 2))
          ..add(const SearchForMoviesByName(searchTerm: anotherQuery));
      },
      expect: () => [
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage1, searchTermUsed: defaultQuery),
        const LoadingSearchResults(searchTerm: defaultQuery),
        const LoadedSearchResults(movieList: movieListPage2, searchTermUsed: defaultQuery),
        const LoadingSearchResults(searchTerm: anotherQuery),
        const LoadedSearchResults(movieList: movieListPage1, searchTermUsed: anotherQuery),
      ],
    );
  });
}
