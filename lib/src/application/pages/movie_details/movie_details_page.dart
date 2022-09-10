import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_list/src/core/env.dart';
import 'package:movie_list/src/domain/entities/entities.dart';
import 'package:movie_list/src/application/blocs/movie_details/movie_details_cubit.dart';
import 'package:movie_list/src/application/l10n/app_localizations.dart';
import 'package:movie_list/src/application/widgets/shared/network_loading.dart';
import 'package:movie_list/src/application/widgets/shared/text_format.dart';
import 'package:movie_list/src/application/widgets/tmdb.dart';
import 'package:nil/nil.dart';

part 'movie_fields.dart';
part 'credit_fields.dart';

class MovieDetailsPage extends StatefulWidget {
  const MovieDetailsPage(this.movieId, {super.key});

  final String movieId;

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  late final MovieDetailsCubit movieDetailsCubit;
  late final AppLocalizations localizations;

  @override
  void initState() {
    super.initState();
    movieDetailsCubit = context.read()..fetchMovieDetails(widget.movieId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    localizations = AppLocalizations.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.movieInfo),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          splashRadius: 15.0,
          onPressed: () => context.go('/'),
        ),
      ),
      body: BlocBuilder<MovieDetailsCubit, MovieDetailsState>(
        bloc: movieDetailsCubit,
        builder: (context, state) {
          if (state is LoadingMovieDetails) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadedMovieDetails) {
            var movie = state.movieDetails!;
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width >= 650 
                    ? 200 
                    : 0,
              ),
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: Text(
                    movie.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  height: MediaQuery.of(context).size.height * .6,
                  child: CachedNetworkImage(
                    imageUrl: '${env.tmdbImageUrl}${movie.posterPath}',
                    fit: BoxFit.contain,
                    errorWidget: (_, __, ___) {
                      return Image.asset(
                        'assets/jpg/noposter.jpg',
                        fit: BoxFit.fitHeight,
                      );
                    },
                  ),
                ),
                _MovieFields(),
                const CreditsFields(),
              ],
            );
          } else if (state is MovieDetailsErrorState) {
            return Center(child: Text(state.error.toString()));
          }
          return nil;
        },
      ),
      bottomSheet: Container(
        color: const Color(0xff0d0d0d),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                localizations.footer,
                style: TextStyle(
                  color: Colors.grey.shade200,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: SvgPicture.asset(
                'assets/svg/tmdb_logo.svg',
                fit: BoxFit.fitHeight,
                height: 20,
                color: Colors.cyan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
