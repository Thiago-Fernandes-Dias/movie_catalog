import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:movie_list/l10n/generated/app_localizations.dart';

import 'package:movie_list/src/shared/tmdb.dart' as tmdb;
import 'package:movie_list/src/shared/network_loading.dart' as net;

import 'package:movie_list/src/models/movie_info.dart';

import 'credit_fields.dart';
import 'movie_fields.dart';

Route showMovieInfo(MovieInfo movie) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      final localizations = AppLocalizations.of(context)!;

      return Scaffold(
        appBar: AppBar(
          title: Text(localizations.movieInfo),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
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
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: Text(
                      '${movie.title}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    height: MediaQuery.of(context).size.height * .6,
                    child: net.fetchImage(
                      '${tmdb.baseImagesUrl}/${movie.posterPath}',
                      'images/noposter.jpg',
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
          color: Color(0xff0d0d0d),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(localizations.footer),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                child: SvgPicture.asset(
                  'images/tmdb_logo.svg',
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
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
