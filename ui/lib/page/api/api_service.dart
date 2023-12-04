import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/ChatDetails.dart';
import '../model/Chat_hist_list.dart';

class ApiService {
  static const String _baseUrl = 'http://127.0.0.1:6688';

  static Future<List<ChatHist>> fetchData() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/getAllHist'),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );
    if (response.statusCode == 200) {
      String responseBody = utf8.decode(response.bodyBytes);

      Map<String, dynamic> jsonMap = json.decode(responseBody);
      ChatHistList apiData = ChatHistList.fromJson(jsonMap);
      // 访问映射后的数据
      print('Code: ${apiData.code}, Msg: ${apiData.msg}');
      for (ChatHist item in apiData.data) {
        print(
            'Model: ${item.model}, Chat ID: ${item.chatId}, Title: ${item.title}, Creation Time: ${item.creationTime}');
      }
      return apiData.data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<ChatDetails>> getChatDetails(int chatId) async {


    throw Exception('Failed to load data');
  }
}
