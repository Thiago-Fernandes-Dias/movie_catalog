import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_list/src/ui/pages/home/home_page.dart';
import 'package:movie_list/src/ui/pages/movie_details/movie_details_page.dart';

part 'builders.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: _homePageBuilder,
    ),
    GoRoute(
      path: '/movie/:id',
      builder: _movieDetailsPageBuilder,
    ),
  ],
);
