part of 'serializer.dart';

class CreditsKeys {
  static const String id = 'id';
  static const String cast = 'cast';
}

class CreditsSerializer implements Serializer<Credits, Map<String, dynamic>> {
  @override
  Credits from(Map<String, dynamic> json) {
    final rawCasts = List<Map<String, dynamic>>.from(json[CreditsKeys.cast] as List);
    
    final cast = rawCasts.map(castSerializer.from).toList();
    final id = json[CreditsKeys.id] as int;

    return Credits(cast: cast, id: id);
  }

  @override
  Map<String, dynamic> to(Credits object) {
    return {
      CreditsKeys.id: object.id,
      CreditsKeys.cast: object.cast,
    };
  }
}

final creditsSerializer = CreditsSerializer();
