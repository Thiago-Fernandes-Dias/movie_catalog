part of 'serializer.dart';

class MovieStatusSerializer implements Serializer<MovieStatus, String> {
  @override
  MovieStatus from(String statusString) {
    switch (statusString) {
      case 'Rumored':
        return MovieStatus.rumored;
      case 'Planned':
        return MovieStatus.planned;
      case 'In Production':
        return MovieStatus.inProduction;
      case 'Post Production':
        return MovieStatus.postProduction;
      case 'Released':
        return MovieStatus.released;
      case 'Canceled':
        return MovieStatus.canceled;
      default:
        throw SerializationError('Invalid movie status string');
    }
  }

  @override
  String to(MovieStatus status) {
    switch (status) {
      case MovieStatus.rumored:
        return 'Rumored';
      case MovieStatus.planned:
        return 'Planned';
      case MovieStatus.inProduction:
        return 'In Production';
      case MovieStatus.postProduction:
        return 'Post Production';
      case MovieStatus.released:
        return 'Released';
      case MovieStatus.canceled:
        return 'Canceled';
    }
  }
}

final movieStatusSerializer = MovieStatusSerializer();
