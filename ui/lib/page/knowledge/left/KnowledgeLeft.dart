import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'KnowledgeLeftMain.dart';
import 'KnowledgeLeftTop.dart';

class KnowledgeLeft extends StatefulWidget {
  const KnowledgeLeft({super.key});

  @override
  State<KnowledgeLeft> createState() => _KnowledgeLeftState();
}

class _KnowledgeLeftState extends State<KnowledgeLeft> {
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
