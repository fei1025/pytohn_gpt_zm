import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/knowledge/right/KnowledgeRightTop.dart';

class KnowledgeRight extends StatefulWidget {
  const KnowledgeRight({super.key});

  @override
  State<KnowledgeRight> createState() => _KnowledgeRightState();
}

class _KnowledgeRightState extends State<KnowledgeRight> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Expanded(flex: 1, child: KnowledgeRightTop()),
        Divider(
          height: 0.1,
        ),
        Expanded(flex: 9, child: Text("这里是主要内容"))
      ],
    );
  }
}
