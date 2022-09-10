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
          final topRatedMovies = state.topRatedMovies!;
          final mostPopularMovies = state.mostPopularMovies!;
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
    return AspectRatio(
      aspectRatio: 1.75,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        cacheExtent: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: movies.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),        
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.push('/movie/${movies[index].id}'),
            child: AspectRatio(
              aspectRatio: .67,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: '$baseImagesUrl${movies[index].posterPath}',
                  fit: BoxFit.fitHeight,
                  placeholder: (_, ___) {
                    return ShimmerLoading(
                      isLoading: true,                      
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black,
                        child: nil,
                      ),
                    );
                  },
                  errorWidget: (_, __, ___) {
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
