import 'package:flutter/material.dart';

import 'blocs/blocs_provider.dart';
import 'l10n/app_localizations.dart';
import 'routes/routes.dart';
import 'ui/transitions/transitions.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocsProvider(
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
