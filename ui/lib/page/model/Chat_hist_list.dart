
import 'BaseApiData.dart';

class ChatHistList extends BaseApiData {
  final List<ChatHist> data;

  ChatHistList({required this.data, required int code, required String msg})
      : super(code: code, msg: msg);

  factory ChatHistList.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<ChatHist> data = dataList.map((item) => ChatHist.fromJson(item)).toList();

    return ChatHistList(
      data: data,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }
}

class ChatHist {
  final String model;
  final int chatId;
  final String title;
  final String creationTime;
  String tools;
  final int knowledgeId;

  ChatHist({
    required this.model,
    required this.chatId,
    required this.title,
    required this.creationTime,
    required this.knowledgeId,
    required this.tools,
  });

  factory ChatHist.fromJson(Map<String, dynamic> json) {
    return ChatHist(
      model: json['model'] ?? '',
      chatId: json['chat_id'] ?? 0,
      title: json['title'] ?? '',
      creationTime: json['creation_time'] ?? '',
      knowledgeId: json['knowledge_id'] ?? 0,
      tools: json['tools'] ?? '',
    );
  }
}