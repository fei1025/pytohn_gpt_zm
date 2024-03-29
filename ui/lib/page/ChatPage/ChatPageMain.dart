import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';import 'package:open_ui/page/ChatPage/right/ChatRightMain.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../api/api_service.dart';
import '../model.dart';
import '../model/Chat_hist_list.dart';
import '../state.dart';
import 'ChatLeft.dart';
import 'ChatLeftTop.dart';

class ChatPageMain extends StatefulWidget {
  //const ChatPageMain({super.key});
  ChatPageMain({Key? key}) : super(key: key);


  @override
  _ChatPageMain createState() => _ChatPageMain();
}

class _ChatPageMain extends State<ChatPageMain> {
  clearKeywords() {}
  late Future histLoader;

  @override
  void initState() {
    if (!mounted) return;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // 在这里执行初始化操作，此时可以访问到 context。
      // TODO: implement initState
      MyAppState().setTitle(-1);
      MyAppState().setCuTitle("");
      MyAppState().setCuChatId(null);
      MyAppState().setCuChatHist(null);
      MyAppState().setChatDetails([]);
      int curIndex = context.read<MyAppState>().curSelectedIndex;
      print("curIndex:${curIndex}");
      String queryType =context.read<MyAppState>().getValueByKey(curIndex)!;
      ApiService.getAllHist(queryType).then((value) =>  Provider.of<MyAppState>(context, listen: false).setChatHistList(value));
    });
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List<ChatHist> chatHistList = appState.chatHistList;

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
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onPanUpdate: (details) {
                        // 处理拖动事件
                        windowManager.startDragging();
                      },
                      // 删除这里的 child 参数
                      child: ChatLeftTop()),
                ),

                const Divider(
                  height: 0.1,
                ), //分割线
                Expanded(
                  flex: 9,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.22,
                    child: ListView.builder(
                        itemCount: chatHistList.length,
                        itemBuilder: (context, index) {
                          ChatHist title = chatHistList[index];
                          return ChatTitleCard(
                            title: title.title,
                            chatHist:title,
                            curIndex: index,
                            onTap: () {
                              //print(title.title);
                              appState.setCuTitle(title.title);
                              // 点击了标题
                              appState.setCuChatId(title.chatId);
                              appState.setCuChatHist(title);
                              setState(() {
                                ApiService.getChatDetails(appState.cuChatId).then((value) =>appState.setChatDetails(value));
                                appState.setTitle(index);
                              });
                            }
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
            child: ChatRightMain(),
          ),
        ],
      ),
    );
  }
}
