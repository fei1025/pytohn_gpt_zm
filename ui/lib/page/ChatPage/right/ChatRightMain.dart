import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'ChatRightInfo.dart';
import 'ChatRightSenMsg.dart';
import 'ChatRightTop.dart';

class ChatRightMain extends StatefulWidget {
  const ChatRightMain({super.key});

  @override
  _ChatPageMain createState() => _ChatPageMain();
}

class _ChatPageMain extends State<ChatRightMain> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                child: ChatRightTop())),
        const Divider(
          height: 0.1,
        ),
        Expanded(
          flex: 9,
          child: Column(
            children: [
              Expanded(
              flex:7,
                  child:    ChatRightInfo()),
              const Divider(
                height: 0.1,
              ),
              Expanded(
                flex:2,
                child:  ChatRightSenMsg() ,)

            ],
          ),
        )
      ],
    );
  }
}
