import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/ChatPage/right/ChatRightInfo.dart';
import 'package:open_ui/page/ChatPage/right/ChatRightSenMsg.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:open_ui/page/state.dart';

class KnowledgeRightInfo extends StatefulWidget {
  const KnowledgeRightInfo({super.key});

  @override
  State<KnowledgeRightInfo> createState() => _KnowledgeRightInfoState();
}

class _KnowledgeRightInfoState extends State<KnowledgeRightInfo> {
  @override
  Widget build(BuildContext context) {


    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Expanded(flex: 7, child:ChatRightInfo()),
        const Divider(
          height: 0.1,
        ),
        Expanded(flex: 2, child:ChatRightSenMsg(onPressedWithParam:(text){
          //int? chatId = MyAppState().cuChatId;
            ApiService.senMsg(text,(){
              print("回调成功的数据");
            });
            ApiService.getAllHist("1").then((chatHistList2){
              MyAppState().setChatHistList(chatHistList2);
            });
          print("输入的数据:${text}");
        }))
      ],
    );

  }
}
