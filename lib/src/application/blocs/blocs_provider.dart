import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/gateways/gateways.dart';
import '../../data/repositories/repositories.dart';
import 'home_movie_list_cubit/home_movie_list_cubit.dart';
import 'movie_details/movie_details_cubit.dart';
import 'search_for_movies_cubit/search_for_movies_cubit.dart';

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tmdbClient = TMDBRestApiClientImpl();   
    final searchRepository = SearchRepositoryImpl(tmdbClient);
    final moviesRepository = MoviesRepositoryImpl(tmdbClient);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeMovieListCubit>(
          create: (_) {
            return HomeMovieListCubitImpl(moviesRepository);
          }
        ),
        BlocProvider<MovieDetailsCubit>(
          create: (_) {
            return MovieDetailsCubitImpl(moviesRepository);
          },
        ),
        BlocProvider<SearchForMoviesCubit>(
          create: (_) {
            return SearchForMoviesCubitImpl(searchRepository);
          },
        ),
      ],
      child: child,
    );
  }
}