part of 'movie_details_page.dart';

class CreditsFields extends StatelessWidget {
  const CreditsFields({super.key});

  @override
  Widget build(BuildContext context) {
    var casts = context.read<MovieDetailsBloc>().state.movieCredits!.cast;

    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 20, bottom: 40),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          fieldTitle(AppLocalizations.of(context).cast),
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width >= 650 
                    ? 3 
                    : 1,
                mainAxisSpacing: 20,
                mainAxisExtent: 150,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: casts.length,
              itemBuilder: (context, i) => _CastTile(cast: casts[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CastTile extends StatelessWidget {
  const _CastTile({required this.cast});

  final Cast cast;

  @override
  Widget build(BuildContext context) {
    var itemHeight = MediaQuery.of(context).size.height * .2;
    const itemPadding = EdgeInsets.symmetric(
      horizontal: 6,
      vertical: 6,
    );
    const castName = TextStyle(
      fontSize: 16,
    );
    var castCharacter = TextStyle(
      color: Colors.grey.shade600,
    );

    return Row(
      children: [
        Container(
          padding: itemPadding,
          height: itemHeight,
          width: 95,
          child: fetchImage(
            url: '$baseImagesUrl/${cast.profilePath}',
            assetOption: 'assets/jpg/noprofile.jpg',
          ),
        ),
        Expanded(
          child: Container(
            padding: itemPadding,
            height: itemHeight,
            alignment: Alignment.centerLeft,
            child: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: '${cast.name}\n',
                style: castName,
                children: [
                  TextSpan(
                    text: cast.character != ''
                        ? cast.character
                        : AppLocalizations.of(context).gest,
                    style: castCharacter,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
