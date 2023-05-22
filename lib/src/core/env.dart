abstract class Environment {
  String get tmdbApiUrl;
  String get tmdbApiKey;
  String get tmdbImageUrl;
  bool get includeAdult;
  String get tmdbLanguage;
}

class EnvironmentImpl implements Environment {
  @override
  bool get includeAdult => const bool.fromEnvironment('INCLUDE_ADULT');

  @override
  String get tmdbApiKey => const String.fromEnvironment('TMDB_API_KEY');

  @override
  String get tmdbApiUrl => const String.fromEnvironment('TMDB_API_URL');

  @override
  String get tmdbImageUrl => const String.fromEnvironment('TMDB_IMAGE_URL');

  @override
  String get tmdbLanguage => const String.fromEnvironment('TMDB_LANGUAGE');
}

final env = EnvironmentImpl();
