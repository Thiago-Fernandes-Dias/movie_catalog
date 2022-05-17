part of 'serializer.dart';

class MovieDetailsKeys {
  static const String genres = 'genres';
  static const String companies = 'production_companies';
  static const String originalLanguage = 'original_language';
  static const String originalTitle = 'original_title';
  static const String overview = 'overview';
  static const String popularity = 'popularity';
  static const String releaseDate = 'releaseDate';
  static const String status = 'status';
  static const String title = 'title';
  static const String voteAverage = 'vote_average';
  static const String voteCount = 'vote_count'; 
}

class MovieDetailsSerializer implements Serializer<MovieDetails, Map<String, dynamic>> {
  @override
  MovieDetails from(Map<String, dynamic> json) {
    final rawGenres = List<Map<String, dynamic>>.from(json[MovieDetailsKeys.genres] as List);
    final genres = rawGenres.map(genresSerializer.from).toList();

    final rawCompanies = List<Map<String, dynamic>>.from(json[MovieDetailsKeys.companies] as List);
    final companies = rawCompanies.map(companiesSerializer.from).toList();

    final originalLanguage = json[MovieDetailsKeys.originalLanguage] as String;
    final originalTitle = json[MovieDetailsKeys.originalTitle] as String;
    final overview = json[MovieDetailsKeys.overview] as String?;
    final popularity = json[MovieDetailsKeys.popularity] as num;
    final releaseDate = json[MovieDetailsKeys.releaseDate] as String;
    final status = json[MovieDetailsKeys.status] as String;
    final title = json[MovieDetailsKeys.title] as String;
    final voteAverage = json[MovieDetailsKeys.voteAverage] as num;
    final voteCount = json[MovieDetailsKeys.voteCount] as int;

    return MovieDetails(
      genres: genres,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      popularity: popularity,
      companies: companies,
      releaseDate: releaseDate,
      status: status,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount,
      overview: overview,
    ); 
  }

  @override
  Map<String, dynamic> to(MovieDetails object) {
    return {
      MovieDetailsKeys.genres: object.genres,
      MovieDetailsKeys.originalLanguage: object.originalLanguage,
      MovieDetailsKeys.originalTitle: object.originalTitle,
      MovieDetailsKeys.overview: object.overview,
      MovieDetailsKeys.popularity: object.popularity,
      MovieDetailsKeys.companies: object.companies,
      MovieDetailsKeys.releaseDate: object.releaseDate,
      MovieDetailsKeys.status: object.status,
      MovieDetailsKeys.title: object.title,
      MovieDetailsKeys.voteAverage: object.voteAverage,
      MovieDetailsKeys.voteCount: object.voteCount,
    };
  }
}

final movieDetailsSerializer = MovieDetailsSerializer();