part of 'serializer.dart';

class CompaniesKeys {
  static const String name = 'name';
  static const String originCountry = 'origin_country';
}

class CompaniesSerializer implements Serializer<Companies, Map<String, dynamic>> {
  @override
  Companies from(Map<String, dynamic> json) {
    final name = json[CompaniesKeys.name] as String;
    final originCountry = json[CompaniesKeys.originCountry] as String;

    return Companies(
      name: name,
      originCountry: originCountry,
    );
  }

  @override
  Map<String, dynamic> to(object) {
    return {
      CompaniesKeys.name: object.name,
      CompaniesKeys.originCountry: object.originCountry,
    };
  }
}

final companiesSerializer = CompaniesSerializer();