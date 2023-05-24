part of 'entities.dart';

class MovieInfo extends Equatable {
  final int id;
  String? releaseDate;
  final String title;
  String? posterPath;

  MovieInfo({
    required this.id,
    this.releaseDate,
    required this.title,
    this.posterPath,
  });

  factory MovieInfo.fromJson(Map<String, dynamic> json) {
    return MovieInfo(
      id: json['id'],
      releaseDate: json['release_date'],
      title: json['title'],
      posterPath: json['poster_path'],
    );
  }

  @override
  List<Object?> get props => [id, releaseDate, title, posterPath];
}
