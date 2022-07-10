part of 'home_page.dart';

class _MovieLists extends StatelessWidget {
  const _MovieLists({
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
            onTap: () => context.go('/movie/${movies[index].id}'),
            child: Row(
              children: [
                const SizedBox(width: 20),
                Hero(
                  tag: '$baseImagesUrl${movies[index].posterPath}',
                  child: CachedNetworkImage(
                    fit: BoxFit.fitHeight,
                    imageUrl: '$baseImagesUrl${movies[index].posterPath}',
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
          child: fieldTitle(gridTitle),
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
