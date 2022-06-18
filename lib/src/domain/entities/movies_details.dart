part of 'entities.dart';

class MovieDetails {
  final int budget;
  final List<Genres> genres;
  final String? homepage;
  final int id;
  final String originalLanguage;
  final String originalTitle;
  final String? overview;
  final num popularity;
  final String? posterPath;
  final List<Companies> companies;
  final List<Country> countries;
  final String releaseDate;
  final int revenue;
  final int? runtime;
  final MovieStatus status;
  final String title;
  final num voteAverage;
  final int voteCount;

  MovieDetails({
    required this.budget,
    required this.genres,
    this.homepage,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    this.overview,
    required this.popularity,
    this.posterPath,
    required this.companies,
    required this.countries,
    required this.releaseDate,
    required this.revenue,
    this.runtime,
    required this.status,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });
}

