import 'package:flutter/material.dart';

class PageIndex with ChangeNotifier {
  int _index = 0;

  int get pageIndex {
    return _index.toInt();
  }

  void setPageIndex(int index) {
    _index = index;
    notifyListeners();
  }
}
