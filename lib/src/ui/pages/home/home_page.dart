import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/ui/blocs/home/home_bloc.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/widgets/page_nav.dart';
import 'package:movie_list/src/ui/widgets/search_box.dart';
import 'package:movie_list/src/ui/widgets/shared/text_format.dart';
import 'package:movie_list/src/ui/widgets/tmdb.dart';

part 'movie_lists.dart';
part 'result_reader.dart';
part 'search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeBloc _homeBloc;
  @override

  void initState() {
    super.initState();
    _homeBloc = context.read<HomeBloc>()..add(GetMovieLists());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Catalog'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SearchBar(
            onSearch: (text) => _homeBloc.add(SearchMovies(searchTerm: text)),
          ),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (_, state) {
                if (state is LoadingMovieLists) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is FechedMovieLists) {
                  return _MovieLists(
                    mostPopularMovies: state.mostPopular!.results,
                    topRatedMovies: state.topRated!.results,
                  );
                } else if (state is LoadingSearchResult) {
                  return Column(
                    children: [
                      _ResultHeader(searchTerm: state.searchTerm!),
                      const Expanded(child: Center(child: CircularProgressIndicator()))
                    ],
                  );
                } else if (state is FetchedSearchResult) {
                  return ListView(
                    children: [
                      _ResultHeader(searchTerm: state.searchTerm!),
                      _SearchResult(movieList: state.searchResult!.results),
                      PageNav(limit: state.searchResult!.totalPages),
                    ],
                  );
                }
                var errorState = state as HomeErrorState;
                return Center(child: Text(errorState.error.toString()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
