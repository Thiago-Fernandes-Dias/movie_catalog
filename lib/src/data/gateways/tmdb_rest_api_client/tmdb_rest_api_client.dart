import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../core/env.dart';
import '../../../core/faults/exceptions/exceptions.dart';
import 'errors/errors.dart';

export 'errors/errors.dart';

typedef OnRequestCallback = void Function(Uri uri, {Map<String, dynamic>? data});
typedef OnResponseCallback = void Function(Map<String, dynamic> response);
typedef OnBaseExceptionCallback = void Function(BaseException error);

@visibleForTesting
abstract class OnRequestCallbackObserver {
  void call(Uri uri, {Map<String, dynamic>? data});
}

@visibleForTesting
abstract class OnResponseCallbackObserver {
  void call(Map<String, dynamic> response);
}

@visibleForTesting
abstract class OnBaseExceptionCallbackObserver {
  void call(BaseException error);
}

abstract class TMDBRestApiClient {
  final _responseListeners = <OnResponseCallback>[];
  final _requestListeners = <OnRequestCallback>[];
  final _errorListeners = <OnBaseExceptionCallback>[];

  void onRequest(OnRequestCallback fn) {
    if (_requestListeners.contains(fn)) return;
    _requestListeners.add(fn);
  }

  void removeOnRequestListener(OnRequestCallback fn) {
    _requestListeners.remove(fn);
  }

  void onResponse(OnResponseCallback fn) {
    if (_responseListeners.contains(fn)) return;
    _responseListeners.add(fn);
  }

  void removeOnResponseListener(OnResponseCallback fn) {
    _responseListeners.remove(fn);
  }

  void onError(OnBaseExceptionCallback fn) {
    if (_errorListeners.contains(fn)) return;
    _errorListeners.add(fn);
  }

  void removeOnErrorListener(OnBaseExceptionCallback fn) {
    _errorListeners.remove(fn);
  }

  @protected
  void executeOnRequestCallbacks(Uri uri, {Map<String, dynamic>? data}) {
    for (final fn in _requestListeners) fn(uri, data: null);
  }

  @protected
  void executeOnResponseCallbacks(Map<String, dynamic> response) {
    for (final fn in _responseListeners) fn(response);
  }

  @protected
  void executeOnErrorCallbacks(BaseException error) {
    for (final fn in _errorListeners) fn(error);
  }

  Future<Map<String, dynamic>> get(String path);
}

class TMDBRestApiClientImpl extends TMDBRestApiClient {
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
    executeOnResponseCallbacks(responseParsed);
    return responseParsed;
  }

  void _verifyStatusCode(int statusCode, Map<String, dynamic> responseBody) {
    switch (statusCode) {
      case >= 200 && < 400:
        return;
      default:
        final exception = TMDBRequestError.fromJsonResponse(responseBody);
        for (final fn in _errorListeners) fn(exception);
        throw exception;
    }
  }

  Future<http.Response> _execRequest({required Uri uri}) async {
    BaseException? exception;
    executeOnRequestCallbacks(uri);
    try {
      final response = await _httpClient.get(uri);
      return response;
    } on TimeoutException {
      exception = RequestTimeoutException();
      executeOnErrorCallbacks(exception);
      throw exception;
    } on Exception catch (_) {
      exception = RequestUnknownException('Unknown error');
      executeOnErrorCallbacks(exception);
      throw exception;
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
