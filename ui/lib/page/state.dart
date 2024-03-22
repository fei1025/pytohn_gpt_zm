import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_ui/page/model/Chat_model.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';

import 'model/ChatDetails.dart';
import 'model/Chat_hist_list.dart';

class MyAppState extends ChangeNotifier {
  static final MyAppState _instance = MyAppState._internal();

  factory MyAppState() {
    return _instance;
  }
  Map<int,String> indexType = {};
  Map<String, Widget> iconMap = {};
  // 根据选择的数据,判断要加载哪批数据
  MyAppState._internal(){
    indexType.addAll({
      0: '0',
      1: '1',
      2:"2"
    });
    iconMap["wolfram_alpha"] = Image.asset('assets/images/wolframa.png',height: 20,width: 20,);
    iconMap["Python_REPL"] = Image.asset('assets/images/python.png',height: 20,width: 20,);
    iconMap["arxiv"] = Image.asset('assets/images/arxiv.png',height: 20,width: 20,);
    iconMap["wikipedia"] = Image.asset('assets/images/wikipedia.png',height: 20,width: 20,);
    iconMap["ddg"] = Image.asset('assets/images/DDG.png',height: 20,width: 20,);
    //iconMap["llm-math"] = Image.asset('assets/images/llmmath.png',height: 20,width: 20,);
    iconMap["open-meteo-api"] = Image.asset('assets/images/meteo.png',height: 20,width: 20,);
  }

  String? getValueByKey(int key) {
    return indexType[key];
  }


  int curSelectedIndex=0;

  void setCurSelectedIndex(int select){
    curSelectedIndex=select;
    notifyListeners();
  }

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
  ChatHist? cuChatHist;
  void setCuChatHist(ChatHist? chatHist){
    cuChatHist=chatHist;
    notifyListeners();
  }

  void setCuChatHistTools(String tools){
    cuChatHist?.tools=tools;
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
  // 知识库信息数据
  int knowledgeIndex = -1;
  void setKnowledgeIndex(int index) {
    knowledgeIndex = index;
    notifyListeners();
  }
  String knowledgeTitle="";
  void setKnowledgeTitle(String s){
    knowledgeTitle=s;
    notifyListeners();
  }
  String cuKnowledgeModel = "0";

  List<ChatHist> knowledgeHistList = [];
  void setKnowledgeHistList(List<ChatHist> list) {
    knowledgeHistList = list;
    notifyListeners();
  }
  List<KnowledgeInfo> knowledgeList =[];

  void setKnowledgeList(List<KnowledgeInfo> list) {
    knowledgeList = list;
    notifyListeners();
  }


}
