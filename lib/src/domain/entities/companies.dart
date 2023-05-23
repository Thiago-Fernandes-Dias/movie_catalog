part of 'entities.dart';

class Companies extends Equatable {
  final String name;
  final String originCountry;

  const Companies({required this.name, required this.originCountry});

  factory Companies.fromJson(Map<String, dynamic> json) {
    return Companies(
      name: json['name'],
      originCountry: json['origin_country'],
    );
  }

  @override
  List<Object?> get props => [name, originCountry];
}
