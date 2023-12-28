import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:open_ui/page/api/http_utils.dart';
import 'package:open_ui/page/model/ChatDetails.dart';
import 'package:open_ui/page/model/Chat_model.dart';
import 'package:open_ui/page/state.dart';

import '../model/Chat_hist_list.dart';

class ApiService {
  //static const String _baseUrl = 'http://127.0.0.1:9011/';
  static const String _baseUrl = 'http://127.0.0.1:6688';

  static String getOpenBaseUrl() {
    return _baseUrl;
  }

  static Future<List<ChatHist>> getAllHist() async {
    final response = await httpUtils.get('$_baseUrl/getAllHist');
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> jsonMap = json.decode(responseBody);
      ChatHistList apiData = ChatHistList.fromJson(jsonMap);
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<ChatDetails>> getChatDetails(int? chatId) async {
    final response =
        await httpUtils.get('$_baseUrl/getChatHistDetails?chatId=$chatId');
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);
      Map<String, dynamic> jsonMap = json.decode(responseBody);
      ChatDetailsList apiData = ChatDetailsList.fromJson(jsonMap);
      // 访问映射后的数据
      print('Code: ${apiData.code}, Msg: ${apiData.msg},data${apiData.data}');
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<ChatHist>> saveChatHist(String msg) async {
    final response = await httpUtils.post(
        '$_baseUrl/save_chat_hist', json.encode({'content': msg}), null);
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> jsonMap = json.decode(responseBody);
      ChatHistList apiData = ChatHistList.fromJson(jsonMap);
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static void senMsg(String msg, Function()? onComplete) async {
    const apiUrl = "$_baseUrl/send_open_ai";
    int? cuId = MyAppState().cuChatId;
    final client = http.Client();
    List<ChatDetails> chatList = MyAppState().chatDetailsList;
    final request = http.Request('POST', Uri.parse(apiUrl));
    request.headers.addAll({
      'accept': "application/json",
      'content-type': 'application/json',
    });

    //request._contentType
    request.body = json.encode({
      'chat_id': MyAppState().cuChatId,
      'content': msg,
      'role': 'user',
      'model': MyAppState().cuModel
    });
    print("请请求体数据${request.body}");

    int? _loadingMessageIndex;
    String currentResponse = "";
    final response = await client.send(request);
    print("这是返回的数据${response.statusCode}");
    if (response.statusCode != 200) {
      ChatDetails chatDetails =
          ChatDetails(id: 0, chatId: 0, role: "error", content: "数据异常");
      chatList.add(chatDetails);
      MyAppState().setChatDetails(chatList);
      MyAppState().isSend = false;
      print('流结束了');
      // 在异步操作完成时调用回调函数
      if (onComplete != null) {
        onComplete();
      }
    }

    bool isFirstEvent = true;
    ChatDetails chatDetails =
        ChatDetails(id: 0, chatId: 0, role: "user", content: msg);
    chatList.add(chatDetails);
    MyAppState().setChatDetails(chatList);
    response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((event) {
      String result = event.replaceAll('data:', '');
      if (isFirstEvent) {
        MyAppState().isSend = true;
        isFirstEvent = false;
        ChatDetails chatDetails =
            ChatDetails(id: 0, chatId: 0, role: "assistant", content: result);
        chatList.add(chatDetails);
        MyAppState().setChatDetails(chatList);
        _loadingMessageIndex = chatList.length - 1;
      }
      if (cuId == MyAppState().cuChatId) {
        currentResponse = currentResponse + result;
        ChatDetails chatDetails = ChatDetails(
            id: 0, chatId: 0, role: "assistant", content: currentResponse);
        chatList[_loadingMessageIndex!] = chatDetails;
        MyAppState().setChatDetails(chatList);
      }
    }, onDone: () {
      // 在流结束时执行特定的操作
      getChatDetails(MyAppState().cuChatId)
          .then((value) => MyAppState().setChatDetails(value));
      MyAppState().isSend = false;
      print('流结束了');
      // 在异步操作完成时调用回调函数
      if (onComplete != null) {
        onComplete();
      }
    });
  }

  // 删除指定聊天记录
  static void delete_chat(int id) async {
    await httpUtils.get('$_baseUrl/delete_chat?chatId=$id');
  }

  // 删除全部聊天记录
  static void delete_all_chat() async {
    await httpUtils.get('$_baseUrl/delete_all_chat');
  }

  // 获取全部的模型
  static Future<List<ChatModel>> getAllModel() async {
    final response = await httpUtils.get('$_baseUrl/get_all_model');

    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> jsonMap = json.decode(responseBody);
      ChatModelList apiData = ChatModelList.fromJson(jsonMap);
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static void update_chat(int id, String? model, String? title) async {
    await httpUtils.post('$_baseUrl/update_chat',
        json.encode({'chat_id': id, "model": model, "title": title}), null);
  }
}
