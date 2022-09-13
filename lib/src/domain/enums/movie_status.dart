import '../../core/errors/errors.dart';

enum MovieStatus {
  rumored(),
  planned(),
  inProduction(),
  postProduction(),
  released(),
  canceled();

  static MovieStatus fromString(String status) {
    switch (status) {
      case 'Rumored': return rumored;
      case 'Planned': return planned;
      case 'In Production': return inProduction;
      case 'Post Production': return postProduction;
      case 'Released': return released;
      default: return canceled;
    } 
  }

  @override
  String toString() {
    switch (this) {
      case rumored: return 'Rumored';
      case planned: return 'Planned';
      case inProduction: return 'In Production';
      case postProduction: return 'Post Production';
      case released: return 'Released';
      case canceled: return 'Canceled';
    }
  }
}