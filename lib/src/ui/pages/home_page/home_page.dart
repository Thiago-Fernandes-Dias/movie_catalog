import 'package:flutter/material.dart';
import 'package:movie_list/src/ui/controllers/search_controller.dart';
import 'package:provider/provider.dart';

import '../../widgets/search_box.dart';
import 'movie_lists.dart';
import 'search_result.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var searchController = Provider.of<SearchController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies Catalog'),
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
                    : const MovieLists(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
