import 'package:flutter/material.dart';
import 'package:movie_list/src/domain/services/movies_service.dart';
import 'package:movie_list/src/ui/controllers/search_controller.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/routes/routes.dart';
import 'package:movie_list/src/ui/theming/transitions/transitions.dart';
import 'package:provider/provider.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<MoviesService>.value(
          value: MoviesService(),
        ),
        ChangeNotifierProvider<SearchController>.value(
          value: SearchController(),
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
