import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_page/home_page.dart';

part 'builders.dart';

final goRouter = GoRouter(routes: [
  GoRoute(
    path: '/',
    builder: _homePageBuilder,
  ),
]);
