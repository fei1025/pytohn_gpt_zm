import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:provider/provider.dart';

import '../../api/api_service.dart';
import '../../state.dart';

class ChatRightSenMsg extends StatefulWidget {
  const ChatRightSenMsg({super.key});

  @override
  State<ChatRightSenMsg> createState() => _ChatRightSenMsg();
}

class _ChatRightSenMsg extends State<ChatRightSenMsg> {
  final TextEditingController _controller = TextEditingController();


  void _sendMessage(MyAppState appState) async {
    if (_controller.text.isNotEmpty) {
      int? chatId = appState.cuChatId;
      String text = _controller.text;
      if(chatId == null){
        List<ChatHist> chatHistList  = await ApiService.saveChatHist(text,"0");
        ChatHist chatHist = chatHistList[0];
        appState.setCuChatId(chatHist.chatId);
        List<ChatHist> chatHistList2 =  await ApiService.getAllHist("0");
        appState.setChatHistList(chatHistList2);
      }

      ApiService.senMsg(text,(){
        print("回调成功的数据");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isDarkMode = appState.isDarkMode;
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween, // 添加这一行
            children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [IconButton(onPressed: () {}, icon: Icon(Icons.add))],
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.68,
                child: TextField(
                  controller: _controller,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: '输入消息',
                    fillColor: isDarkMode ? null : Colors.grey[200],
                    // 输入框背景颜色
                    //filled: true,
                    // 启用填充背景颜色
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // 输入框圆角
                      //borderSide: BorderSide.none, // 移除边框
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 60,
                child: IconButton(
                  icon: appState.isSend
                      ? const Icon(Icons.stop_circle_rounded)
                      : const Icon(Icons.send),
                  onPressed: () {
                    if (!appState.isSend) {
                      _sendMessage(appState);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ]),
          ),
        ]));
  }
}
