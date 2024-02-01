import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/ChatPage/right/ChatRightInfo.dart';

class KnowledgeRightInfo extends StatefulWidget {
  const KnowledgeRightInfo({super.key});

  @override
  State<KnowledgeRightInfo> createState() => _KnowledgeRightInfoState();
}

class _KnowledgeRightInfoState extends State<KnowledgeRightInfo> {
  @override
  Widget build(BuildContext context) {


    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Expanded(flex: 7, child:ChatRightInfo()),
        const Divider(
          height: 0.1,
        ),
        Expanded(flex: 2, child: const Placeholder(color: Colors.red,))
      ],
    );

  }
}
