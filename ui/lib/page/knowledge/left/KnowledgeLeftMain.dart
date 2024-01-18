import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/knowledge/left/KnowledgeLeftCard.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
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

    return FutureBuilder<List<ChatHist>>(
        //ApiService.getAllHist("0").then((value) =>context.read<MyAppState>().setChatHistList(value));
      future:  ApiService.getAllHist("1"),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        } else if (snapshot.hasError) {
          return Text('错误：${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('没有可用的数据'); // 处理没有数据的情况
        } else {
          List<ChatHist> knowledgeInfoList = snapshot.data!;
          return Scaffold(
            body: ListView.builder(
              itemCount: knowledgeInfoList.length,
              itemBuilder: (context, index) {
                ChatHist title = knowledgeInfoList[index];
                return KnowledgeLeftCard(curIndex:index,selectIndex:selectInt,knowledgeInfo:title,onTap:(){
                  appState.setKnowledgeIndex(index);
                });
              },
            ),
          );
        }
      },
    );
  }
}
