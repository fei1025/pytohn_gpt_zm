import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:open_ui/page/state.dart';
import 'package:window_manager/window_manager.dart';

import 'ChatRightInfo.dart';
import 'ChatRightSenMsg.dart';
import 'ChatRightTop.dart';

class ChatRightMain extends StatefulWidget {
  const ChatRightMain({super.key});

  @override
  _ChatPageMain createState() => _ChatPageMain();
}

class _ChatPageMain extends State<ChatRightMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanUpdate: (details) {
                  // 处理拖动事件
                  windowManager.startDragging();
                },
                // 删除这里的 child 参数
                child: ChatRightTop())),
        const Divider(
          height: 0.1,
        ),
         Expanded(
          flex: 9,
          child: Column(
            children: [
              const Expanded(
              flex:7,
                  child:    ChatRightInfo()),
              const Divider(
                height: 0.1,
              ),
              Expanded(
                flex:2,
                child:  ChatRightSenMsg(onPressedWithParam:(text){
                  int? chatId = MyAppState().cuChatId;
                  //String text = _controller.text;
                  if(chatId == null){
                    ApiService.saveChatHist(text,"0","").then((chatHistList){
                      ChatHist chatHist = chatHistList[0];
                      MyAppState().setCuChatId(chatHist.chatId);
                      ApiService.senMsg(text,(){
                        print("回调成功的数据");
                      });
                     ApiService.getAllHist("0").then((chatHistList2){
                       MyAppState().setChatHistList(chatHistList2);
                     });
                    });

                  }
                })
              )
            ],
          ),
        )
      ],
    );
  }
}
