import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_list/src/application/blocs/movie_details/movie_details_cubit.dart';
import 'package:movie_list/src/data/repositories/exceptions/exceptions.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/data/serializers/serializer.dart';
import 'package:movie_list/src/domain/entities/entities.dart';

import '../../../../fixtures/fixtures.dart';

void main() {
  group('MovieDetailsCubitImpl', () {
    late final MoviesRepository moviesRepository;
    late final MovieDetails movieDetailsSample;
    late final Credits creditsSample;

    const _movieId = '1';

    setUpAll(() {
      moviesRepository = MockMoviesRepository();
      movieDetailsSample = movieDetailsSerializer.from(movieDetailsSampleMap);
      creditsSample = creditsSerializer.from(creditsSampleMap);
    });

    setUp(() => reset(moviesRepository));

    MovieDetailsCubitImpl buildMovieDetailsCubit() => MovieDetailsCubitImpl(moviesRepository);

    void stubMovieDetailsFetch() {
      when(() => moviesRepository.getMovieDetails(_movieId)).thenAnswer((_) async => movieDetailsSample);
    }

    void stubMovieCreditsFetch() {
      when(() => moviesRepository.getMovieCredits(_movieId)).thenAnswer((_) async => creditsSample);
    }

    group('fetchMovieDetails', () {
      blocTest(
        'Emits a loading a loaded state when the data is fetched',
        build: buildMovieDetailsCubit,
        setUp: () {
          stubMovieDetailsFetch();
          stubMovieCreditsFetch();
        },
        act: (bloc) => bloc.fetchMovieDetails(_movieId),
        expect: () {
          return [
            LoadingMovieDetails(),
            LoadedMovieDetails(movieCredits: creditsSample, movieDetails: movieDetailsSample),
          ];
        },
      );

      blocTest(
        'Emits an error state when the movie details is not fetched',
        build: buildMovieDetailsCubit,
        setUp: () {
          when(() => moviesRepository.getMovieDetails(_movieId)).thenThrow(MovieNotFoundException());
          stubMovieCreditsFetch();
        },
        act: (bloc) => bloc.fetchMovieDetails(_movieId),
        expect: () {
          return [
            LoadingMovieDetails(),
            MovieDetailsErrorState(exception: MovieNotFoundException()),
          ];
        },
      );

      blocTest(
        'Emits an error state when the movie credits is not fetched',
        build: buildMovieDetailsCubit,
        setUp: () {
          stubMovieDetailsFetch();
          when(() => moviesRepository.getMovieCredits(_movieId)).thenThrow(MovieNotFoundException());
        },
        act: (bloc) => bloc.fetchMovieDetails(_movieId),
        expect: () {
          return [
            LoadingMovieDetails(),
            MovieDetailsErrorState(exception: MovieNotFoundException()),
          ];
        },
      );
    });
  });
}
