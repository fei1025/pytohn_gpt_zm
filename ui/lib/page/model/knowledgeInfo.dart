
import 'BaseApiData.dart';

class KnowledgeInfoList extends BaseApiData{
  final List<KnowledgeInfo> data;


  KnowledgeInfoList({required this.data, required int code, required String msg})
      : super(code: code, msg: msg);

  factory KnowledgeInfoList.fromJson(Map<String, dynamic> json) {
    List<dynamic> dataList = json['data'] ?? [];
    List<KnowledgeInfo> data = dataList.map((item) => KnowledgeInfo.fromJson(item)).toList();

    return KnowledgeInfoList(
      data: data,
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
    );
  }
}







class KnowledgeInfo{
   final int id;
   final String knowledge_name;
   final String file_path;
   final String file_summarize;
   final String index_name;
   final String index_path;

   KnowledgeInfo( {required this.id,required this.knowledge_name, required this.file_path, required this.file_summarize,required this.index_name, required this.index_path,});

   factory KnowledgeInfo.fromJson(Map<String, dynamic> json) {
     return KnowledgeInfo(
       id: json['id'] ?? '',
       knowledge_name: json['knowledge_name'] ??'',
       file_path: json['file_path'] ?? '',
       file_summarize: json['file_summarize'] ?? '',
       index_name: json['index_name'] ?? '',
       index_path: json['index_path'] ?? '',
     );
   }
}