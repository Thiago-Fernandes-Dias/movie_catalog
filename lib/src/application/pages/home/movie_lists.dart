part of 'home_page.dart';

class _MovieLists extends StatelessWidget {
  const _MovieLists();

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return BlocBuilder<HomeMovieListCubit, HomeMovieListState>(
      builder: (context, state) {
        if (state is LoadingMovieLists) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is HomeMovieListErrorState) {
          return Center(child: Text(state.error.toString()));
        } else if (state is LoadedMovieList) {
          final topRatedMovies = state.topRatedMovies!.results;
          final mostPopularMovies = state.mostPopularMovies!.results;
          return ListView(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: fieldTitle(localizations.topRated),
                  ),
                  _MovieListsHorizontalListBuilder(topRatedMovies),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20),
                    child: fieldTitle(localizations.mostPopular),
                  ),
                  _MovieListsHorizontalListBuilder(mostPopularMovies),
                ],
              ),
            ],
          );
        }
        return nil;
      }
    );
  }
}

class _MovieListsHorizontalListBuilder extends StatelessWidget {
  const _MovieListsHorizontalListBuilder(this.movies);

  final List<MovieInfo> movies;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        addAutomaticKeepAlives: false,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),        
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.go('/movie/${movies[index].id}'),
            child: Hero(
              tag: '$baseImagesUrl${movies[index].posterPath}',
              child: AspectRatio(
                aspectRatio: .67,
                child: Image.network(
                  '$baseImagesUrl${movies[index].posterPath}',
                  fit: BoxFit.fitHeight,
                  errorBuilder: (_, __, ___) {
                    return Image.asset(
                      'assets/jpg/noposter.jpg',
                      fit: BoxFit.fitHeight,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
