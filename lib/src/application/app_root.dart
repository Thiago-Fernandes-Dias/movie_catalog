import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/application/blocs/home_movie_list_cubit/home_movie_list_cubit.dart';
import 'package:movie_list/src/application/blocs/search_for_movies_cubit/search_for_movies_cubit.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/application/blocs/movie_details/movie_details_bloc.dart';
import 'package:movie_list/src/application/l10n/app_localizations.dart';
import 'package:movie_list/src/application/routes/routes.dart';
import 'package:movie_list/src/application/theming/transitions/transitions.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesRepository = MoviesRepositoryImpl();
    final searchRepository = SearchRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeMovieListCubit>(
          create: (_) {
            return HomeMovieListCubitImpl(moviesRepository);
          }
        ),
        BlocProvider<MovieDetailsBloc>(
          create: (_) {
            return MovieDetailsBloc(moviesRepository: moviesRepository);
          },
        ),
        BlocProvider<SearchForMoviesCubit>(
          create: (_) {
            return SearchForMoviesCubitImpl(searchRepository);
          },
        )
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeInTransition(),
            },
          ),
          primarySwatch: Colors.pink,
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
        routerDelegate: goRouter.routerDelegate,
      ),
    );
  }
}
