import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/data/repositories/repositories.dart';
import 'package:movie_list/src/ui/blocs/home/home_bloc.dart';
import 'package:movie_list/src/ui/blocs/movie_details/movie_details_bloc.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/routes/routes.dart';
import 'package:movie_list/src/ui/theming/transitions/transitions.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesRepository = MoviesRepositoryImpl();
    final searchRepository = SearchRepositoryImpl();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            return HomeBloc(
              moviesRepository: moviesRepository,
              searchRepository: searchRepository,
            );
          },
        ),
        BlocProvider(
          create: (_) {
            return MovieDetailsBloc(moviesRepository: moviesRepository);
          },
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: FadeInTransition(),
            },
          ),
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.grey.shade900,
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.grey.shade200,
                displayColor: Colors.grey.shade300,
              ),
          iconTheme: IconThemeData(
            color: Colors.grey.shade400,
            opacity: 1.0,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        routeInformationParser: goRouter.routeInformationParser,
        routerDelegate: goRouter.routerDelegate,
      ),
    );
  }
}
