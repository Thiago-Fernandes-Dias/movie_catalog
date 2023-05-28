part of 'home_page.dart';

@visibleForTesting
class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late final TextEditingController _controller;
  late final SearchForMoviesBloc _searchForMoviesBloc;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _searchForMoviesBloc = context.read();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchForMoviesBloc, SearchForMoviesState>(
      listener: (_, state) {
        if (state is SearchForMoviesInitial) _controller.clear();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        color: const Color.fromARGB(255, 245, 245, 245),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _searchForMovies(_controller.text);
            }
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
                onPressed: () => _searchForMovies(_controller.text),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _searchForMovies(String term) {
    _searchForMoviesBloc.add(SearchForMoviesByName(searchTerm: term));
  }
}
