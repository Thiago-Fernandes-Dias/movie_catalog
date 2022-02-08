import 'package:flutter/material.dart';
import 'package:movie_list/l10n/generated/app_localizations.dart';
import 'package:movie_list/src/components/controllers/search_controller.dart';
import 'package:movie_list/src/components/movie/movie_view.dart';
import 'package:movie_list/src/models/movie_info.dart';
import 'package:movie_list/src/models/movie_list.dart';
import 'package:movie_list/src/services/movies_service.dart';
import 'package:movie_list/src/shared/network_loading.dart' as net;
import 'package:movie_list/src/shared/text_format.dart' as text;
import 'package:provider/provider.dart';

import 'page_nav.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({
    Key? key,
  }) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  Widget _buildResultsItem(MovieInfo movie) {
    return ListTile(
      title: Text('${movie.title}'),
      subtitle: Text(
        movie.releaseDate!.substring(0, 4),
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Icon(
        Icons.list,
        size: 25,
        color: Colors.grey.shade400,
      ),
      onTap: () => Navigator.of(context).push(showMovieInfo(movie)),
    );
  }

  ListView _buildResultsList(List<MovieInfo?> results) {
    return ListView.builder(
      itemCount: results.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, i) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
          child: _buildResultsItem(results[i]!),
        );
      },
    );
  }

  Widget _showResults(SearchController searchController) {
    final MoviesService moviesService = Provider.of<MoviesService>(context);

    return FutureBuilder<MovieList>(
      future: moviesService.fetchMoviesByTitle(
        searchController.currentTerm,
        searchController.currentPage,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return net.loadingArea();
        } else if (snapshot.hasData && snapshot.data!.results.length > 0) {
          return Column(
            children: [
              _buildResultsList(snapshot.data!.results),
              PageNav(limit: snapshot.data!.totalPages),
            ],
          );
        } else if (snapshot.hasError) {
          return text.showMessage('Something unexpected has occurred', true);
        }

        return text.showMessage('No results for your search. Sorry...', false);
      },
    );
  }

  Widget _searchHeader(SearchController searchController) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: [
          Expanded(
            child: text.fieldTitle(
              AppLocalizations.of(context)!.resultsHeader + "${searchController.currentTerm}",
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: IconButton(
              splashRadius: 15.0,
              onPressed: searchController.cancel,
              icon: Icon(
                Icons.clear,
                color: Colors.red,
                semanticLabel: 'Cancel search',
              ),
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchResultBuilder(
    BuildContext context,
    SearchController searchController,
    Widget? widget,
  ) {
    return Column(
      children: [
        _searchHeader(searchController),
        _showResults(searchController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchController>(
      builder: _searchResultBuilder,
    );
  }
}
