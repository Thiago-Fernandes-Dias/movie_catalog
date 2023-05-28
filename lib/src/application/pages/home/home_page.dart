import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/entities.dart';
import '../../blocs/search_for_movies_bloc/search_for_movies_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../ui/effects/shimmer_loading/shimmer_loading.dart';
import '../../widgets/shared/text_format.dart';
import 'movie_lists_body.dart';

part 'home_page_body.dart';
part 'result_reader.dart';
part 'search_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Catalog'),
        centerTitle: true,
      ),
      body: const HomePageBody(),
    );
  }
}
