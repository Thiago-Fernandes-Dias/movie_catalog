import 'package:flutter/material.dart';
import 'package:movie_list/src/ui/controllers/search_controller.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PageNav extends StatelessWidget {
  final int limit;

  const PageNav({
    required this.limit,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SearchController searchController = Provider.of<SearchController>(
      context,
    );
    final localizations = AppLocalizations.of(context);

    final bool enableBack = searchController.currentPage > 1;
    final bool enableNext = searchController.currentPage < limit;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: enableBack ? searchController.previusPage : null,
            enableFeedback: false,
            splashRadius: 15,
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              semanticLabel: localizations.previousPage,
              color: enableBack ? Colors.grey.shade500 : null,
            ),
            iconSize: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              '${searchController.currentPage}',
              style: TextStyle(
                color: Colors.pink.shade700,
                fontSize: 20,
              ),
            ),
          ),
          IconButton(
            onPressed: enableNext ? searchController.nextPage : null,
            enableFeedback: false,
            splashRadius: 15,
            icon: Icon(
              Icons.arrow_forward_ios_outlined,
              semanticLabel: localizations.nextPage,
              color: enableNext ? Colors.grey.shade500 : null,
            ),
            iconSize: 20,
          ),
        ],
      ),
    );
  }
}