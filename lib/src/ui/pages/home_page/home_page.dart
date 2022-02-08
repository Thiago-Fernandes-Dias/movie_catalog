import 'package:flutter/material.dart';
import 'package:movie_list/src/controllers/search_controller.dart';
import 'package:provider/provider.dart';

import '../../widgets/search_box.dart';
import 'movie_grids.dart';
import 'search_result.dart';

class Home extends StatefulWidget {
  final String title;

  const Home({Key? key, required this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final SearchController searchController =
        Provider.of<SearchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SearchBar(),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: searchController.currentTerm != ''
                    ? const SearchResult()
                    : const MovieGrids(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
