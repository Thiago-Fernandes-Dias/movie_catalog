import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_list/src/application/blocs/home_movie_list_cubit/home_movie_list_cubit.dart';
import 'package:movie_list/src/application/blocs/search_for_movies_cubit/search_for_movies_cubit.dart';
import 'package:movie_list/src/application/ui/effects/shimmer_loading/shimmer_loading.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/application/l10n/app_localizations.dart';
import 'package:movie_list/src/application/widgets/search_box.dart';
import 'package:movie_list/src/application/widgets/shared/text_format.dart';
import 'package:movie_list/src/application/widgets/tmdb.dart';
import 'package:nil/nil.dart';

part 'movie_lists.dart';
part 'result_reader.dart';
part 'search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeMovieListCubit _homeMovieListCubit;
  late final SearchForMoviesCubit _searchForMoviesCubit;
  @override

  void initState() {
    super.initState();
    _homeMovieListCubit = context.read()..getHomeMovieLists();
    _searchForMoviesCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Catalog'),
        centerTitle: true,
      ),
      body: Shimmer(
        linearGradient: _shimmerGradient,
        child: Column(
          children: [
            SearchBar(
              onSearch: (text) {
                _searchForMoviesCubit.searchMoviesBySearchTerm(text);
              },
            ),
            Expanded(
              child: BlocBuilder<SearchForMoviesCubit, SearchForMoviesState>(
                builder: (_, state) {
                  if (state is SearchForMoviesIdleState) {
                    return const _MovieLists();
                  } else if (state is LoadingSearchResult) {
                    return Column(
                      children: const [
                        _ResultHeader(),
                        Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      ],
                    );
                  } else if (state is LoadedSearchResult) {
                    return Column(
                      children: const [
                        _ResultHeader(),
                        Expanded(child: _SearchResult())
                      ],
                    );
                  }
                  return nil;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
