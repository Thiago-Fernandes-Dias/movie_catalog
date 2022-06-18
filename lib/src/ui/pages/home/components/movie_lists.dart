import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/ui/pages/movie_details/movie_details_page.dart';
import 'package:movie_list/src/ui/widgets/shared/network_loading.dart' as net;
import 'package:movie_list/src/ui/widgets/shared/text_format.dart' as text;
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/widgets/tmdb.dart' as tmdb;

class MovieLists extends StatelessWidget {
  const MovieLists({
    Key? key,
    required this.topRatedMovies,
    required this.mostPopularMovies,
  }) : super(key: key);

  final List<MovieInfo> topRatedMovies;
  final List<MovieInfo> mostPopularMovies;

  Widget _buildGrid(List<MovieInfo> movies) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        itemCount: movies.length,
        padding: const EdgeInsets.only(right: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(showMovieInfo(movies[index]));
            },
            child: Row(
              children: [
                const SizedBox(width: 20),
                Hero(
                  tag: '${tmdb.baseImagesUrl}/${movies[index].posterPath}',
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl:
                        '${tmdb.baseImagesUrl}/${movies[index].posterPath}',
                    errorWidget: (_, __, ___) {
                      return Image.asset(
                        'assets/jpg/noposter.jpg',
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _loadGrid(
    List<MovieInfo> movieList,
    String gridTitle,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20),
          child: text.fieldTitle(gridTitle),
        ),
        _buildGrid(movieList),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        _loadGrid(
          topRatedMovies,
          localizations.topRated,
        ),
        _loadGrid(
          mostPopularMovies,
          localizations.mostPopular,
        ),
      ],
    );
  }
}
