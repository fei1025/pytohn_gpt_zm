
import 'BaseApiData.dart';

class ChatDetailsList extends BaseApiData{
  final List<ChatDetails> data;


  ChatDetailsList({required this.data, required int code, required String msg})
      : super(code: code, msg: msg);

  factory ChatDetailsList.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<ChatDetails> data = dataList.map((item) => ChatDetails.fromJson(item)).toList();

    return ChatDetailsList(
      data: data,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }
}








class ChatDetails{
   final int id;
   final int chatId;
   final String role;
   final String content;
   final List<dynamic>? other_data;

   ChatDetails({required this.id,required this.chatId, required this.role, required this.content, this.other_data});

   factory ChatDetails.fromJson(Map<String, dynamic> json) {
     return ChatDetails(
       id: json['id'] ?? '',
       chatId: json['chatId'] ?? 0,
       role: json['role'] ?? '',
       content: json['content'] ?? '',
       other_data: json['other_data_list'] != null ? List<dynamic>.from([json['other_data_list']]) : null,
     );
   }
}