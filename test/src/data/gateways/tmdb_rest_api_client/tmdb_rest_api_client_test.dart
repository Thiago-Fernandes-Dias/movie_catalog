import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_list/src/core/env.dart';
import 'package:movie_list/src/core/faults/exceptions/exceptions.dart';
import 'package:movie_list/src/data/gateways/gateways.dart';
import 'package:movie_list/src/data/gateways/tmdb_rest_api_client/enums/enums.dart';

class ClientMock extends Mock implements Client {}

class InternetConnectionCheckerPlusMock extends Mock implements InternetConnectionCheckerPlus {}

void main() {
  group('TMDBRestApiClient', () {
    late final TMDBRestApiClient tmdbRestApiClient;
    late final Client client;
    late final InternetConnectionCheckerPlus internetConnectionCheckerPlus;
    late final TMDBUrlBuilder tmdbUrlBuilder;

    setUpAll(() async {
      client = ClientMock();
      internetConnectionCheckerPlus = InternetConnectionCheckerPlusMock();
      tmdbUrlBuilder = TMDBUrlBuilder();
      tmdbRestApiClient = TMDBRestApiClientImpl(
        client: client,
        internetConnectionChecker: internetConnectionCheckerPlus,
        tmdbUrlBuilder: tmdbUrlBuilder,
      );
      registerFallbackValue(Uri.dataFromString(env.tmdbApiUrl));
    });

    tearDown(() {
      reset(client);
      reset(internetConnectionCheckerPlus);
    });

    test('All requests contains the necessary query parameters and the right host', () {
      final uri = tmdbUrlBuilder.convertToUriAndAddQueryParameters(env.tmdbApiUrl);
      expect(uri.queryParameters, {
        'api_key': env.tmdbApiKey,
        'language': env.tmdbLanguage,
        'include_adult': env.includeAdult.toString(),
      });
    });

    test('Throws a InternetConnectionException if the user is not connected to the internet', () async {
      when(() => internetConnectionCheckerPlus.hasConnection).thenAnswer((_) async => false);
      final popularMoviesFuture = tmdbRestApiClient.get('movie/popular');
      await expectLater(popularMoviesFuture, throwsA(isA<InternetConnectionException>()));
    });

    test('Throws a TMDBRequestError if the request returns an error', () async {
      final errorBodyMap = {
        TMDBErrorKeys.statusCode: TMDBErrorCode.invalidId.code,
        TMDBErrorKeys.statusMessage: 'Not found',
      };
      when(() => client.get(any())).thenAnswer((_) async => Response(jsonEncode(errorBodyMap), 400));
      when(() => internetConnectionCheckerPlus.hasConnection).thenAnswer((_) async => true);
      final popularMoviesFuture = tmdbRestApiClient.get('movie/popular');
      await expectLater(popularMoviesFuture, throwsA(isA<TMDBRequestError>()));
    });

    test('Returns the response body converted to a Map if the request succeeds', () async {
      final responseBodyMap = {'field': 'value'};
      when(() => client.get(any())).thenAnswer((_) async => Response(jsonEncode(responseBodyMap), 200));
      when(() => internetConnectionCheckerPlus.hasConnection).thenAnswer((_) async => true);
      final popularMovies = await tmdbRestApiClient.get('movie/popular');
      expect(popularMovies, responseBodyMap);
    });

    test('Should throw a RequestTimeoutException if the request times out', () async {
      when(() => internetConnectionCheckerPlus.hasConnection).thenAnswer((_) async => true);
      when(() => client.get(any())).thenThrow(TimeoutException('timeout'));
      final popularMoviesFuture = tmdbRestApiClient.get('movie/popular');
      expect(popularMoviesFuture, throwsA(isA<RequestTimeoutException>()));
    });
  });
}
