import 'dart:convert';

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

class Credits {
  final int id;
  final List<Cast?> cast;

  Credits({
    required this.id,
    required this.cast,
  });

  factory Credits.fromJson(Map<String, dynamic> json) {
    var parsedCast = <Cast>[];
    json['cast'].forEach((element) {
      parsedCast.add(Cast.fromJson(element));
    });

    return Credits(
      id: json['id'],
      cast: parsedCast,
    );
  }
}

Credits parseCredits(String jsonString) =>
    Credits.fromJson(jsonDecode(jsonString));
