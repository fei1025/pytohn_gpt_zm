import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/knowledge/left/KnowledgeLeft.dart';
import 'package:open_ui/page/knowledge/right/KnowledgeRight.dart';

class KnowledgePage extends StatelessWidget {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          VerticalDivider(
            thickness: 0.2,
            width: 0.01,
          ),
          Expanded(
            flex: 1,
            child: KnowledgeLeft(),
          ),
          VerticalDivider(
            thickness: 0.2,
            width: 0.5,
          ),
          Expanded(
            flex: 3,
            child: KnowledgeRight(),
          ),
        ],
      ),
    );
  }
}
