import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';

import 'model/Chat_hist_list.dart';

class MyAppState extends ChangeNotifier {

  bool isDarkMode = false;
  // 是否选中选择框
  bool isIconVisible = false;
  void setIsIconVisible(bool icon){
    isIconVisible=icon;
    notifyListeners();
  }


  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
  int titleIndex =-1;
  void setTitle(int index){
    titleIndex=index;
    notifyListeners();

  }

  int? cuChatId;
  void setCuChatId(int id){
    cuChatId=id;
    notifyListeners();
  }

  List<ChatHist> chatHistList = [];
  void setChatHistList( List<ChatHist> list ){
    chatHistList=list;
    notifyListeners();
  }
}
