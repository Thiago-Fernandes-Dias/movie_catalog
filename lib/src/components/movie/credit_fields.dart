import 'package:flutter/material.dart';

import 'package:movie_list/src/shared/text_format.dart' as text;
import 'package:movie_list/src/shared/tmdb.dart' as tmdb;
import 'package:movie_list/src/shared/network_loading.dart' as net;

import 'package:movie_list/l10n/generated/app_localizations.dart';

import 'package:movie_list/src/models/credits.dart';

import 'package:movie_list/src/services/movies_service.dart';
import 'package:provider/provider.dart';

class CreditsFields extends StatelessWidget {
  final int movieId;

  const CreditsFields({
    Key? key,
    required this.movieId,
  }) : super(key: key);

  Row _buildCastItem(BuildContext context, Cast cast) {
    double itemHeight = MediaQuery.of(context).size.height * .2;
    EdgeInsets itemPadding = EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 6,
    );
    TextStyle castName = TextStyle(
      fontSize: 16,
    );
    TextStyle castCharacter = TextStyle(
      color: Colors.grey.shade600,
    );

    return Row(
      children: [
        Container(
          padding: itemPadding,
          height: itemHeight,
          width: 95,
          child: net.fetchImage(
            '${tmdb.baseImagesUrl}/${cast.profilePath}',
            'images/noprofile.jpg',
          ),
        ),
        Expanded(
          child: Container(
            padding: itemPadding,
            height: itemHeight,
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '${cast.name}\n',
                style: castName,
                children: [
                  TextSpan(
                    text: cast.character != ''
                        ? cast.character
                        : AppLocalizations.of(context)!.gest,
                    style: castCharacter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCastField(BuildContext context, List<Cast?> cast) {
    return Container(
      padding: EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          text.fieldTitle(AppLocalizations.of(context)!.cast),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    MediaQuery.of(context).size.width >= 650 ? 3 : 1,
                mainAxisSpacing: 20,
                mainAxisExtent: 150,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: cast.length < 6 ? cast.length : 6,
              itemBuilder: (context, i) => _buildCastItem(context, cast[i]!),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MoviesService moviesService = Provider.of<MoviesService>(context);

    return FutureBuilder<Credits>(
      future: moviesService.fetchCreditsByMovieId(movieId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return net.loadingField();
        } else if (snapshot.hasData && snapshot.data!.cast.length > 0) {
          return _buildCastField(context, snapshot.data!.cast);
        }

        return text.showMessage(
          AppLocalizations.of(context)!.notFount,
          false,
        );
      },
    );
  }
}
