import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../model.dart';


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
                          return demoe1(title:title.chatTopic,
                            curIndex: index,
                            onHover: handleChatTitleHover,onTap: () {
                            print("点击了$index");
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


class demoe1 extends StatelessWidget{
  final String title;
  final int curIndex;
  final int selectIndex;
  final ValueChanged<bool> onHover;
  final VoidCallback onTap;
  demoe1({required this.title, required this.curIndex, required this.onHover,required this.onTap, required this.selectIndex});
  bool hoveredIndex=false;
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var titleIndex = appState.titleIndex;
    return Card(
      child: MouseRegion(
        onEnter: (_) {
          hoveredIndex = true;

               },
        onExit: (_) {
                },
        child: ListTile(
          dense:true,
          selected:curIndex==titleIndex,
          leading:true ?null:const Padding(
            padding: EdgeInsets.only(left: 1,top: 3),
            child: Icon(Icons.chat_bubble_outline,size: 15,),
          ),
          title: Text(title),
          trailing: !hoveredIndex ?null:const Row(
            mainAxisSize: MainAxisSize.min,
            children: [ Icon(Icons.edit,size: 18,color: Colors.blueAccent,),
              SizedBox(width: 2), // 添加一个间距
              Icon(Icons.delete_outlined,size: 18,color: Colors.redAccent,),],
          ) ,
          onTap:(){
            onTap();

            print("当前点击了子类$titleIndex");
          },
        ),
      ),
    );
  }
}


class ChatTitleCard extends StatefulWidget {
  final String title;
  final int curIndex;
  final int selectIndex;
  final ValueChanged<bool> onHover;
  final ValueChanged<int> onTopInt;
  final VoidCallback onTap;
  ChatTitleCard({required this.title, required this.curIndex, required this.onHover,required this.onTap, required this.selectIndex,
  required this.onTopInt

  });

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
          selected:widget.curIndex==widget.selectIndex,
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
          onTap:(){
            widget.onTap();
            print("这是子级的触发啊${widget.selectIndex}");
            setState(() {
            });
          },
        ),
      ),
    );
  }
}

