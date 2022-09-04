part of 'home_page.dart';

class _ResultHeader extends StatefulWidget {
  const _ResultHeader({ Key? key, required this.searchTerm}) : super(key: key);

  final String searchTerm;

  @override
  State<_ResultHeader> createState() => _ResultHeaderState();
}

class _ResultHeaderState extends State<_ResultHeader> {
  late final HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Row(
        children: [
          Expanded(
            child: fieldTitle(
              AppLocalizations.of(context).resultsHeader + widget.searchTerm,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: IconButton(
              splashRadius: 15.0,
              onPressed: () => _homeBloc.add(GetMovieLists()),
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
    );
  }
}
