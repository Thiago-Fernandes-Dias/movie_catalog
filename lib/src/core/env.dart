abstract class Enviroment {
  String get tmdbApiUrl;
  String get tmdbApiKey;
  String get tmdbImageUrl;
  bool get includeAdult;
}

class EnviromentImpl implements Enviroment {
  @override
  bool get includeAdult => const bool.fromEnvironment('INCLUDE_ADULT');

  @override
  String get tmdbApiKey => const String.fromEnvironment('TMDB_API_KEY');

  @override
  String get tmdbApiUrl => const String.fromEnvironment('TMDB_API_URL');

  @override
  String get tmdbImageUrl => const String.fromEnvironment('TMDB_IMAGE_URL');

}

final env = EnviromentImpl();