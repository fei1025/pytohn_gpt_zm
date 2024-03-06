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
  void _showUploadDialog(String s) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return  AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(s),
            ],
          ),
        );
      },
    );
  }
  int selectInt = -1;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<ChatHist> knowledgeInfoList = appState.knowledgeHistList;
    return Scaffold(
            body: ListView.builder(
              itemCount: knowledgeInfoList.length,
              itemBuilder: (context, index) {
                ChatHist title = knowledgeInfoList[index];
                return KnowledgeLeftCard(curIndex:index,selectIndex:selectInt,knowledgeInfo:title,onTap:(){
                  appState.setKnowledgeIndex(index);
                  appState.setKnowledgeTitle(title.title);
                  // 点击了标题
                  appState.setCuChatId(title.chatId);
                  appState.setCuChatHist(title);
                  //加载索引
                  _showUploadDialog("加载索引中");
                  ApiService.loadVectorstore(title.knowledgeId).then((value){
                    Navigator.of(context).pop();
                    setState(() {
                      ApiService.getChatDetails(appState.cuChatId).then((value) =>appState.setChatDetails(value));
                      appState.setKnowledgeIndex(index);
                    });
                  });


                });
              },
            ),
          );
  }
}


