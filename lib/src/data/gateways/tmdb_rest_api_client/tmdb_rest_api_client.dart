import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../core/env.dart';
import '../../../core/faults/exceptions/exceptions.dart';
import 'errors/errors.dart';

export 'errors/errors.dart';

abstract class TMDBRestApiClient {
  Future<Map<String, dynamic>> get(String path);
}

class TMDBRestApiClientImpl implements TMDBRestApiClient {
  late final http.Client _httpClient;
  late final InternetConnectionCheckerPlus _internetConnectionChecker;
  late final TMDBUrlBuilder _tmdbUrlBuilder;

  TMDBRestApiClientImpl({
    http.Client? client,
    TMDBUrlBuilder? tmdbUrlBuilder,
    InternetConnectionCheckerPlus? internetConnectionChecker,
  }) {
    _httpClient = client ?? http.Client();
    _internetConnectionChecker = internetConnectionChecker ?? InternetConnectionCheckerPlus();
    _tmdbUrlBuilder = tmdbUrlBuilder ?? TMDBUrlBuilder();
  }

  @override
  Future<Map<String, dynamic>> get(String path) async {
    await _verifyInternetConnection();
    final apiUrl = env.tmdbApiUrl;
    final resourceUri = _tmdbUrlBuilder.convertToUriAndAddQueryParameters('$apiUrl$path');
    final response = await _execRequest(uri: resourceUri);
    final responseParsed = await compute(jsonDecode, response.body);
    _verifyStatusCode(response.statusCode, responseParsed);
    return responseParsed;
  }

  void _verifyStatusCode(int statusCode, Map<String, dynamic> responseBody) {
    switch (statusCode) {
      case 200:
      case 201:
        return;
      default:
        throw TMDBRequestError.fromJsonResponse(responseBody);
    }
  }

  Future<http.Response> _execRequest({required Uri uri}) async {
    try {
      final response = _httpClient.get(uri);
      return response;
    } on TimeoutException {
      throw RequestTimeoutException();
    } on Exception catch (_) {
      throw RequestUnknownException('Request error');
    }
  }

  Future<void> _verifyInternetConnection() async {
    final hasConnection = await _internetConnectionChecker.hasConnection;
    if (hasConnection) return;
    throw InternetConnectionException();
  }
}

@visibleForTesting
class TMDBUrlBuilder {
  Uri convertToUriAndAddQueryParameters(String url) {
    final uriFromUrl = Uri.parse(url);
    final uri = uriFromUrl.replace(queryParameters: {
      ...uriFromUrl.queryParameters,
      'api_key': env.tmdbApiKey,
      'include_adult': '${env.includeAdult}',
      'language': env.tmdbLanguage,
    });
    return uri;
  }
}
