import 'package:english_words/english_words.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

class ChatPageMain extends StatelessWidget {
  const ChatPageMain({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    var pair = appState.current;
    return Scaffold(
      body: Row(
          children:[
            VerticalDivider(
              thickness: 0.5,
              width: 0.5,
            ),
            Container(
              width: 200,
              child: ListView(
                children: [
                  ChatTitleCard(title: 'User 1'),
                  ChatTitleCard(title: 'User 2'),
                  // 添加更多的聊天标题卡片
                ],
              ),
            ),
            VerticalDivider(
              thickness: 0.5,
              width: 0.5,
            ),

          ]
      ),
    );
  }
}


class ChatTitleCard extends StatelessWidget {
  final String title;

  ChatTitleCard({required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        onTap: () {
          // 处理聊天标题卡片的点击事件
        },
      ),
    );
  }
}


