import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier {
  String url = "https://www.google.com/";
  int progressLine = 0;
  TextEditingController txtSearch = TextEditingController();

  void changeUrl(String link) {
    url = link;
    notifyListeners();
  }

  void progressBar(int progress) {
    progressLine = progress;
    notifyListeners();
  }
}
