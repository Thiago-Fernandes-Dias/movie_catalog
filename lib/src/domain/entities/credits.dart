part of 'entities.dart';

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
