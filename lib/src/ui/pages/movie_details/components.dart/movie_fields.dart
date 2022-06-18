import 'package:flutter/material.dart';

import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/ui/widgets/shared/text_format.dart' as text;
import 'package:movie_list/src/ui/l10n/app_localizations.dart';

class MovieFields extends StatelessWidget {
  final int movieId;

  const MovieFields({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  Widget movieData(String fieldName, String info) {
    const movieField = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    const movieInfo = TextStyle(
      fontWeight: FontWeight.w300,
    );

    return Container(
      padding: const EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          text: '$fieldName: ',
          style: movieField,
          children: [
            TextSpan(
              text: info,
              style: movieInfo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _movieFields(MovieDetails movie, context) {
    final localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
            movie.genres.isNotEmpty
                ? movie.genres.map((item) => item!.name).join(', ')
                : localization.notFount,
          ),
          movieData(
            localization.comps,
            movie.companies.isNotEmpty
                ? movie.companies.map((item) => item!.name).join(', ')
                : localization.notFount,
          ),
          movieData(localization.release, movie.releaseDate),
          movieData(localization.votes, text.validate('${movie.voteCount}')),
          movieData(localization.rate, text.validate('${movie.voteAverage}')),
          // movieData(localization.status, movie.status),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final MoviesService moviesService = Provider.of<MoviesService>(context);

    // return FutureBuilder<MovieDetails>(
    //   future: moviesService.fetchMovieById(movieId),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return net.loadingField();
    //     } else if (snapshot.hasData) {
    //       return _movieFields(snapshot.data!, context);
    //     }

    //     return text.showMessage(
    //       'Error while fetch movie information. Sorry...',
    //       true,
    //     );
    //   },
    // );
    return Container();
  }
}
