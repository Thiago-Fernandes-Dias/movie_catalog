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

import '../../../../fixtures/fixtures.dart';

class ClientMock extends Mock implements Client {}

class InternetConnectionCheckerPlusMock extends Mock implements InternetConnectionCheckerPlus {}

void main() {
  group('TMDBRestApiClientImpl', () {
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

    void mockInternetConnectionStatus(bool hasConnection) {
      when(() => internetConnectionCheckerPlus.hasConnection).thenAnswer((_) async => hasConnection);
    }

    Map<String, dynamic> mockClientWithSampleJson(Client client) {
      final responseBodyMap = {'field': 'value'};
      when(() => client.get(any())).thenAnswer((_) async => Response(jsonEncode(responseBodyMap), 200));
      return responseBodyMap;
    }

    test('All requests contains the necessary query parameters and the right host', () {
      final uri = tmdbUrlBuilder.convertToUriAndAddQueryParameters(env.tmdbApiUrl);
      expect(uri.queryParameters, {
        'api_key': env.tmdbApiKey,
        'language': env.tmdbLanguage,
        'include_adult': env.includeAdult.toString(),
      });
    });

    test('Throws a InternetConnectionException if the user is not connected to the internet', () async {
      mockInternetConnectionStatus(false);
      final popularMoviesFuture = tmdbRestApiClient.get('movie/popular');
      await expectLater(popularMoviesFuture, throwsA(isA<InternetConnectionException>()));
    });

    test('Throws a TMDBRequestError if the request returns an error', () async {
      final errorBodyMap = {
        TMDBErrorKeys.statusCode: TMDBErrorCode.invalidId.code,
        TMDBErrorKeys.statusMessage: 'Not found',
      };
      when(() => client.get(any())).thenAnswer((_) async => Response(jsonEncode(errorBodyMap), 400));
      mockInternetConnectionStatus(true);
      final popularMoviesFuture = tmdbRestApiClient.get('movie/popular');
      await expectLater(popularMoviesFuture, throwsA(isA<TMDBRequestError>()));
    });

    test('Returns the response body converted to a Map if the request succeeds', () async {
      final responseBodyMap = mockClientWithSampleJson(client);
      mockInternetConnectionStatus(true);
      final popularMovies = await tmdbRestApiClient.get('movie/popular');
      expect(popularMovies, responseBodyMap);
    });

    test('Should throw a RequestTimeoutException if the request times out', () async {
      mockInternetConnectionStatus(true);
      when(() => client.get(any())).thenThrow(TimeoutException('timeout'));
      final popularMoviesFuture = tmdbRestApiClient.get('movie/popular');
      expect(popularMoviesFuture, throwsA(isA<RequestTimeoutException>()));
    });

    test('Should run the on requests and on response callbacks', () async {
      mockInternetConnectionStatus(true);
      final responseBodyMap = mockClientWithSampleJson(client);
      final onRequestCallback = MockOnRequestCallback();
      final onResponseCallback = MockOnResponseCallback();
      tmdbRestApiClient.onRequest(onRequestCallback.call);
      tmdbRestApiClient.onResponse(onResponseCallback.call);
      final uri = tmdbUrlBuilder.convertToUriAndAddQueryParameters(env.tmdbApiUrl);
      final url = uri.toString();
      await tmdbRestApiClient.get(url);
      await tmdbRestApiClient.get(url);
      verify(() => onRequestCallback.call(uri)).called(2);
      verify(() => onResponseCallback.call(responseBodyMap)).called(2);
    });
  });
}
