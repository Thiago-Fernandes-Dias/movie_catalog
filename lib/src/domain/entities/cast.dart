part of 'entities.dart';

class Cast {
  final String name;
  final String character;
  String? profilePath;

  Cast({
    required this.name,
    required this.character,
    this.profilePath,
  });

  factory Cast.fromJson(Map<String, dynamic> json) {
    return Cast(
      name: json['name'],
      character: json['character'],
      profilePath: json['profile_path'],
    );
  }
}
