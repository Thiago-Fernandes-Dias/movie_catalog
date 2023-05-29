import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:movie_list/src/data/gateways/gateways.dart';
import 'package:movie_list/src/data/gateways/tmdb_rest_api_client/enums/enums.dart';
import 'package:movie_list/src/data/repositories/exceptions/exceptions.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/data/serializers/serializer.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  group('MoviesRepositoryImpl', () {
    late final TMDBRestApiClient tmdbRestApiClient;
    late final MoviesRepository moviesRepository;

    setUpAll(() {
      tmdbRestApiClient = MockTMDBRestApiClient();
      moviesRepository = MoviesRepositoryImpl(tmdbRestApiClient);
    });

    setUp(() => reset(tmdbRestApiClient));

    group('getMovieDetails', () {
      test('returns a MovieDetails if the movie exists', () async {
        const movieId = '1';
        when(() => tmdbRestApiClient.get('movie/$movieId')).thenAnswer((_) async => movieDetailsSampleMap);
        final movieDetailsSample = movieDetailsSerializer.from(movieDetailsSampleMap);
        final movieDetails = await moviesRepository.getMovieDetails(movieId);
        expect(movieDetails, movieDetailsSample);
      });

      test("Throws a MovieNotFoundException if the movie doesn't exists in the database", () async {
        const movieId = '2';
        final exception = TMDBRequestError(
          'Movie not found',
          code: TMDBErrorCode.resourceNotFound,
        );
        when(() => tmdbRestApiClient.get('movie/$movieId')).thenThrow(exception);
        final movieDetailsFuture = moviesRepository.getMovieDetails(movieId);
        await expectLater(movieDetailsFuture, throwsA(isA<MovieNotFoundException>()));
      });
    });

    group('getMovieCredits', () {
      test('returns a Credits if the movie exists', () async {
        const movieId = '1';
        when(() => tmdbRestApiClient.get('movie/$movieId/credits')).thenAnswer((_) async => creditsSampleMap);
        final creditsSample = creditsSerializer.from(creditsSampleMap);
        final credits = await moviesRepository.getMovieCredits(movieId);
        expect(credits, creditsSample);
      });

      test("Throws a MovieNotFoundException if the movie doesn't exists in the database", () async {
        const movieId = '2';
        final exception = TMDBRequestError(
          'Movie not found',
          code: TMDBErrorCode.resourceNotFound,
        );
        when(() => tmdbRestApiClient.get('movie/$movieId/credits')).thenThrow(exception);
        final creditsFuture = moviesRepository.getMovieCredits(movieId);
        await expectLater(creditsFuture, throwsA(isA<MovieNotFoundException>()));
      });
    });

    group('getTopRatedMovies and getPopularMovies', () {
      test('Both methods should return a MovieList instance if the request is successful', () async {
        const page = 1;
        when(() => tmdbRestApiClient.get(any())).thenAnswer((_) async => movieListSampleMap);
        final movieListSample = movieListSerializer.from(movieListSampleMap);
        final topRatedMovies = await moviesRepository.getTopRatedMovies(page);
        final popularMovies = await moviesRepository.getPopularMovies(page);
        expect(topRatedMovies, movieListSample);
        expect(popularMovies, movieListSample);
      });
    });
  });
}
