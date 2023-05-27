part of 'entities.dart';

@immutable
class Credits extends Equatable {
  final int id;
  final List<Cast> cast;

  const Credits({
    required this.id,
    required this.cast,
  });

  @override
  List<Object?> get props => [id, cast];
}
