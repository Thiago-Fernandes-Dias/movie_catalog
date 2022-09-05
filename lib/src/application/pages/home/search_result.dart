part of 'home_page.dart';

class _SearchResult extends StatefulWidget {
  const _SearchResult();

  @override
  State<_SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<_SearchResult> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchForMoviesCubit, SearchForMoviesState>(
      builder: (context, state) {
        if (!state.searching) {
          return nil;
        }
        final searchResult = state.searchResult!;
        final results = searchResult.results;
        return ListView.builder(
          itemCount: results.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              child: _SearchResultItem(results[index]),
            );
          },
        );
      }
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem(this.movieInfo);

  final MovieInfo movieInfo;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(movieInfo.title),
      subtitle: Text(
        movieInfo.releaseDate!.substring(0, 4),
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Icon(
        Icons.list,
        size: 25,
        color: Colors.grey.shade400,
      ),
      onTap: () => context.go('/movies/${movieInfo.id}'),
    );
  }
}


