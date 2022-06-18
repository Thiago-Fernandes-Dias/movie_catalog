import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:movie_list/src/ui/pages/home/bloc/home_bloc.dart';
import 'package:movie_list/src/ui/widgets/shared/text_format.dart' as text;

class ResultHeader extends StatefulWidget {
  const ResultHeader({ Key? key, required this.searchTerm}) : super(key: key);

  final String searchTerm;

  @override
  State<ResultHeader> createState() => _ResultHeaderState();
}

class _ResultHeaderState extends State<ResultHeader> {
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
            child: text.fieldTitle(
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
