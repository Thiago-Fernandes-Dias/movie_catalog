import 'package:flutter/material.dart';
import 'package:movie_list/src/models/movie_info.dart';
import 'package:movie_list/src/models/movie_list.dart';
import 'package:movie_list/src/services/movies_service.dart';
import 'package:movie_list/src/shared/network_loading.dart' as net;
import 'package:movie_list/src/shared/text_format.dart' as text;
import 'package:movie_list/src/shared/tmdb.dart' as tmdb;
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/pages/movie_details_page/movie_details_page.dart';
import 'package:provider/provider.dart';

class MovieGrids extends StatelessWidget {
  const MovieGrids({
    Key? key,
  }) : super(key: key);

  Widget _builGrid(List<MovieInfo?> movies, BuildContext ctx) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(ctx).size.width >= 650 ? 5 : 2,
        mainAxisSpacing: 20,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => Navigator.of(context).push(
            showMovieInfo(movies[index]!),
          ),
          child: net.fetchImage(
            '${tmdb.baseImagesUrl}/${movies[index]?.posterPath}',
            'assets/jpg/noposter.jpg',
          ),
        );
      },
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                text.fieldTitle(gridTitle),
                _builGrid(snapshot.data!.results, context),
              ],
            ),
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
