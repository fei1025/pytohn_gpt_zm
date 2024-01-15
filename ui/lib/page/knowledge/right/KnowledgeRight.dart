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
    return Column(
      children: [
        Expanded(flex: 1, child: KnowledgeRightTop()),
        Divider(
          height: 0.1,
        ),
        Expanded(flex: 9, child: HorizontalList())
      ],
    );
  }
}

class HorizontalList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 8.0, // 列之间的间距
        runSpacing: 8.0, // 行之间的间距
        children: List.generate(
          10, // 列数
          (index) {
            if (0 == index) {
              return InkWell(
                  onTap: () {
                    print("点击了");
                  },
                  child: Card(
                      elevation: 3.0, // 卡片的阴影
                      child: AddContent()));
            } else {
              return Card(
                  elevation: 3.0, // 卡片的阴影
                  child: buildContent());
            }
          },
        ),
      ),
    );
  }

  Widget buildContent() {
    return Container(
        width: 150,
        height: 0.618 * 150,
        padding: const EdgeInsets.all(10),
        child: Text("Card : 卡片", style: TextStyle(fontSize: 20)));
  }

  Widget AddContent() {
    return Container(

      child: Container(
          width: 150,
          height: 0.618 * 150,
          padding: const EdgeInsets.all(10),
          child:Row(children: [Icon(Icons.add),Text("创建知识库",style: TextStyle(fontSize: 20),)],)
    )
    );
  }
}
