import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/application/blocs/home_movie_list_cubit/home_movie_list_cubit.dart';
import 'package:movie_list/src/application/blocs/movie_details/movie_details_cubit.dart';
import 'package:movie_list/src/application/blocs/search_for_movies_cubit/search_for_movies_cubit.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';

class BlocsProvider extends StatelessWidget {
  const BlocsProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final searchRepository = SearchRepositoryImpl();
    final moviesRepository = MoviesRepositoryImpl();
    
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