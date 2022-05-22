part of 'entities.dart';

class MovieDetails {
  final List<Genres?> genres;
  final String originalLanguage;
  final String originalTitle;
  String? overview;
  final num popularity;
  final List<Companies?> companies;
  final String releaseDate;
  final String status;
  final String title;
  final num voteAverage;
  final int voteCount;

  MovieDetails({
    required this.genres,
    required this.originalLanguage,
    required this.originalTitle,
    this.overview,
    required this.popularity,
    required this.companies,
    required this.releaseDate,
    required this.status,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) {
    var parsedGenres = <Genres?>[];
    json['genres'].forEach((element) {
      parsedGenres.add(Genres.fromJson(element));
    });

    var parsedCompanies = <Companies?>[];
    json['production_companies'].forEach((element) {
      parsedCompanies.add(Companies.fromJson(element));
    });

    return MovieDetails(
      genres: parsedGenres,
      originalLanguage: json['original_language'],
      originalTitle: json['original_title'],
      overview: json['overview'],
      popularity: json['popularity'],
      companies: parsedCompanies,
      releaseDate: json['release_date'],
      status: json['status'],
      title: json['title'],
      voteAverage: json['vote_average'],
      voteCount: json['vote_count'],
    );
  }
}

MovieDetails parseMovieDetails(String jsonString) =>
    MovieDetails.fromJson(jsonDecode(jsonString));
