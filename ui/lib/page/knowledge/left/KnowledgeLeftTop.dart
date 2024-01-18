import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/state.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:crypto/crypto.dart';

class KnowledgeLeftTop extends StatefulWidget {
  const KnowledgeLeftTop({super.key});

  @override
  State<KnowledgeLeftTop> createState() => _KnowledgeLeftTopState();
}

class _KnowledgeLeftTopState extends State<KnowledgeLeftTop> {


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanUpdate: (details) {
          // 处理拖动事件
          windowManager.startDragging();
        },
        // 删除这里的 child 参数
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                //color: Colors.lightBlue,
                // margin: const EdgeInsets.only(right: 15,top: 25,bottom: 10,left: 5),
                padding: const EdgeInsets.only(left: 0, bottom: 0, top: 15),
                child: TextButton(
                  onPressed: () => {
                    appState.setKnowledgeIndex(-1)
                  },
                  child: const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.add),
                      Text("新的聊天",style: TextStyle(fontSize: 15),)
                    ],
                  ),
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
                            content: const Text('你确定要删除全部知识库吗?'),
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
                  icon: const Icon(
                    Icons.delete_sweep_rounded,
                    // color: Colors.redAccent.withRed(20),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
