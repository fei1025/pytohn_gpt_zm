import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/state.dart';

import 'KnowledgeLeftMain.dart';
import 'KnowledgeLeftTop.dart';

class KnowledgeLeft extends StatefulWidget {
  const KnowledgeLeft({super.key});

  @override
  State<KnowledgeLeft> createState() => _KnowledgeLeftState();
}

class _KnowledgeLeftState extends State<KnowledgeLeft> {
  @override
  void initState() {
    // TODO: implement initState
    MyAppState().setChatDetails([]);
    MyAppState().setKnowledgeTitle("");
    MyAppState().setKnowledgeIndex(-1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 1, child: KnowledgeLeftTop()),
        Divider( height: 0.1, ),

        Expanded(flex:9,child: KnowledgeLeftMain())
      ],
    );
  }
}
