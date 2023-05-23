part of 'entities.dart';

class Genres extends Equatable {
  final int id;
  final String name;

  Genres({required this.id, required this.name});

  factory Genres.fromJson(Map<String, dynamic> json) {
    return Genres(id: json['id'], name: json['name']);
  }

  @override
  List<Object?> get props {
    return [id, name];
  }
}
