import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../model.dart';
import 'ChatLeft.dart';


class ChatPageMain extends StatefulWidget {
  const ChatPageMain({super.key});
  @override
  _ChatPageMain createState() => _ChatPageMain();
}
class _ChatPageMain  extends State<ChatPageMain> {
  @override
  Widget build(BuildContext context) {
    List<chatTitle> myList = [];
    for (int i = 1; i <= 10; i++) {
      var chat1= chatTitle(chatId: i.toString(),chatTopic: "标题$i");
      myList.add(chat1);
    }
    // 处理聊天标题卡片的悬停事件
    void handleChatTitleHover(bool isHovered) {
      if (isHovered) {

        // 在这里你可以执行更新主题的逻辑或其他操作
      }
    }
    int selectInt=-1;
    var appState = context.watch<MyAppState>();
    return Scaffold(

      body: Row(
        children: [
          const VerticalDivider(
            thickness: 0.2,
            width: 0.01,
          ),
          Expanded(
            flex: 1,
            child:Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: const Center(
                    child: Text('Top 10%'),
                  ),
                ),
                const Divider(height: 0.1,),//分割线
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ListView.builder(
                        itemCount:myList.length,
                        itemBuilder:(context, index){
                          chatTitle title =  myList[index];
                          return ChatTitleCard(title:title.chatTopic,
                            curIndex: index,
                            onTap: () {
                            setState(() {
                              appState.setTitle(index);
                            });
                            },selectIndex: selectInt,);
                        }
                    ),
                  ),
                ),
              ],
            ),

          ),
          const VerticalDivider(
            thickness: 0.2,
            width: 0.5,
          ),
          const Expanded(
            flex: 3,
            child:Text("这是主题"),
          ),
        ],
      ),
    );
  }
}



