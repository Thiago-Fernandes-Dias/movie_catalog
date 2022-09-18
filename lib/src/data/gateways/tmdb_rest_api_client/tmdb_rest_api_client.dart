import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/env.dart';
import 'errors/errors.dart';

export 'errors/errors.dart';

abstract class TMDBRestApiClient {
  Future<Map<String, dynamic>> get(String path);
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic> data});
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic> data});
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? data,
  });
}

class TMDBRestApiClientImpl implements TMDBRestApiClient {
  late final http.Client httpClient;

  TMDBRestApiClientImpl([http.Client? client]) {
    httpClient = client ?? http.Client();
  }

  @override
  Future<Map<String, dynamic>> delete(
    String url, {
    Map<String, dynamic>? data,
  }) async {
    final response = await httpClient.delete(_urlToUri(url), body: data);
    final responseParsed = await compute(jsonDecode, response.body);
    _verifyStatusCode(response.statusCode, responseParsed);
    return responseParsed;
  }

  @override
  Future<Map<String, dynamic>> get(String url) async {
    var response = await httpClient.get(_urlToUri(url));
    final responseParsed = await compute(jsonDecode, response.body);
    _verifyStatusCode(response.statusCode, responseParsed);
    return responseParsed;
  }

  @override
  Future<Map<String, dynamic>> post(
    String url, {
    Map<String, dynamic>? data,
  }) async {
    var response = await httpClient.post(_urlToUri(url), body: data);
    final responseParsed = await compute(jsonDecode, response.body);
    _verifyStatusCode(response.statusCode, responseParsed);
    return responseParsed;
  }

  @override
  Future<Map<String, dynamic>> put(
    String url, {
    Map<String, dynamic>? data,
  }) async {
    var response = await httpClient.put(_urlToUri(url), body: data);
    final responseParsed = await compute(jsonDecode, response.body);
    _verifyStatusCode(response.statusCode, responseParsed);
    return responseParsed;
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
}
