// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:provider/provider.dart';

import '../state.dart';

class ChatTitleCard extends StatefulWidget {
  final String title;
  final int curIndex;
  final ChatHist chatHist;
  final VoidCallback onTap;

  const ChatTitleCard(
      {super.key,
      required this.title,
      required this.curIndex,
      required this.onTap,
      required this.chatHist});

  @override
  _ChatTitleCardState createState() => _ChatTitleCardState();
}

class _ChatTitleCardState extends State<ChatTitleCard> {
  bool isHovered = false;
  var isSelect = false;

  void _showEditDialog(String title, int chatId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        controller.text = title;
        return AlertDialog(
          title: const Text('修改标题'),
          content: TextField(
            controller: controller,
            //decoration: InputDecoration(labelText: title),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (title != controller.text) {
                  ApiService.update_chat(chatId, null, controller.text)
                      .then((value) {
                    String queryType =context.watch<MyAppState>().getValueByKey(context.watch<MyAppState>().curSelectedIndex)!;
                    ApiService.getAllHist(queryType).then((value) =>
                        context.read<MyAppState>().setChatHistList(value));
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('确认'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var titleIndex = appState.titleIndex;
    return Card(
      //color: theme.colorScheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onHover: (bool key) {
          setState(() {
            isHovered = key;
          });
        },
        onTap: () {
          widget.onTap();
          setState(() {
            isSelect = true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.curIndex == titleIndex
                  ? !appState.isDarkMode
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColorDark.withOpacity(0.5)
                  : Colors.transparent,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            minLeadingWidth: 10,
            minVerticalPadding: 10,
            dense: true,
            selected: widget.curIndex == titleIndex,
            title: Text(widget.title),
            trailing: isHovered || (widget.curIndex == titleIndex)
                ? Transform.translate(
                    offset: const Offset(10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            print("点击修改了");
                            _showEditDialog(
                                widget.title, widget.chatHist.chatId);
                          },
                          child: const Icon(Icons.edit,
                              size: 20, color: Colors.blueAccent),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text('删除'),
                                    content: const Text('你确定要删除当前聊天记录吗?'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () {
                                            ApiService.delete_chat(
                                                widget.chatHist.chatId);
                                            if(widget.curIndex == titleIndex){
                                              appState.setTitle(-1);
                                              appState.setCuTitle("");
                                              appState.setCuChatId(null);
                                              appState.setChatDetails([]);
                                            }
                                            int curIndex = context.read<MyAppState>().curSelectedIndex;
                                            String queryType =context.read<MyAppState>().getValueByKey(curIndex)!;
                                            ApiService.getAllHist(queryType).then((value) =>  Provider.of<MyAppState>(context, listen: false).setChatHistList(value));
                                            // 关闭弹窗
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('确定')),
                                      TextButton(
                                          onPressed: () {
                                            // 关闭弹窗
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('退出')),
                                    ]);
                              },
                            );
                          },
                          child: Icon(Icons.delete_outlined,
                              size: 20, color: Colors.red.shade400),
                        ),
                      ],
                    ))
                : null,
          ),
        ),
      ),
    );
  }
}
