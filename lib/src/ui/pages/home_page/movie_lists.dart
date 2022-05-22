import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/domain/services/movies_service.dart';
import 'package:movie_list/src/ui/widgets/shared/network_loading.dart' as net;
import 'package:movie_list/src/ui/widgets/shared/text_format.dart' as text;
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/pages/movie_details_page/movie_details_page.dart';
import 'package:movie_list/src/ui/widgets/tmdb.dart' as tmdb;
import 'package:provider/provider.dart';

class MovieLists extends StatelessWidget {
  const MovieLists({
    Key? key,
  }) : super(key: key);

  Widget _buildGrid(List<MovieInfo?> movies, BuildContext ctx) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: movies.length,
        padding: const EdgeInsets.only(right: 10),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  showMovieInfo(movies[index]!));
            },
            child: Row(
              children: [
                const SizedBox(width: 20),
                Hero(
                  tag: '${tmdb.baseImagesUrl}/${movies[index]!.posterPath}',
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl: '${tmdb.baseImagesUrl}/${movies[index]!.posterPath}',
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
    Future<MovieList> Function() future,
    String gridTitle,
    String errorMessage,
  ) {
    return FutureBuilder<MovieList>(
      future: future(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return net.loadingField();
        } else if (snapshot.hasData && snapshot.data!.results.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: text.fieldTitle(gridTitle),
              ),
              _buildGrid(snapshot.data!.results, context),
            ],
          );
        }

        return text.showMessage(
          errorMessage,
          true,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final MoviesService moviesService = Provider.of<MoviesService>(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      children: [
        _loadGrid(
          moviesService.fetchTopRatedMovies,
          localizations.topRated,
          localizations.errorLoadingGrid,
        ),
        _loadGrid(
          moviesService.fetchMostPupularMovies,
          localizations.mostPopular,
          localizations.errorLoadingGrid,
        ),
      ],
    );
  }
}
