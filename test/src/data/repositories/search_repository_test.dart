import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie_list/src/data/gateways/gateways.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/data/serializers/serializer.dart';

import '../../../fixtures/fixtures.dart';

void main() {
  group('SearchRepositoryImpl', () {
    late final SearchRepository searchRepository;
    late final TMDBRestApiClient tmdbRestApiClient;

    setUpAll(() {
      tmdbRestApiClient = MockTMDBRestApiClient();
      searchRepository = SearchRepositoryImpl(tmdbRestApiClient);
    });

    setUp(() => reset(tmdbRestApiClient));

    group('searchMoviesByTitle', () {
      test('returns a MovieList for the movies which title matches the query', () async {
        const query = 'query', page = 1;
        when(() => tmdbRestApiClient.get('search/movie?query=$query&page=$page')).thenAnswer(
          (_) async => searchSampleMap,
        );
        final searchResults = await searchRepository.searchMoviesByTitle(query, page);
        final searchSample = movieListSerializer.from(searchSampleMap);
        expect(searchResults, searchSample);
      });
    });
  });
}
