part of 'home_page.dart';

class _SearchResult extends StatefulWidget {
  const _SearchResult({
    Key? key,
    required this.movieList,
  }) : super(key: key);

  final List<MovieInfo> movieList;

  @override
  State<_SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<_SearchResult> {
  Widget _buildResultsItem(MovieInfo movie) {
    return ListTile(
      title: Text(movie.title),
      subtitle: Text(
        movie.releaseDate!.substring(0, 4),
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Icon(
        Icons.list,
        size: 25,
        color: Colors.grey.shade400,
      ),
      onTap: () => context.go('/movies/${movie.id}'),
    );
  }

  ListView _buildResultsList(List<MovieInfo> results) {
    return ListView.builder(
      itemCount: results.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: _buildResultsItem(results[i]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildResultsList(widget.movieList);
  }
}
