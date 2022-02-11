import 'package:flutter/material.dart';
import 'package:movie_list/src/services/movies_service.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/pages/home_page/home_page.dart';
import 'package:provider/provider.dart';

import 'controllers/search_controller.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      child: MaterialApp(
        theme: ThemeData(
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
        home: const Home(title: 'Movies'),
      ),
    );
  }
}
