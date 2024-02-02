import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/state.dart';

import 'KnowledgeLeftMain.dart';
import 'KnowledgeLeftTop.dart';

class KnowledgeLeft extends StatefulWidget {
  const KnowledgeLeft({super.key});

  @override
  State<KnowledgeLeft> createState() => _KnowledgeLeftState();
}

class _KnowledgeLeftState extends State<KnowledgeLeft> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在这里执行初始化操作，此时可以访问到 context。
      print("执行初始化知识库数据了");
      // TODO: implement initState
      MyAppState().setChatDetails([]);
      MyAppState().setKnowledgeTitle("");
      MyAppState().setKnowledgeIndex(-1);
      // 查询所有的聊天记录
      ApiService.getAllHist("1").then((value) =>  MyAppState().setKnowledgeHistList(value));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 1, child: KnowledgeLeftTop()),
        Divider( height: 0.1, ),

        Expanded(flex:9,child: KnowledgeLeftMain())
      ],
    );
  }
}
