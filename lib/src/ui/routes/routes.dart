import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_list/src/ui/pages/home/home_page.dart';

part 'builders.dart';

final goRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: _homePageBuilder,
  ),
]);
