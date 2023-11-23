import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ChatRightTop.dart';

class ChatRightMain extends StatefulWidget {
  const ChatRightMain({super.key});

  @override
  _ChatPageMain createState() => _ChatPageMain();
}

class _ChatPageMain extends State<ChatRightMain> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              //color: Colors.red,
              child: ChatRightTop(),
            )),
        const Divider(
          height: 0.1,
        ),
        Expanded(
          flex: 9,
          child: Container(
            //color: Colors.blue,
            child: Center(
              child: Text("内容"),
            ),
          ),
        )
      ],
    );
  }
}
