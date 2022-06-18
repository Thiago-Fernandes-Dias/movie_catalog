import 'package:flutter/material.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/ui/pages/movie_details/movie_details_page.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({
    Key? key,
    required this.movieList,
  }) : super(key: key);

  final List<MovieInfo> movieList;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
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
      onTap: () => Navigator.of(context).push(showMovieInfo(movie)),
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
