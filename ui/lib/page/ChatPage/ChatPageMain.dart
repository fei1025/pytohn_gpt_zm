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
            thickness: 0.5,
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
                      color: Colors.red, // 设置颜色
                      width: 0.5, // 设置宽度
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.22,
                  child: ListView(
                    children: [
                      ChatTitleCard(title: 'User 1',content:"内容1"),

                      // 添加更多的聊天标题卡片
                    ],
                  ),
                ),
              ),
            ],
          ),
          const VerticalDivider(
            thickness: 0.5,
            width: 0.5,
          ),
        ],
      ),
    );
  }
}

class ChatTitleCard extends StatelessWidget {
  final String title;
  final String content;


  ChatTitleCard({required this.title,
    required this.content,
  });
 // 用ListTile  把
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        elevation: 1, //阴影的大小
        margin: const EdgeInsets.all(5), //外边距
        child: GestureDetector(
          onTap: () {},
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        content,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

class MyHoverCard extends StatefulWidget {
  final String title;
  final String content;
  MyHoverCard({required this.title,
    required this.content,
  });
  @override
  _MyHoverCardState createState() => _MyHoverCardState(title: title,content:content);
}

class _MyHoverCardState extends State<MyHoverCard> {

  bool isHovered = false;

  final String title;
  final String content;
  _MyHoverCardState({required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return InkWell(
      onTap: () {
        // 处理点击事件
      },
      onHover: (hover) {
        setState(() {
          isHovered = hover;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isHovered ?theme.hoverColor  : theme.cardColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.1,
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      "Content",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

