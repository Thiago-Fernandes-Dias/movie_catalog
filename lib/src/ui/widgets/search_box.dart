import 'package:flutter/material.dart';
import 'package:movie_list/src/ui/l10n/app_localizations.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.onSearch,
  });

  final void Function(String) onSearch;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      color: const Color.fromARGB(255, 245, 245, 245),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) widget.onSearch(_controller.text);
        },
        child: TextField(
          controller: _controller,
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
              onPressed: () => widget.onSearch(_controller.text),
            ),
          ),
        ),
      ),
    );
  }
}
