import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state.dart';

class ChatRightSenMsg extends StatefulWidget {
  const ChatRightSenMsg({super.key});

  @override
  State<ChatRightSenMsg> createState() => _ChatRightSenMsg();
}

class _ChatRightSenMsg extends State<ChatRightSenMsg> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    var appState = context.watch<MyAppState>();
    List msessage = [];
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
            child: Stack(
                children:[SizedBox(
                width:  MediaQuery.of(context).size.width * 0.68,
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
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // 处理悬浮图标点击事件
                      // 这里可以展示一些信息或执行其他操作
                    },
                  ),
                ),
              ]
            ),
          ),
        ]));
  }
}
