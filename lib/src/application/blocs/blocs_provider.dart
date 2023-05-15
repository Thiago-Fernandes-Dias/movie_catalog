import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../data/gateways/gateways.dart';
import '../../data/repositories/repositories.dart';
import 'home_movie_list_cubit/home_movie_list_cubit.dart';
import 'internet_connection_cubit/internet_connection_cubit.dart';
import 'movie_details/movie_details_cubit.dart';

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final internetConnectivityChecker = InternetConnectionCheckerPlus();
    final connectivity = Connectivity();
    final tmdbClient = TMDBRestApiClientImpl(
      connectivity: connectivity,
      internetConnectionChecker: internetConnectivityChecker,
    );
    final searchRepository = SearchRepositoryImpl(tmdbClient);
    final moviesRepository = MoviesRepositoryImpl(tmdbClient);

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeMovieListCubit>(create: (_) {
          return HomeMovieListCubitImpl(moviesRepository, searchRepository);
        }),
        BlocProvider<MovieDetailsCubit>(
          create: (_) {
            return MovieDetailsCubitImpl(moviesRepository);
          },
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
