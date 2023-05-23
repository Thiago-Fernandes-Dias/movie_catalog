part of 'entities.dart';

class Credits extends Equatable {
  final int id;
  final List<Cast> cast;

  Credits({
    required this.id,
    required this.cast,
  });

  @override
  List<Object?> get props => [id, cast];
}
