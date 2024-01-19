import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';
import 'package:open_ui/page/state.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class HorizontalList extends StatefulWidget {
  const HorizontalList({super.key});

  @override
  State<HorizontalList> createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {
  bool isButtonDisabled = false;
  List<File> fileList = [];

  void _openFile1() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      fileList.add(file);
    } else {
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
              onPressed: () async {
                print(controller.text);
                for (var i = 0; i < fileList.length; i++) {
                  File file = fileList[i];
                  var md51 = md5.convert( await file.readAsBytes());
                  ApiService.uploadFileWithParams(file.path, controller.text, md51.toString());

                }
                _showToast("文件上传完成");
                Navigator.of(context).pop();
              },
              child: const Text('确认'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 取消
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return FutureBuilder<List<KnowledgeInfo>>(
      future: ApiService.getAllKnowledge(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        } else if (snapshot.hasError) {
          return Text('错误：${snapshot.error}');
        } else if (!snapshot.hasData) {
          return Text('没有可用的数据'); // 处理没有数据的情况
        } else {
          List<KnowledgeInfo> knowledgeInfoList = snapshot.data!;
          return ListView.builder(
            itemCount: 1 , // 设置为实际数据的长度
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  spacing: 8.0,
                  // 列之间的间距
                  runSpacing: 8.0,
                  // 行之间的间距
                  children: List.generate(knowledgeInfoList.length + 1, (index) {
                    if (index == 0) {
                      return InkWell(
                          onTap: _showEditDialog,
                          child: Card(
                              elevation: 3.0, // 卡片的阴影
                              child: AddContent()));
                    } else {
                      return InkWell(
                          onTap: () {
                            print("点击了");
                          },
                          child: Card(
                              elevation: 3.0, // 卡片的阴影
                              child:
                              buildContent(knowledgeInfoList[index-1], context)));
                    }
                  }),
                ),
              );
            },
          );
        }
      },
    );
  }

  Widget buildContent(KnowledgeInfo knowledgeInfo, BuildContext context) {
    return Container(
        width: 150,
        height: 0.618 * 150,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                flex: 8,
                child: Text(knowledgeInfo.knowledge_name,
                    style: const TextStyle(fontSize: 16))),
            Expanded(
                flex: 2,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end, // 交叉轴方向朝向结束
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Icon(Icons.edit,
                          size: 20, color: Colors.blueAccent),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('删除'),
                                content: const Text('你确定要删除当前知识库吗?'),
                                actions: <Widget>[
                                  TextButton(
                                      onPressed: () {
                                        // appState.setTitle(-1);
                                        // appState.setCuTitle("");
                                        // appState.setCuChatId(null);
                                        // appState.setChatDetails([]);
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
                      child: Icon(Icons.delete_outlined,
                          size: 20, color: Colors.red.shade400),
                    ),
                  ],
                ))
          ],
        ));
  }

  Widget AddContent() {
    return Container(
        child: Container(
            width: 150,
            height: 0.618 * 150,
            padding: const EdgeInsets.all(10),
            child: const Row(
              children: [
                Icon(Icons.add),
                Text(
                  "新增",
                  style: TextStyle(fontSize: 20),
                )
              ],
            )));
  }
}