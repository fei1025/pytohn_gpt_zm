import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/knowledge/left/KnowledgeLeftCard.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';
import 'package:open_ui/page/state.dart';
import 'package:provider/provider.dart';

class KnowledgeLeftMain extends StatefulWidget {
  const KnowledgeLeftMain({super.key});

  @override
  State<KnowledgeLeftMain> createState() => _KnowledgeLeftMainState();
}

class _KnowledgeLeftMainState extends State<KnowledgeLeftMain> {
  int selectInt = -1;

  // List<KnowledgeInfo> knowledgeInfoList =  ApiService.getAllKnowledge() as List<KnowledgeInfo>;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return FutureBuilder<List<KnowledgeInfo>>(
      future: ApiService.getAllKnowledge(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
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
                return KnowledgeLeftCard(curIndex:index,selectIndex:selectInt,knowledgeInfo:title,onTap:(){
                  appState.setKnowledgelIndex(index);

                });
              },
            ),
          );
        }
      },
    );
  }
}
