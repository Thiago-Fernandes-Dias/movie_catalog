import 'package:flutter/material.dart';
import 'package:movie_list/l10n/generated/app_localizations.dart';
import 'package:movie_list/src/components/controllers/search_controller.dart';
import 'package:provider/provider.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController inputController = TextEditingController();
    final SearchController searchController = Provider.of<SearchController>(
      context,
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      color: Color(0xff0c0c0c),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) searchController.start(inputController.text);
        },
        child: TextField(
          controller: inputController,
          decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            hintText: AppLocalizations.of(context)!.sbHint,
            hintStyle: TextStyle(color: Colors.grey.shade800),
            contentPadding: EdgeInsets.only(left: 10, top: 15),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              padding: EdgeInsets.symmetric(
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
