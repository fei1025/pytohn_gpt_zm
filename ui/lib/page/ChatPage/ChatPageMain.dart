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
        children: [
          const VerticalDivider(
            thickness: 0.2,
            width: 0.5,
          ),
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width * 0.22,
                child: const Center(
                  child: Text('Top 20%'),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.22,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.1, // 设置宽度
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: ListView(
                    children: [
                      ChatTitleCard(title: 'User 1'),

                      // 添加更多的聊天标题卡片
                    ],
                  ),
                ),
              ),
            ],
          ),
          const VerticalDivider(
            thickness: 0.2,
            width: 0.5,
          ),
        ],
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
        dense:true,
        leading:const Padding(
          padding: EdgeInsets.only(left: 1,top: 3),
          child: Icon(Icons.chat_bubble_outline,size: 15,),
        ),
        title: Text(title),
        onTap: () {
          // 处理聊天标题卡片的点击事件
        },
      ),
    );
  }
}

