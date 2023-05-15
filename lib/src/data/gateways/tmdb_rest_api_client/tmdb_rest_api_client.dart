import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../core/env.dart';
import '../../../core/faults/exceptions/exceptions.dart';
import 'errors/errors.dart';

export 'errors/errors.dart';

abstract class TMDBRestApiClient {
  Future<Map<String, dynamic>> get(String path);
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic> data});
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic> data});
  Future<Map<String, dynamic>> delete(String path, {Map<String, dynamic>? data});
}

class TMDBRestApiClientImpl implements TMDBRestApiClient {
  late final http.Client _httpClient;
  late final InternetConnectionCheckerPlus _internetConnectionChecker;
  late final Connectivity _connectivity;

  TMDBRestApiClientImpl({
    http.Client? client,
    Connectivity? connectivity,
    InternetConnectionCheckerPlus? internetConnectionChecker,
  }) {
    _httpClient = client ?? http.Client();
    _connectivity = connectivity ?? Connectivity();
    _internetConnectionChecker = internetConnectionChecker ?? InternetConnectionCheckerPlus();
  }

  @override
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    return _request(path, data: data, method: _Method.delete);
  }

  @override
  Future<Map<String, dynamic>> get(String path) async {
    return _request(path, method: _Method.get);
  }

  @override
  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    return _request(path, method: _Method.post, data: data);
  }

  @override
  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    return _request(path, method: _Method.put, data: data);
  }

  Uri _urlToUri(String url) {
    final uriFromUrl = Uri.parse(url);
    final uri = uriFromUrl.replace(queryParameters: {
      ...uriFromUrl.queryParameters,
      'api_key': env.tmdbApiKey,
      'include_adult': '${env.includeAdult}',
    });

    return uri;
  }

  void _verifyStatusCode(int statusCode, Map<String, dynamic> responseBody) {
    late Exception exception;
    switch (statusCode) {
      case 200:
      case 201:
        return;
      case 422:
        exception = TMDBUnprocessableEntityError.fromJsonResponse(responseBody);
        break;
      default:
        exception = TMDBRequestError.fromJsonResponse(responseBody);
    }
    throw exception;
  }

  Future<Map<String, dynamic>> _request(String path, {required _Method method, Map<String, dynamic>? data}) async {
    await _verifyInternetStatus();
    final apiUrl = env.tmdbApiUrl;
    final resourceUri = _urlToUri('$apiUrl$path');
    final response = await _execRequest(method, resourceUri, data);
    final responseParsed = await compute(jsonDecode, response.body);
    _verifyStatusCode(response.statusCode, responseParsed);
    return responseParsed;
  }

  Future<http.Response> _execRequest(_Method method, Uri uri, Map<String, dynamic>? data) async {
    late http.Response response;
    try {
      switch (method) {
        case _Method.get:
          response = await _httpClient.get(uri);
          break;
        case _Method.post:
          response = await _httpClient.post(uri, body: data);
          break;
        case _Method.put:
          response = await _httpClient.put(uri, body: data);
          break;
        case _Method.delete:
          response = await _httpClient.delete(uri, body: data);
          break;
      }
      return response;
    } on TimeoutException {
      throw RequestTimeoutException();
    } on Exception catch (_) {
      throw RequestUnknownException('Request error');
    }
  }

  Future<void> _verifyInternetStatus() async {
    final connectedToNetworkValues = [
      ConnectivityResult.mobile,
      ConnectivityResult.wifi,
    ];
    final connectivityResult = await _connectivity.checkConnectivity();
    if (connectedToNetworkValues.contains(connectivityResult)) {
      await _verifyInternetConnection();
      return;
    }
    throw InternetConnectionException(type: InternetConnectionExceptionType.noNetwork);
  }

  Future<void> _verifyInternetConnection() async {
    final hasConnection = await _internetConnectionChecker.hasConnection;
    if (hasConnection) return;
    throw InternetConnectionException(type: InternetConnectionExceptionType.noInternet);
  }
}

enum _Method {
  get,
  post,
  put,
  delete,
}
