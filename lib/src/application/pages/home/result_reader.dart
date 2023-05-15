part of 'home_page.dart';

class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.searchTerm});

  final String searchTerm;

  @override
  Widget build(BuildContext context) {
    final homeMovieListCubit = context.read<HomeMovieListCubit>();
    return WillPopScope(
      onWillPop: () async {
        await homeMovieListCubit.getHomeMovieLists();
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Row(
          children: [
            Expanded(
              child: fieldTitle(
                '${AppLocalizations.of(context).resultsHeader} "$searchTerm"',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: IconButton(
                splashRadius: 15.0,
                onPressed: homeMovieListCubit.getHomeMovieLists,
                icon: const Icon(
                  Icons.clear,
                  color: Colors.red,
                  semanticLabel: 'Cancel search',
                ),
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
