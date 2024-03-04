import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:provider/provider.dart';

import '../../api/api_service.dart';
import '../../state.dart';

class ChatRightSenMsg extends StatefulWidget {
  final Function onPressedWithParam;

  ChatRightSenMsg({super.key, required this.onPressedWithParam});

  @override
  State<ChatRightSenMsg> createState() => _ChatRightSenMsg();
}

class _ChatRightSenMsg extends State<ChatRightSenMsg> {
  final TextEditingController _controller = TextEditingController();
  List<bool> _isCheckedList = [false, true, false];

  void _sendMessage(MyAppState appState) async {
    if (_controller.text.isNotEmpty) {
      widget.onPressedWithParam(_controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isDarkMode = appState.isDarkMode;
    print("数据刷新了");

    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween, // 添加这一行
            children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      // List to hold checkbox states
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                title: Text('Select Options'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: List.generate(
                                      _isCheckedList.length,
                                      (index) {
                                        return CheckboxListTile(
                                          title: Text('Checkbox ${index + 1}'),
                                          value: _isCheckedList[index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              print(_isCheckedList[index]);
                                              _isCheckedList[index] = value!;
                                              print(_isCheckedList[index]);
                                              print(_isCheckedList);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            });
                          });
                    },
                    icon: Icon(Icons.add))
              ],
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
