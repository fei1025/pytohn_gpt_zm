import 'BaseApiData.dart';

class ChatModelList extends BaseApiData {
  final List<ChatModel> data;

  ChatModelList({required this.data, required int code, required String msg})
      : super(code: code, msg: msg);

  factory ChatModelList.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<ChatModel> data = dataList.map((item) => ChatModel.fromJson(item)).toList();

    return ChatModelList(
      data: data,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }
}

class ChatModel{
  final String key;
  final String value;

  ChatModel({required this.key,required this.value});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        key:json['key'],
        value:json['value']
    );
  }
}