part of 'home_page.dart';

class _ResultHeader extends StatefulWidget {
  const _ResultHeader();

  @override
  State<_ResultHeader> createState() => _ResultHeaderState();
}

class _ResultHeaderState extends State<_ResultHeader> {
  late final SearchForMoviesCubit _searchForMoviesCubit;

  @override
  void initState() {
    super.initState();
    _searchForMoviesCubit = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchForMoviesCubit, SearchForMoviesState>(
      builder: (context, state) {
        if (!state.searching) {
          return nil;
        }
        final searchTerm = state.searchTerm!;
        return WillPopScope(
          onWillPop: () async {
            _searchForMoviesCubit.cancelSearch();
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
                    onPressed: _searchForMoviesCubit.cancelSearch,
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
    );
  }
}
