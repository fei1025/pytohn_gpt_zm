// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:open_ui/page/api/http_utils.dart';
import 'package:open_ui/page/model/ChatDetails.dart';
import 'package:open_ui/page/model/Chat_model.dart';
import 'package:open_ui/page/state.dart';
import 'dart:io';

import '../model/Chat_hist_list.dart';
import '../model/knowledgeInfo.dart';

class ApiService {
  //static const String _baseUrl = 'http://127.0.0.1:9011/';
  static const String _baseUrl = 'http://127.0.0.1:6688';

  static String getOpenBaseUrl() {
    return _baseUrl;
  }

  static Future<List<ChatHist>> getAllHist(String type) async {
    final response = await httpUtils.get('$_baseUrl/getAllHist?type=$type');
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
      print(responseBody);
      Map<String, dynamic> jsonMap = json.decode(responseBody);
      ChatDetailsList apiData = ChatDetailsList.fromJson(jsonMap);
      // 访问映射后的数据
      print(
          'Code: ${apiData.code}, Msg: ${apiData.msg},data${apiData.data.toString()}');
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<ChatHist>> saveChatHist(
      String msg, String type, String knowledgeId) async {
    final response = await httpUtils.post(
        '$_baseUrl/save_chat_hist',
        json.encode(
            {'content': msg, 'type': type, 'knowledge_id': knowledgeId,"tools":MyAppState().curSelectTool}),
        null);
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
    ChatDetails chatDetails = ChatDetails(id: 0, chatId: 0, role: "user", content: msg);
    ChatDetails assistantChatDetails = ChatDetails(id: 0, chatId: 0, role: "assistant", content: '');
    chatList.add(chatDetails);
    final response = await client.send(request);
    if (response.statusCode != 200) {
      ChatDetails chatDetails = ChatDetails(id: 0, chatId: 0, role: "error", content: "数据异常", other_data: []);
      chatList.add(chatDetails);
      MyAppState().setChatDetails(chatList);
      MyAppState().isSend = false;
      // 在异步操作完成时调用回调函数
      if (onComplete != null) {
        onComplete();
      }
    }

    bool isFirstEvent = true;
    chatList.add(assistantChatDetails);
    MyAppState().setChatDetails(chatList);
    response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((event) {
      String result1 = event.replaceAll('data:', '');
      if (result1.isEmpty) {
        return;
      }
      Map<String, dynamic> jsonMap = json.decode(result1);
      String type = jsonMap['type'];
      String data = jsonMap['data'];
      if (isFirstEvent) {
        MyAppState().isSend = true;
        isFirstEvent = false;
        ChatDetails chatDetails=chatList[chatList.length - 1];
        if ("msg" == type) {
        } else {
          List<ToolList> toolList = [];
          ToolList tool = ToolList(
              id: 0,
              chat_details_id: 0,
              type: '',
              tools: jsonMap['data'],
              isLoad: true);
          toolList.add(tool);
          chatDetails.toolList = toolList;
        }
        MyAppState().setChatDetails(chatList);
      }
      if (cuId == MyAppState().cuChatId) {
        ChatDetails chatDetails = chatList[chatList.length - 1];
        if ("msg" == type) {
          chatDetails.content = chatDetails.content + jsonMap['data'];
        } else if ("toolInput" == type) {
          ToolList toolList =chatDetails.toolList![chatDetails.toolList!.length - 1];
          toolList.problem = data;
          chatDetails.toolList![chatDetails.toolList!.length - 1] = toolList;
        } else if ("toolEnd" == type) {
          ToolList toolList =chatDetails.toolList![chatDetails.toolList!.length - 1];
          toolList.isLoad = false;
          toolList.tool_data = data;
          chatDetails.toolList![chatDetails.toolList!.length - 1] = toolList;
        }
        chatList[chatList.length - 1] = chatDetails;
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

  // 修改标题
  static Future<void> update_chat(
      int id, String? model, String? title, String? tools) async {
    await httpUtils.post(
        '$_baseUrl/update_chat',
        json.encode(
            {'chat_id': id, "model": model, "title": title, "tools": tools}),
        null);
  }

  // 检查数据
  static Future<Map<String, dynamic>> upload_check(String? md5) async {
    final response = await httpUtils.post(
        '$_baseUrl/knowledge/upload_check', json.encode({'md5': md5}), null);
    String responseBody = utf8.decode(response.bodyBytes);
    print("返回数据:${responseBody}");
    Map<String, dynamic> jsonMap = json.decode(responseBody);
    return jsonMap;
  }

  //创建新的知识库
  static Future<void> uploadFileWithParams(
      String path, String knowledge_name, String md5, int id) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('$_baseUrl/knowledge/uploadKnowledge'));
    request.files.add(await http.MultipartFile.fromPath('file', path));
    // Add additional parameters
    request.fields['knowledge_name'] = knowledge_name;
    request.fields['md5'] = md5;
    request.fields['id'] = id.toString();
    try {
      http.Response response =
          await http.Response.fromStream(await request.send());
      print('Response: ${response.body}');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  // 获取全部的知识库
  static Future<List<KnowledgeInfo>> getAllKnowledge() async {
//index_path
    final response = await httpUtils.get('$_baseUrl/knowledge/getAllKnowledge');
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> jsonMap = json.decode(responseBody);
      KnowledgeInfoList apiData = KnowledgeInfoList.fromJson(jsonMap);
      print("返回的数据${apiData.data}");
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<void> editKnowledgeName(int id, String title) async {
    await httpUtils.post('$_baseUrl/knowledge/editKnowledgeName',
        json.encode({'knowledge_id': id, "title": title}), null);
  }

  static Future<void> delete_Knowledge(int id) async {
    await httpUtils.get('$_baseUrl/knowledge/deleteKnowledge?knowledgeId=$id');
  }

  static Future<void> loadVectorstore(int id) async {
    await httpUtils.get('$_baseUrl/knowledge/load_vectorstore?knowledgeId=$id');
  }

  static Future<List<Map<String, dynamic>>> getAllToolList() async {
    final response = await httpUtils.get('$_baseUrl/get_all_tools');
    String responseBody = utf8.decode(response.bodyBytes);
    Map<String, dynamic> jsonMap = json.decode(responseBody);
    List<Map<String, dynamic>> dataList = [];
    List<dynamic> list = jsonMap['data'];
    dataList = list.map((e) => Map<String, dynamic>.from(e)).toList();
    //List<Map<String, dynamic>>  dataList = jsonMap['data'] ?? [];
    return dataList;
  }

  Future<void> downloadFile(String url, String savePath,Function(int totalBytes,int contentLength) downIng,Function(String save) success) async {
    var client = http.Client();

    final request = http.Request('GET', Uri.parse(url));

    var response = await client.send(request);
     var imageNmaeList= url.split("/");
     var name=imageNmaeList[imageNmaeList.length-1];
    // 创建文件用于保存下载内容
    var file = File("$savePath/${name}");
    var fileStream = file.openWrite();

    // 记录下载字节的总数
    int totalBytes = 0;
    int contentLength = int.parse(response.headers['content-length']!);

    // 绑定监听器
    response.stream.listen(
      (List<int> newBytes) {
        // 当收到新的数据片段时，更新总字节数
        totalBytes += newBytes.length;

        // 更新进度
        print("${(totalBytes / contentLength * 100).toStringAsFixed(0)}%");
        downIng(totalBytes,contentLength);
        // 将新的数据片段写入文件
        fileStream.add(newBytes);
      },
      onDone: () async {
        // 当所有片段都下载完毕时，关闭文件流
        file.exists();
        fileStream.close();
        client.close();
        success("$savePath/${name}");
      },
      onError: (e) {
        print("文件下载发生错误：$e");
      },
      // 是否取消此订阅
      cancelOnError: true,
    );
  }
}
