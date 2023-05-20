part of 'routes.dart';

Widget _homePageBuilder(BuildContext context, GoRouterState state) {
  return const HomePage();
}

Widget _movieDetailsPageBuilder(BuildContext context, GoRouterState state) {
  var movieId = state.pathParameters['id'] as String;
  return MovieDetailsPage(movieId);
}
