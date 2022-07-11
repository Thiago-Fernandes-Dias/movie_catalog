part of 'movie_details_page.dart';

class _MovieFields extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var movie = context.read<MovieDetailsBloc>().state.movieDetails!;
    var localization = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          fieldTitle(localization.about),
          _MovieData(fieldName: localization.title, info: movie.originalTitle),
          _MovieData(
            fieldName: localization.lang,
            info: movie.originalLanguage,
          ),
          _MovieData(fieldName: localization.overview, info: validate(movie.overview)),
          _MovieData(
            fieldName: localization.genres,
            info: movie.genres.isNotEmpty
                ? movie.genres.map((item) => item.name).join(', ')
                : localization.notFount,
          ),
          _MovieData(
            fieldName: localization.comps,
            info: movie.companies.isNotEmpty
                ? movie.companies.map((item) => item.name).join(', ')
                : localization.notFount,
          ),
          _MovieData(fieldName: localization.release, info: movie.releaseDate ?? ''),
          _MovieData(fieldName: localization.votes, info: validate('${movie.voteCount}')),
          _MovieData(fieldName: localization.rate, info: validate('${movie.voteAverage}')),
          _MovieData(fieldName: localization.status, info: movie.status.toString()),
        ],
      ),
    );
  }
}

class _MovieData extends StatelessWidget {
  const _MovieData({
    required this.fieldName,
    required this.info,
  });

  final String fieldName;
  final String info;

  @override
  Widget build(BuildContext context) {
    const movieField = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    const movieInfo = TextStyle(
      fontWeight: FontWeight.w300,
    );

    return Container(
      padding: const EdgeInsets.only(top: 10),
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.justify,
        text: TextSpan(
          text: '$fieldName: ',
          style: movieField,
          children: [
            TextSpan(
              text: info,
              style: movieInfo,
            ),
          ],
        ),
      ),
    );
  }
}