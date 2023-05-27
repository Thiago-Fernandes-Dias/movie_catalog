part of 'entities.dart';

@immutable
class Cast extends Equatable {
  final String name;
  final String character;
  final String? profilePath;

  const Cast({
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

  @override
  List<Object?> get props => [name, character, profilePath];
}
