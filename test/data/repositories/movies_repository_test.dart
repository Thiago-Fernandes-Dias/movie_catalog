import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_list/src/core/errors/errors.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/domain/enums/movie_status.dart';

@GenerateMocks([MoviesRepository])
import 'movies_repository_test.mocks.dart';

const _movieId = '1234';
const _invalidMovieId = '';
const _errorStatusCode = 0;
const _defaultPage = 1;

void main() {

  final mockMoviesRepository = MockMoviesRepository();

  group('movie details', () {

    test('should return a movie with id $_movieId', () async {
      when(mockMoviesRepository.getMovieDetails(_movieId)).thenAnswer((_) async {
        final movieDetails = MovieDetails(
          budget: 0,
          genres: [],
          id: int.parse(_movieId),
          originalLanguage: 'en',
          originalTitle: 'Movie 1234',
          popularity: 5,
          companies: [],
          countries: [],
          revenue: 0,
          status: MovieStatus.planned,
          title: 'Movie 1234',
          voteAverage: 0,
          voteCount: 0,
        );
        return movieDetails;
      });
      final movieDetails = await mockMoviesRepository.getMovieDetails(_movieId);
      expect(movieDetails, isA<MovieDetails>());
      expect(movieDetails.id, int.parse(_movieId));
    });

    test(
      'should thrown an TMDBError when trying to fetch '
      'a movie by an invalid id',
      () async {
        const id = _invalidMovieId;
        final tmdbError = TMDBError.fromJsonResponse({
          'status_message': 'Invalid movie ID',
          'status_code': _errorStatusCode,
        }); 
        when(mockMoviesRepository.getMovieDetails(id))
            .thenThrow(tmdbError);
          
        final laterCb = () async => await mockMoviesRepository.getMovieDetails(id);
        await expectLater(laterCb, throwsA(isA<TMDBError>()));
      },
    );
  });

  group('getTopRatedMovies', () {

    test('should return a "MovieList" with the "results" field pointing to '
         'a list of "MovieInfo" and the "page" field equals to $_defaultPage',
      () async {
        when(mockMoviesRepository.getTopRatedMovies(_defaultPage)).thenAnswer((_) async {
          final movieInfoList = <MovieInfo>[
            MovieInfo(id: 0, title: 'MovieInfo 0'),
            MovieInfo(id: 1, title: 'MovieInfo 1')
          ];
          final movieList = MovieList(
            page: _defaultPage,
            results: movieInfoList,
            totalPages: 5,
            totalResults: movieInfoList.length,
          );
          return movieList;
        });
        final topRatedMovies = await mockMoviesRepository.getTopRatedMovies(_defaultPage);
        expect(topRatedMovies, isA<MovieList>());
        expect(topRatedMovies.page, _defaultPage);
      },
    );
  });
}