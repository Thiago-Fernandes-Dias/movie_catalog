import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_list/src/application/blocs/paginated_movie_lists_bloc/paginated_movie_lists_bloc.dart';
import 'package:movie_list/src/application/blocs/paginated_movie_lists_bloc/popular_movies_bloc.dart';
import 'package:movie_list/src/application/blocs/paginated_movie_lists_bloc/top_rated_movies_bloc.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';

import '../../../../fixtures/fixtures.dart';

void paginatedMovieListsTest(PaginatedMovieListsBloc Function(MoviesRepository) createBlocCallback) {
  group('TopRatedMoviesBloc', () {
    late final MoviesRepository moviesRepository;

    setUpAll(() {
      moviesRepository = MockMoviesRepository();
      when(() => moviesRepository.getTopRatedMovies(1)).thenAnswer((_) async => movieListPage1);
      when(() => moviesRepository.getTopRatedMovies(2)).thenAnswer((_) async => movieListPage2);
      when(() => moviesRepository.getPopularMovies(1)).thenAnswer((_) async => movieListPage1);
      when(() => moviesRepository.getPopularMovies(2)).thenAnswer((_) async => movieListPage2);
    });

    tearDownAll(() => reset(moviesRepository));

    PaginatedMovieListsBloc createCubit() => createBlocCallback(moviesRepository);

    blocTest(
      'Should load the first page when the loadNextPage is called at the first time',
      build: createCubit,
      act: (cubit) => cubit.add(LoadNextMovieEvent()),
      expect: () {
        return [
          LoadingInitialPage(),
          LoadedMoviesState(
            movies: movieListPage1.results,
            currentPage: movieListPage1.page,
            totalPages: movieListPage1.totalPages,
          ),
        ];
      },
    );

    blocTest(
      'Should load the first two pages when the loadNextPage is called at the second time',
      build: createCubit,
      act: (cubit) async {
        return cubit
          ..add(LoadNextMovieEvent())
          ..add(LoadNextMovieEvent());
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
        ];
      },
    );
  });
}

void main() {
  paginatedMovieListsTest((moviesRepository) => TopRatedMoviesBloc(moviesRepository));
  paginatedMovieListsTest((moviesRepository) => PopularMoviesBloc(moviesRepository));
}
