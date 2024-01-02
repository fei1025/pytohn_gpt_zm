import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        child: Row(children: [   Expanded(
          flex: 7,
          child: Container(
            //color: Colors.lightBlue,
            // margin: const EdgeInsets.only(right: 15,top: 25,bottom: 10,left: 5),
            padding: const EdgeInsets.only(left: 0, bottom: 0, top: 15),
            child: TextButton(onPressed: () {

            }, child:const Row(children:[ SizedBox(width: 10),Icon(Icons.add),Text("创建新的知识库",style: TextStyle(
              fontWeight: FontWeight.bold, // 设置字体粗细
            )
            )],),
            ),
          ),
        ),
          Expanded(
            flex: 3,
            child: Container(
              // margin: const EdgeInsets.only(right: 0,top: 25,bottom: 10,left: 0),
              padding: const EdgeInsets.only(left: 0, bottom: 0, top: 15),
              child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: const Text('删除'),
                          content: const Text('你确定要删除全部聊天记录吗?'),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () {
                                  // 关闭弹窗
                                  Navigator.of(context).pop();
                                },
                                child: const Text('确定')),
                            TextButton(
                                onPressed: () {
                                  // 关闭弹窗
                                  Navigator.of(context).pop();
                                },
                                child: const Text('退出')),
                          ]);
                    },
                  );
                },
                icon:  const Icon(
                  Icons.delete_sweep_rounded,
                  // color: Colors.redAccent.withRed(20),
                ),
              ),
            ),
          )],));
  }
}
