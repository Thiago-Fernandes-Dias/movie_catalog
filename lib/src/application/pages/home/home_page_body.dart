part of 'home_page.dart';

class _HomePageBody extends StatefulWidget {
  const _HomePageBody();

  @override
  State<_HomePageBody> createState() => __HomePageBodyState();
}

class __HomePageBodyState extends State<_HomePageBody> {
  late final HomeMovieListCubit _homeMovieListCubit; 
  
  @override
  void initState() {
    super.initState();
    _homeMovieListCubit = context.read()..getHomeMovieLists();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Shimmer(
      child: Column(
        children: [
          const _SearchBar(),
          Expanded(
            child: BlocBuilder<HomeMovieListCubit, HomeMovieListState>(
              bloc: _homeMovieListCubit,
              builder: (context, state) => switch (state) {
                LoadingMovieLists() => const Center(child: CircularProgressIndicator()),
                MovieSearchError(exception: final exception) => Center(child: Text(exception.toString())),
                LoadingSearchResults(searchTerm: final term) => (() {
                    return Column(
                      children: [
                        _ResultHeader(
                          searchTerm: term
                        ),
                        const Expanded(child: Center(child: CircularProgressIndicator()))
                      ],
                    );
                  }()),
                LoadedSearchResults(searchResults: final results, searchTerm: final searchTerm) => (() {
                    return Column(
                      children: [
                        _ResultHeader(searchTerm: searchTerm),
                        ListView.builder(
                          itemCount: results.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                              child: _SearchResultItem(results[index]),
                            );
                          },
                        ),
                      ],
                    );
                  }()),
                LoadedMovieList(mostPopularMovies: final popular, topRatedMovies: final topRated) => ListView(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 20),
                            child: fieldTitle(localizations.topRated),
                          ),
                          _MovieListsHorizontalListBuilder(topRated),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, top: 20),
                            child: fieldTitle(localizations.mostPopular),
                          ),
                          _MovieListsHorizontalListBuilder(popular),
                        ],
                      ),
                    ],
                  ),
                HomeMovieListErrorState(exception: final exception) => Center(child: Text(exception.toString())),
              },
            ),
          ),
        ],
      ),
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

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem(this.movieInfo);

  final MovieInfo movieInfo;

  @override
  Widget build(BuildContext context) {
    late String subtitleText;
    final releaseDate = movieInfo.releaseDate;
    if (releaseDate != null) {
      subtitleText = releaseDate.replaceAll('-', '/');
    } else {
      subtitleText = '';
    }
    return ListTile(
      title: Text(movieInfo.title),
      subtitle: Text(
        subtitleText,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Icon(
        Icons.list,
        size: 25,
        color: Colors.grey.shade400,
      ),
      onTap: () => context.push('/movie/${movieInfo.id}'),
    );
  }
}