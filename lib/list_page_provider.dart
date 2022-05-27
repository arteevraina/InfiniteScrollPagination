import 'dart:collection';

import 'package:flutter/material.dart';

class ListPageProvider extends ChangeNotifier {
  final List<String> _items = [];
  UnmodifiableListView get items => UnmodifiableListView(_items);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  void fetchItems() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 3));

    int initialIndex = _items.length;

    _items.addAll(List.generate(20, (index) => "Item ${index + initialIndex}"));

    _isLoading = false;
    notifyListeners();
  }
}
