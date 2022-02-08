import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_list/src/models/movie_info.dart';
import 'package:movie_list/src/shared/network_loading.dart' as net;
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/widgets/tmdb.dart' as tmdb;

import 'credit_fields.dart';
import 'movie_fields.dart';

Route showMovieInfo(MovieInfo movie) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      final localizations = AppLocalizations.of(context);

      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.movieInfo),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            splashRadius: 15.0,
            onPressed: Navigator.of(context).pop,
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width >= 650 ? 200 : 0,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 20),
                    child: Text(
                      movie.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * .6,
                    child: net.fetchImage(
                      url: '${tmdb.baseImagesUrl}/${movie.posterPath}',
                      assetOption: 'assets/jpg/noposter.jpg',
                    ),
                  ),
                  MovieFields(movieId: movie.id),
                  CreditsFields(movieId: movie.id),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Container(
          color: const Color(0xff0d0d0d),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(localizations.footer),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: SvgPicture.asset(
                  'assets/svg/tmdb_logo.svg',
                  fit: BoxFit.fitHeight,
                  height: 20,
                  color: Colors.cyan,
                ),
              ),
            ],
          ),
        ),
      );
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
