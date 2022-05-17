part of 'serializer.dart';

class CastKeys {
  static const String name = 'name';
  static const String character = 'character';
  static const String profilePath = 'profile_path';
}

class CastSerializer implements Serializer<Cast, Map<String, dynamic>> {
  @override
  Cast from(Map<String, dynamic> json) {
    final name = json[CastKeys.name] as String;
    final character = json[CastKeys.character] as String;
    final profilePath = json[CastKeys.profilePath] as String?;

    return Cast(
      name: name,
      character: character,
      profilePath: profilePath,
    );
  }

  @override
  Map<String, dynamic> to(Cast object) {
    return {
      CastKeys.character: object.character,
      CastKeys.name: object.name,
      CastKeys.profilePath: object.profilePath,
    };
  }
}

final castSerializer = CastSerializer();