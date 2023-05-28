part of 'home_page.dart';

@visibleForTesting
class ResultHeader extends StatefulWidget {
  const ResultHeader({required this.searchTerm, super.key});

  final String searchTerm;

  @override
  State<ResultHeader> createState() => _ResultHeaderState();
}

class _ResultHeaderState extends State<ResultHeader> {
  late final SearchForMoviesBloc _searchForMoviesBloc;

  @override
  void initState() {
    super.initState();
    _searchForMoviesBloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _cancelSearch();
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Row(
          children: [
            Expanded(
              child: fieldTitle(
                '${AppLocalizations.of(context).resultsHeader} "${widget.searchTerm}"',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: IconButton(
                splashRadius: 15.0,
                onPressed: _cancelSearch,
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

  void _cancelSearch() {
    _searchForMoviesBloc.add(CancelSearch());
  }
}
