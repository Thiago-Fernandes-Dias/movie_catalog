import 'package:flutter/foundation.dart';

class SearchController extends ChangeNotifier {
  String currentTerm = '';
  int currentPage = 1;

  void nextPage() {
    currentPage++;
    notifyListeners();
  }

  void previusPage() {
    currentPage--;
    notifyListeners();
  }

  void start(String movieTitle) {
    if (currentTerm != movieTitle) currentPage = 1;
    currentTerm = movieTitle;
    notifyListeners();
  }

  void cancel() {
    currentTerm = '';
    notifyListeners();
  }
}
