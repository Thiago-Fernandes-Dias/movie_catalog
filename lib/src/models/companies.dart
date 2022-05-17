part of 'models.dart';

class Companies {
  final String name;
  final String originCountry;

  Companies({required this.name, required this.originCountry});

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      name: json['name'],
      originCountry: json['origin_country'],
    );
  }
}