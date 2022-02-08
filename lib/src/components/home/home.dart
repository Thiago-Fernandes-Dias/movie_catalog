import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movie_list/src/components/controllers/search_controller.dart';

import 'search_box.dart';
import 'search_result.dart';
import 'movie_grids.dart';

class Home extends StatefulWidget {
  final String title;

  Home({Key? key, required this.title}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final SearchController searchController = Provider.of<SearchController>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SearchBox(),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: searchController.currentTerm != ''
                    ? SearchResult()
                    : MovieGrids(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
