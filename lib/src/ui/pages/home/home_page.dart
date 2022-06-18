import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/ui/pages/home/bloc/home_bloc.dart';
import 'package:movie_list/src/ui/pages/home/components/movie_lists.dart';
import 'package:movie_list/src/ui/pages/home/components/result_reader.dart';
import 'package:movie_list/src/ui/pages/home/components/search_result.dart';
import 'package:movie_list/src/ui/widgets/page_nav.dart';
import 'package:movie_list/src/ui/widgets/search_box.dart';

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
                  return MovieLists(
                    mostPopularMovies: state.mostPopular.results,
                    topRatedMovies: state.topRated.results,
                  );
                } else if (state is LoadingSearchResult) {
                  return Column(
                    children: [
                      ResultHeader(searchTerm: state.searchTerm),
                      const Expanded(child: Center(child: CircularProgressIndicator()))
                    ],
                  );
                } else if (state is FetchedSearchResult) {
                  return ListView(
                    children: [
                      ResultHeader(searchTerm: state.searchTerm),
                      SearchResult(movieList: state.searchResult.results),
                      PageNav(limit: state.searchResult.totalPages),
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
