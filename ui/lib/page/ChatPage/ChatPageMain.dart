import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../model.dart';

class ChatPageMain extends StatelessWidget {
  const ChatPageMain({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();


    var pair = appState.current; 
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

    void handleChatTitleTap() {

      // 在这里你可以执行更新主题的逻辑或其他操作
    }

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
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: const Center(
                    child: Text('Top 20%'),
                  ),
                ),
                Divider(height: 0.1,),//分割线
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ListView.builder(
                        itemCount:myList.length,
                        itemBuilder:(context, index){
                          chatTitle title =  myList[index];
                          return ChatTitleCard(title:title.chatTopic,curIndex: index,onHover: handleChatTitleHover,onTap: handleChatTitleTap,);
                        }
                      // children: [
                      //   ChatTitleCard(title: 'User 1'),
                      //
                      //   // 添加更多的聊天标题卡片
                      // ],
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

class ChatTitleCard extends StatefulWidget {
  final String title;
  final int curIndex;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;

  ChatTitleCard({required this.title, required this.curIndex, required this.onHover,required this.onTap});

  @override
  _ChatTitleCardState createState() => _ChatTitleCardState();
}



class  _ChatTitleCardState extends State<ChatTitleCard>{


  bool hoveredIndex=false;



  @override
  Widget build(BuildContext context) {
    return Card(
      child: MouseRegion(
          onEnter: (_) {
            setState(() {
              hoveredIndex = true;
            });
            widget.onHover(true);          },
          onExit: (_) {
            setState(() {
              hoveredIndex = false;
            });
            widget.onHover(false);          },
        child: ListTile(
          dense:true,
          selected:true,
          leading:true ?null:const Padding(
            padding: EdgeInsets.only(left: 1,top: 3),
            child: Icon(Icons.chat_bubble_outline,size: 15,),
          ),
          title: Text(widget.title),
            trailing: !hoveredIndex ?null:const Row(
              mainAxisSize: MainAxisSize.min,
              children: [ Icon(Icons.edit,size: 18,color: Colors.blueAccent,),
                SizedBox(width: 2), // 添加一个间距
                Icon(Icons.delete_outlined,size: 18,color: Colors.redAccent,),],
            ) ,
          onTap: () {
            // 处理聊天标题卡片的点击事件
          },
        ),
      ),
    );
  }
}

