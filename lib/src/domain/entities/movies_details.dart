part of 'entities.dart';

class MovieDetails extends Equatable {
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
  final String? releaseDate;
  final int revenue;
  final int? runtime;
  final MovieStatus status;
  final String title;
  final num voteAverage;
  final int voteCount;

  const MovieDetails({
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
    this.releaseDate,
    required this.revenue,
    this.runtime,
    required this.status,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  @override
  List<Object?> get props {
    return [
      budget,
      genres,
      homepage,
      id,
      originalLanguage,
      originalTitle,
      overview,
      popularity,
      posterPath,
      companies,
      countries,
      releaseDate,
      revenue,
      runtime,
      status,
      title,
      voteAverage,
      voteCount,
    ];
  }
}
