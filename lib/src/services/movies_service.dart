import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:movie_list/src/models/credits.dart';
import 'package:movie_list/src/models/movies_details.dart';
import 'package:movie_list/src/models/movie_list.dart';

import 'package:movie_list/src/ui/widgets/tmdb.dart' as tmdb;

class MoviesService {
  Future<MovieList> fetchMoviesByTitle(String title, int page) async {
    final url = <String>[
      '${tmdb.baseApiUrl}/search/movie?',
      'api_key=${tmdb.key}&',
      'language=${tmdb.lang}&',
      'page=$page&',
      'include_adult=${tmdb.includeAdult}&',
      'query=$title',
    ].join();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var parsed = await compute(parseMovieList, response.body);

      parsed.results.sort((m1, m2) {
        int d1 = DateTime.parse('${m1!.releaseDate}').year;
        int d2 = DateTime.parse('${m2!.releaseDate}').year;
        return d1 != d2 ? d2.compareTo(d1) : m1.title.compareTo(m2.title);
      });

      return parsed;
    }

    throw Exception;
  }

  Future<MovieDetails> fetchMovieById(id) async {
    final url = <String>[
      '${tmdb.baseApiUrl}/movie/$id?',
      'api_key=${tmdb.key}&',
      'language=${tmdb.lang}',
    ].join();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseMovieDetails, response.body);
    }

    throw Exception;
  }

  Future<Credits> fetchCreditsByMovieId(id) async {
    final url = [
      '${tmdb.baseApiUrl}/movie/$id/credits?',
      'api_key=${tmdb.key}&',
      'language=${tmdb.lang}',
    ].join();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseCredits, response.body);
    }

    throw Exception;
  }

  Future<MovieList> fetchTopRatedMovies() async {
    final url = [
      '${tmdb.baseApiUrl}/movie/top_rated?',
      'api_key=${tmdb.key}&',
      'language=${tmdb.lang}&',
      'page=1',
    ].join();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseMovieList, response.body);
    }

    throw Exception;
  }

  Future<MovieList> fetchMostPupularMovies() async {
    final url = [
      '${tmdb.baseApiUrl}/movie/popular?',
      'api_key=${tmdb.key}&',
      'language=${tmdb.lang}&',
      'page=1',
    ].join();
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return compute(parseMovieList, response.body);
    }

    throw Exception;
  }
}
