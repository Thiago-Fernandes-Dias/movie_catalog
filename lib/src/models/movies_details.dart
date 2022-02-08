import 'dart:convert';

class Genres {
  final int id;
  final String name;

  Genres({required this.id, required this.name});

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(id: json['id'], name: json['name']);
  }
}

class Companies {
  final String name;
  final String originCountry;

  Companies({required this.name, required this.originCountry});

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      name: json['name'],
      originCountry: json['origin_country'],
    );
  }
}

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
