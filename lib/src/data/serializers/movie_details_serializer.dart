part of 'serializer.dart';

class MovieDetailsKeys {
  static const String budget = 'budget';
  static const String genres = 'genres';
  static const String homepage = 'homepage';
  static const String id = 'id';
  static const String originalLanguage = 'original_language';
  static const String originalTitle = 'original_title';
  static const String overview = 'overview';
  static const String popularity = 'popularity';
  static const String posterPath = 'poster_path';
  static const String companies = 'production_companies';
  static const String countries = 'production_countries';
  static const String revenue = 'revenue';
  static const String runtime = 'runtime';
  static const String status = 'status';
  static const String releaseDate = 'releaseDate';
  static const String title = 'title';
  static const String voteAverage = 'vote_average';
  static const String voteCount = 'vote_count'; 
}

class MovieDetailsSerializer implements Serializer<MovieDetails, Map<String, dynamic>> {
  @override
  MovieDetails from(Map<String, dynamic> json) {
    final rawGenres = List<Map<String, dynamic>>.from(json[MovieDetailsKeys.genres] as List);
    final rawCompanies = List<Map<String, dynamic>>.from(json[MovieDetailsKeys.companies] as List);
    final rawCountries = List<Map<String, dynamic>>.from(json[MovieDetailsKeys.countries] as List);

    final budget = json[MovieDetailsKeys.budget] as int;
    final genres = rawGenres.map(genresSerializer.from).toList();
    final homepage = json[MovieDetailsKeys.homepage] as String?;
    final id = json[MovieDetailsKeys.id] as int;
    final originalLanguage = json[MovieDetailsKeys.originalLanguage] as String;
    final originalTitle = json[MovieDetailsKeys.originalTitle] as String;
    final overview = json[MovieDetailsKeys.overview] as String?;
    final popularity = json[MovieDetailsKeys.popularity] as num;
    final posterPath = json[MovieDetailsKeys.posterPath] as String?;
    final companies = rawCompanies.map(companiesSerializer.from).toList();
    final countries = rawCountries.map(countrySerializer.from).toList();
    final releaseDate = json[MovieDetailsKeys.releaseDate] as String?;
    final revenue = json[MovieDetailsKeys.revenue] as int;
    final runtime = json[MovieDetailsKeys.runtime] as int?;
    final status = MovieStatus.fromString(json[MovieDetailsKeys.status] as String);
    final title = json[MovieDetailsKeys.title] as String;
    final voteAverage = json[MovieDetailsKeys.voteAverage] as num;
    final voteCount = json[MovieDetailsKeys.voteCount] as int;

    return MovieDetails(
      budget: budget,
      genres: genres,
      homepage: homepage,
      id: id,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      companies: companies,
      countries: countries,
      releaseDate: releaseDate,
      revenue: revenue,
      runtime: runtime,
      status: status,
      title: title,
      voteAverage: voteAverage,
      voteCount: voteCount,
    ); 
  }

  @override
  Map<String, dynamic> to(MovieDetails object) {
    return {
      MovieDetailsKeys.budget: object.budget,
      MovieDetailsKeys.genres: object.genres,
      MovieDetailsKeys.homepage: object.homepage,
      MovieDetailsKeys.id: object.id,
      MovieDetailsKeys.originalLanguage: object.originalLanguage,
      MovieDetailsKeys.originalTitle: object.originalTitle,
      MovieDetailsKeys.overview: object.overview,
      MovieDetailsKeys.popularity: object.popularity,
      MovieDetailsKeys.posterPath: object.posterPath,
      MovieDetailsKeys.companies: object.companies,
      MovieDetailsKeys.countries: object.countries,
      MovieDetailsKeys.releaseDate: object.releaseDate,
      MovieDetailsKeys.revenue: object.revenue,
      MovieDetailsKeys.runtime: object.runtime,
      MovieDetailsKeys.status: object.status,
      MovieDetailsKeys.title: object.title,
      MovieDetailsKeys.voteAverage: object.voteAverage,
      MovieDetailsKeys.voteCount: object.voteCount,
    };
  }
}

final movieDetailsSerializer = MovieDetailsSerializer();