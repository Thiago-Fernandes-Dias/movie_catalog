import 'package:flutter/material.dart';
import 'package:movie_list/src/controllers/search_controller.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController inputController = TextEditingController();
    final SearchController searchController = Provider.of<SearchController>(
      context,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      color: const Color(0xff0c0c0c),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) searchController.start(inputController.text);
        },
        child: TextField(
          controller: inputController,
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: AppLocalizations.of(context).sbHint,
            hintStyle: TextStyle(color: Colors.grey.shade800),
            contentPadding: const EdgeInsets.only(left: 10, top: 15),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.search,
                color: Colors.grey,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
              onPressed: () => searchController.start(inputController.text),
            ),
          ),
        ),
      ),
    );
  }
}
