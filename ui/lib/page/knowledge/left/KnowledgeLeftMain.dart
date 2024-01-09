import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';

class KnowledgeLeftMain extends StatefulWidget {
  const KnowledgeLeftMain({super.key});

  @override
  State<KnowledgeLeftMain> createState() => _KnowledgeLeftMainState();
}

class _KnowledgeLeftMainState extends State<KnowledgeLeftMain> {
 // List<KnowledgeInfo> knowledgeInfoList =  ApiService.getAllKnowledge() as List<KnowledgeInfo>;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<KnowledgeInfo>>(
      future: ApiService.getAllKnowledge(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('错误：${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('没有可用的数据'); // 处理没有数据的情况
        } else {
          List<KnowledgeInfo> knowledgeInfoList = snapshot.data!;
        print("长度${knowledgeInfoList[0].knowledge_name}");
          return Scaffold(
            body: ListView.builder(
              itemCount: knowledgeInfoList.length,
              itemBuilder: (context, index) {
                KnowledgeInfo title = knowledgeInfoList[index];
                return Text(title.knowledge_name);
              },
            ),
          );
        }
      },
    );
  }
}
