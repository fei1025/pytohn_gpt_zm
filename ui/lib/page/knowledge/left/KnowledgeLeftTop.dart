import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:crypto/crypto.dart';

class KnowledgeLeftTop extends StatefulWidget {
  const KnowledgeLeftTop({super.key});

  @override
  State<KnowledgeLeftTop> createState() => _KnowledgeLeftTopState();
}

class _KnowledgeLeftTopState extends State<KnowledgeLeftTop> {
  bool isButtonDisabled = false;

  void _openFile1() async {
    print("开始上传文件了");

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    print("选择文件");
    print("isButtonDisabled:$isButtonDisabled");

    if (result != null) {
      print("文件名字:${result.files.single.name}");
      File file = File(result.files.single.path!);
      var md51 = md5.convert(await file.readAsBytes());
      print("当前文件的的md5:${md51.toString()}");
      //Map<String, dynamic> map = await ApiService.upload_check(md51.toString());
      // if(map['code'] == 500){
      //   showToast("",context);
      // }
      ApiService.uploadFileWithParams(result.files.single.path!, "", md51.toString());
      print("isButtonDisabled:$isButtonDisabled");
      _showToast("文件上传完成");
    } else {
      // User canceled the picker
    }
  }

  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }

  void _showEditDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('添加知识库'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: "名字"),
              ),
              TextButton(
                onPressed: isButtonDisabled ? null : () => {_openFile1()},
                child: const Row(
                  children: [
                    Text("点击上传文件",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // 设置字体粗细
                        )),
                    SizedBox(height: 30),
                    Icon(Icons.file_upload),
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('确认'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消
              },
              child: Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => _showEditDialog(),
                  child: const Row(
                    children: [
                      SizedBox(width: 10),
                      Icon(Icons.add),
                      Text("添加",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // 设置字体粗细
                          ))
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
