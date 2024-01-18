import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';
import 'package:open_ui/page/state.dart';
import 'package:provider/provider.dart';

class KnowledgeLeftCard extends StatefulWidget {
  final int curIndex;
  final int selectIndex;
  final ChatHist knowledgeInfo;
  final VoidCallback onTap;

  const KnowledgeLeftCard(
      {super.key,
      required this.curIndex,
      required this.selectIndex,
      required this.knowledgeInfo,
      required this.onTap});

  @override
  State<KnowledgeLeftCard> createState() => _KnowledgeLeftCardState();
}

class _KnowledgeLeftCardState extends State<KnowledgeLeftCard> {
  // 是否悬浮上去
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
                    ApiService.getAllHist("0").then((value) =>
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
    var knowledgelIndex = appState.knowledgeIndex;
    return Card(
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
              color: widget.curIndex == knowledgelIndex
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
            selected: widget.curIndex == knowledgelIndex,
            title: Text(widget.knowledgeInfo.title),
            trailing: isHovered || (widget.curIndex == knowledgelIndex)
                ? Transform.translate(
                    offset: const Offset(10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            _showEditDialog(widget.knowledgeInfo.title,widget.knowledgeInfo.chatId);
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
                                            // appState.setTitle(-1);
                                            // appState.setCuTitle("");
                                            // appState.setCuChatId(null);
                                            // appState.setChatDetails([]);
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
