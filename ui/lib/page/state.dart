import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_ui/page/model/Chat_model.dart';

import 'model/ChatDetails.dart';
import 'model/Chat_hist_list.dart';

class MyAppState extends ChangeNotifier {
  static final MyAppState _instance = MyAppState._internal();

  factory MyAppState() {
    return _instance;
  }

  MyAppState._internal();

  bool isDarkMode = false;

  // 是否选中选择框
  bool isIconVisible = false;

  void setIsIconVisible(bool icon) {
    isIconVisible = icon;
    notifyListeners();
  }

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }
  bool isAlway = false;

  void setIsAlway(bool alway){
    isAlway=alway;
    notifyListeners();
  }


  int titleIndex = -1;

  void setTitle(int index) {
    titleIndex = index;
    notifyListeners();
  }

  int? cuChatId;

  void setCuChatId(int? id) {
    cuChatId = id;
    notifyListeners();
  }

  List<ChatHist> chatHistList = [];

  void setChatHistList(List<ChatHist> list) {
    chatHistList = list;
    notifyListeners();
  }

  List<ChatDetails> chatDetailsList = [];

  void setChatDetails(List<ChatDetails> list) {
    chatDetailsList = list;
    notifyListeners();
  }

  //设置是否要写人
  bool isSend = false;

  void setIsSend(bool l) {
    isSend = l;
    notifyListeners();
  }

  // 查询出来的数据
  List<ChatModel> chatModelList = [];

  void setChatModel(List<ChatModel> list) {
    chatModelList = list;
    notifyListeners();
  }

  //当前选择的model
  String cuModel = "0";

  void setCuMode(String s) {
    cuModel = s;
    notifyListeners();
  }

  // 当前标题
  String cuTitle = "";
  void setCuTitle(String s) {
    cuTitle = s;
    notifyListeners();
  }

  String subhead = "";

  void setSubhead(String s) {
    subhead = s;
    notifyListeners();
  }
}
