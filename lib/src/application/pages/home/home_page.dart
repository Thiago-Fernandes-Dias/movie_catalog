import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nil/nil.dart';

import '../../../domain/entities/entities.dart';
import '../../blocs/home_movie_list_cubit/home_movie_list_cubit.dart';
import '../../blocs/search_for_movies_cubit/search_for_movies_cubit.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/effects/shimmer_loading/shimmer_loading.dart';
import '../../widgets/shared/text_format.dart';
import '../../widgets/tmdb.dart';

part 'movie_lists.dart';
part 'result_reader.dart';
part 'search_bar.dart';
part 'search_result.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Catalog'),
        centerTitle: true,
      ),
      body: Shimmer(
        child: Column(
          children: [
            const _SearchBar(),
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
                    return ListView(
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
