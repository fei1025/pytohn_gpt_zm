import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';

class MyAppState extends ChangeNotifier {

  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
  int titleIndex =-1;
  void setTitle(int index){
    titleIndex=index;
    notifyListeners();

  }

}
