part of 'home_page.dart';

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _controller;
  late final SearchForMoviesCubit _searchForMoviesCubit;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _searchForMoviesCubit = context.read();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchForMoviesCubit, SearchForMoviesState>(
      bloc: _searchForMoviesCubit,
      listener: (_, state) {
        if (state is SearchForMoviesIdleState) {
          _controller.clear();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        color: const Color.fromARGB(255, 245, 245, 245),
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              _searchAction(_controller.text);
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
                onPressed: () => _searchAction(_controller.text),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _searchAction(String term) {
    _searchForMoviesCubit.searchMoviesBySearchTerm(term);
  }
}
