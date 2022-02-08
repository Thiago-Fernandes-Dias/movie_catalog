import 'package:flutter/material.dart';

import 'package:movie_list/src/shared/text_format.dart' as text;
import 'package:movie_list/src/shared/network_loading.dart' as net;

import 'package:movie_list/src/models/movies_details.dart';

import 'package:movie_list/l10n/generated/app_localizations.dart';

import 'package:movie_list/src/services/movies_service.dart';
import 'package:provider/provider.dart';

class MovieFields extends StatelessWidget {
  final int movieId;

  const MovieFields({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  Widget movieData(String fieldName, String info) {
    final movieField = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    final movieInfo = TextStyle(
      fontWeight: FontWeight.w300,
    );

    return Container(
      padding: EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          text: '$fieldName: ',
          style: movieField,
          children: [
            TextSpan(
              text: '$info',
              style: movieInfo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _movieFields(MovieDetails movie, context) {
    final localization = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          text.fieldTitle(localization.about),
          movieData(localization.title, movie.originalTitle),
          movieData(
            localization.lang,
            movie.originalLanguage,
          ),
          movieData(localization.overview, text.validate(movie.overview)),
          movieData(
            localization.genres,
            movie.genres.length > 0
                ? movie.genres.map((item) => item!.name).join(', ')
                : localization.notFount,
          ),
          movieData(
            localization.comps,
            movie.companies.length > 0
                ? movie.companies.map((item) => item!.name).join(', ')
                : localization.notFount,
          ),
          movieData(localization.release, movie.releaseDate),
          movieData(localization.votes, text.validate('${movie.voteCount}')),
          movieData(localization.rate, text.validate('${movie.voteAverage}')),
          movieData(localization.status, movie.status),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MoviesService moviesService = Provider.of<MoviesService>(context);

    return FutureBuilder<MovieDetails>(
      future: moviesService.fetchMovieById(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return net.loadingField();
        } else if (snapshot.hasData) {
          return _movieFields(snapshot.data!, context);
        }

        return text.showMessage(
          // TODO translate
          'Error while fetch movie information. Sorry...',
          true,
        );
      },
    );
  }
}
