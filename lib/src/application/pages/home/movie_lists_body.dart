import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nil/nil.dart';

import '../../../core/env.dart';
import '../../../domain/entities/entities.dart';
import '../../blocs/paginated_movie_lists_bloc/paginated_movie_lists_bloc.dart';
import '../../blocs/paginated_movie_lists_bloc/popular_movies_bloc.dart';
import '../../blocs/paginated_movie_lists_bloc/top_rated_movies_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/effects/shimmer_loading/shimmer_loading.dart';
import '../../widgets/shared/text_format.dart';

class MovieListsBody extends StatefulWidget {
  const MovieListsBody({super.key});

  @override
  State<MovieListsBody> createState() => _MovieListsBodyState();
}

class _MovieListsBodyState extends State<MovieListsBody> {
  late final TopRatedMoviesBloc _topRatedMoviesBloc;
  late final PopularMoviesBloc _popularMoviesBloc;

  @override
  void initState() {
    super.initState();
    _topRatedMoviesBloc = context.read()..add(LoadNextMovieEvent());
    _popularMoviesBloc = context.read()..add(LoadNextMovieEvent());
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Shimmer(
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: fieldTitle(localizations.topRated),
              ),
              BlocBuilder<TopRatedMoviesBloc, PaginatedMovieListsState>(
                bloc: _topRatedMoviesBloc,
                builder: (context, state) {
                  if (state is LoadedMoviesState) return _MovieListsHorizontalListBuilder(state.movies);
                  return const SizedBox();
                },
              ),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: fieldTitle(localizations.mostPopular),
              ),
              BlocBuilder<PopularMoviesBloc, PaginatedMovieListsState>(
                bloc: _popularMoviesBloc,
                builder: (context, state) {
                  if (state is LoadedMoviesState) return _MovieListsHorizontalListBuilder(state.movies);
                  return const SizedBox();
                },
              ),
            ],
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
                  imageUrl: '${env.tmdbImageUrl}${movies[index].posterPath}',
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
