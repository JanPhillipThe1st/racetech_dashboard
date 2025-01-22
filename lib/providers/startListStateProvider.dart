import 'package:flutter/material.dart';
import "package:provider/provider.dart";

class StartListProvider with ChangeNotifier {
  List<Map<String, dynamic>> startList = [];

  void setStartList(List<Map<String, dynamic>> startList) async {
    this.startList = startList;
    notifyListeners();
  }
}
