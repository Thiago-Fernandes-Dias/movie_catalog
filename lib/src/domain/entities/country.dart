part of 'entities.dart';

class Country extends Equatable {
  final String iso31661;
  final String name;

  const Country({
    required this.iso31661,
    required this.name,
  });

  @override
  List<Object?> get props {
    return [iso31661, name];
  }
}
