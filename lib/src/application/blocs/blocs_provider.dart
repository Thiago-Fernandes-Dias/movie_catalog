import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/gateways/gateways.dart';
import '../../data/repositories/repositories.dart';
import 'internet_connection_cubit/internet_connection_cubit.dart';
import 'movie_details/movie_details_cubit.dart';
import 'paginated_movie_lists_bloc/popular_movies_bloc.dart';
import 'paginated_movie_lists_bloc/top_rated_movies_bloc.dart';
import 'search_for_movies_bloc/search_for_movies_bloc.dart';

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final internetConnectivityChecker = InternetConnectionCheckerPlus();
    final connectivity = Connectivity();
    final tmdbClient = TMDBRestApiClientImpl(
      internetConnectionChecker: internetConnectivityChecker,
    );
    final searchRepository = SearchRepositoryImpl(tmdbClient);
    final moviesRepository = MoviesRepositoryImpl(tmdbClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider<SearchForMoviesBloc>(create: (_) => SearchForMoviesBlocImpl(searchRepository)),
        BlocProvider<PopularMoviesBloc>(create: (_) => PopularMoviesBloc(moviesRepository)),
        BlocProvider<TopRatedMoviesBloc>(create: (_) => TopRatedMoviesBloc(moviesRepository)),
        BlocProvider<MovieDetailsCubit>(
          create: (_) => MovieDetailsCubitImpl(moviesRepository),
        ),
        BlocProvider<InternetConnectionCubit>(
          create: (_) {
            return InternetConnectionCubitImpl(
              connectivity: connectivity,
              internetConnectionChecker: internetConnectivityChecker,
            );
          },
        ),
      ],
      child: child,
    );
  }
}
