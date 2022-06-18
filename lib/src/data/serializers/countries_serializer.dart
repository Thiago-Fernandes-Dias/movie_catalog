part of 'serializer.dart';

class CountryKeys {
  static const String iso31661 = 'iso_3166_1';
  static const String name = 'name';
}

class CountrySerializer implements Serializer<Country, Map<String, dynamic>> {
  @override
  Country from(Map<String, dynamic> json) {
    final iso31661 = json[CountryKeys.iso31661] as String;
    final name = json[CountryKeys.name] as String;

    return Country(name: name, iso31661: iso31661);
  }

  @override
  Map<String, dynamic> to(Country object) {
    return {
      CountryKeys.iso31661: object.iso31661,
      CountryKeys.name: object.name,
    };
  }
}

final countrySerializer = CountrySerializer();