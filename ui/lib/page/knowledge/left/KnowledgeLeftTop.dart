import 'package:flutter/cupertino.dart';
import 'package:window_manager/window_manager.dart';

class KnowledgeLeftTop extends StatefulWidget {
  const KnowledgeLeftTop({super.key});

  @override
  State<KnowledgeLeftTop> createState() => _KnowledgeLeftTopState();
}

class _KnowledgeLeftTopState extends State<KnowledgeLeftTop> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          // 处理拖动事件
          windowManager.startDragging();
        },
        // 删除这里的 child 参数
        child: Text("这是内容"));
  }
}
