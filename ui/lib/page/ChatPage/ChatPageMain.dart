import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../model.dart';
import '../state.dart';
import 'ChatLeft.dart';

class ChatPageMain extends StatefulWidget {
  const ChatPageMain({super.key});

  @override
  _ChatPageMain createState() => _ChatPageMain();
}

class _ChatPageMain extends State<ChatPageMain> {

  clearKeywords() {
  }
  @override
  Widget build(BuildContext context) {
    List<chatTitle> myList = [];
    for (int i = 1; i <= 10; i++) {
      var chat1 = chatTitle(chatId: i.toString(), chatTopic: "标题$i");
      myList.add(chat1);
    }
    int selectInt = -1;
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
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: Row(
                      children: [
                        Expanded(
                          flex:3,
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 0),
                            padding: EdgeInsets.only(left: 5, bottom: 0,top: 15),
                            child:  TextField(
                                style: TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 20,
                                    ),
                                    //头部搜索图标
                                    contentPadding: EdgeInsets.only(
                                        bottom: 1, top: 2),
                                    filled: true,
                                    fillColor: Colors.grey.withAlpha(0), // 设置输入框背景色为灰色,并设置透明度
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)), //圆角边框
                                      //borderSide: BorderSide.none
                                    ),
                                    suffixIcon: IconButton(//尾部叉叉图标
                                      icon: const Icon(
                                        Icons.close,
                                        size: 17,
                                      ),
                                      onPressed: (){print("删除操作");},//清空操作
                                      splashColor: Theme.of(context).primaryColor,
                                    )
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:  EdgeInsets.only(left: 6, bottom: 0,top: 15),
                            child: Text("添加"),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding:  EdgeInsets.only(left: 0, bottom: 0,top: 15),
                            child: Text("删除"),
                          ),
                        )
                      ]
                    )),
                const Divider(
                  height: 0.1,
                ), //分割线
                Expanded(
                  flex: 1,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ListView.builder(
                        itemCount: myList.length,
                        itemBuilder: (context, index) {
                          chatTitle title = myList[index];
                          return ChatTitleCard(
                            title: title.chatTopic,
                            curIndex: index,
                            onTap: () {
                              setState(() {
                                appState.setTitle(index);
                              });
                            },
                            selectIndex: selectInt,
                          );
                        }),
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
            child: Text("这是主题"),
          ),
        ],
      ),
    );
  }
}
