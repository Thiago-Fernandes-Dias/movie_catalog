part of 'gateways.dart';

class HttpResponse {
  final int statusCode;
  final dynamic data;
  const HttpResponse({required this.statusCode, required this.data});
}

abstract class HttpClient {
  Future<HttpResponse> get(String path);
  Future<HttpResponse> post(String path, {Map<String, dynamic> data, Map<String, dynamic> formData});
  Future<HttpResponse> put(String path, {Map<String, dynamic> data, Map<String, dynamic> formData});
  Future<HttpResponse> delete(String path, {Map<String, dynamic>? data});

  factory HttpClient() => _DioHttpClient();
}

class _DioHttpClient implements HttpClient {
  late Dio _dio;

  static dynamic _parseAndDecode(String response) {
    return jsonDecode(response);
  }

  static dynamic _parseJson(String text) {
    return compute(_parseAndDecode, text);
  }

  BaseOptions get _dioOptions {
    return BaseOptions(
      connectTimeout: 15000,
      receiveTimeout: 15000,
      validateStatus: (_) => true,
      contentType: Headers.jsonContentType,
    );
  }

  _DioHttpClient._internal() {
    _dio = Dio(_dioOptions);
    (_dio.transformer as DefaultTransformer).jsonDecodeCallback = _parseJson;
    _dio.interceptors.add(_TMDBParamsInterceptor());
  }

  static final _DioHttpClient _singleton = _DioHttpClient._internal();

  factory _DioHttpClient() {
    return _singleton;
  }

  @override
  Future<HttpResponse> delete(String url, {Map<String, dynamic>? data}) async {
    var response = await _dio.delete(url, data: data);
    var httpResponse = HttpResponse(data: response.data, statusCode: response.statusCode ?? 404);
    return httpResponse;
  }

  @override
  Future<HttpResponse> get(String url) async {
    var response = await _dio.get(url);
    var httpResponse = HttpResponse(data: response.data, statusCode: response.statusCode ?? 404);
    return httpResponse;
  }

  @override
  Future<HttpResponse> post(String url, {Map<String, dynamic>? data, Map<String, dynamic>? formData}) async {
    assert((formData != null) ^ (data != null), "data e formData não podem ser ambos nulos ou não nulos");
    var input = data ?? FormData.fromMap(formData!);
    var response = await _dio.post(
      url,
      data: input,
      options: data is FormData
          ? Options(contentType: Headers.formUrlEncodedContentType)
          : null,
    );
    var httpResponse = HttpResponse(data: response.data, statusCode: response.statusCode ?? 404);
    return httpResponse;
  }

  @override
  Future<HttpResponse> put(String url, {Map<String, dynamic>? data, Map<String, dynamic>? formData}) async {
    assert((formData != null) ^ (data != null), "data e formData não podem ser ambos nulos ou não nulos");
    var input = data ??  FormData.fromMap(formData!);
    var response = await _dio.put(
      url,
      data: input,
      options: data is FormData
          ? Options(contentType: Headers.formUrlEncodedContentType)
          : null,
    );
    var httpResponse = HttpResponse(data: data, statusCode: response.statusCode ?? 404);
    return httpResponse;
  }
}

class _TMDBParamsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.queryParameters['api_key'] = env.tmdbApiKey;
    options.queryParameters['include_adult'] = env.includeAdult.toString();
    super.onRequest(options, handler);
  }
}