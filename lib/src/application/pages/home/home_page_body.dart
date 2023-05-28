part of 'home_page.dart';

class HomePageBody extends StatefulWidget {
  const HomePageBody({super.key});

  @override
  State<HomePageBody> createState() => _HomePageBodyState();
}

class _HomePageBodyState extends State<HomePageBody> {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: [
          const SearchBar(),
          Expanded(
            child: BlocBuilder<SearchForMoviesBloc, SearchForMoviesState>(
              builder: (context, state) {
                return switch (state) {
                  SearchForMoviesInitial() => const MovieListsBody(),
                  LoadingSearchResults(searchTerm: final searchTerm) => (() {
                      return Column(
                        children: [
                          ResultHeader(searchTerm: searchTerm),
                          const Expanded(child: Center(child: CircularProgressIndicator())),
                        ],
                      );
                    })(),
                  LoadedSearchResults(movieList: final movieList, searchTermUsed: final searchTermUsed) => (() {
                      final movies = movieList.results;
                      return ListView(
                        children: [
                          ResultHeader(searchTerm: searchTermUsed),
                          ListView.builder(
                            itemCount: movies.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                child: _SearchResultItem(movies[index]),
                              );
                            },
                          ),
                        ],
                      );
                    }()),
                  LoadingSearchResultsError() => Container(),
                };
              },
            ),
          ),
        ],
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
