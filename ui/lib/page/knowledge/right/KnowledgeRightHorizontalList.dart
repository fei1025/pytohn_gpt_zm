import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';
import 'package:open_ui/page/state.dart';
import 'package:open_ui/page/uiModule/uiModel.dart';
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
  List<String> fileName = [];

  void _openFile1(StateSetter _setState) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      print("名字${result.files.single.name}");
      _setState(() {
        fileName.add(result.files.single.name);
        fileList.add(file);
      });
    } else {}
  }

  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }

  void _showEditDialog(KnowledgeInfo? knowledgeInfo) async {
    fileList.clear();
    fileName.clear();
    StateSetter _setState;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController controller = TextEditingController();
        if(knowledgeInfo!=null){
          controller.text=knowledgeInfo.knowledge_name;
        }
        return AlertDialog(
          contentPadding: EdgeInsets.all(10.0),
          title: const Text('添加知识库'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            _setState = setState;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  readOnly:knowledgeInfo!=null,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "名字",
                    // border: const OutlineInputBorder(
                    //   borderRadius:
                    //       BorderRadius.all(Radius.circular(10.0)), //圆角边框
                    // ),
                  ),
                ),
                const SizedBox(height: 10),
                fileName.isNotEmpty? SelectionArea(
                  child: SizedBox(
                    height: 50,
                    width: 300,
                    child: Scaffold(
                      body: ListView.builder(
                          shrinkWrap: true,
                          itemCount: fileName.length,
                          itemBuilder: (context, index) {
                            return _buildListItem(context,index,_setState);
                          }),
                    ),
                  ),
                ):
                TextButton(
                  onPressed:
                      isButtonDisabled ? null : () => {_openFile1(_setState)},
                  child: const Row(
                    children: [
                      Text("点击上传文件",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // 设置字体粗细
                          )),
                      SizedBox(height: 30),
                      //       Spacer(), // 添加这个以增加间距

                      Icon(Icons.file_upload),
                    ],
                  ),
                )
              ],
            );
          }),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                print(controller.text);
                for (var i = 0; i < fileList.length; i++) {
                  File file = fileList[i];
                  var md51 = md5.convert(await file.readAsBytes());
                  int id =-1;
                  if(knowledgeInfo != null){
                    id=knowledgeInfo.id;
                  }
                  ApiService.uploadFileWithParams(
                      file.path, controller.text, md51.toString(),id);
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

  Widget _buildListItem(BuildContext context, int index,StateSetter _setState) {
    final theme = Theme.of(context);
    final downloadController = fileName[index];

    return ListTile(
      title: Text(
        downloadController,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall,
      ),
      trailing: IconButton(onPressed: (){
        _setState(() {
          fileList.removeAt(index);
          fileName.removeAt(index);
        });
      }, icon: Icon(Icons.delete)),
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
            itemCount: 1, // 设置为实际数据的长度
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
                  children:
                      List.generate(knowledgeInfoList.length + 1, (index) {
                    if (index == 0) {
                      return InkWell(
                          onTap: (){
                            _showEditDialog(null);
                          },
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
                              child: buildContent(
                                  knowledgeInfoList[index - 1], context)));
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      onTap:(){
                        _showEditDialog(knowledgeInfo);
                      },
                      child: const Icon(Icons.add_circle_outline,
                          size: 20,color: Colors.blueAccent),
                    ),
                    InkWell(
                      onTap: () {
                        editTitleDialog(context, knowledgeInfo.knowledge_name,
                            knowledgeInfo.id, (s) {
                          if (knowledgeInfo.knowledge_name != s) {
                            ApiService.editKnowledgeName(knowledgeInfo.id, s)
                                .then((value) {
                              setState(() {});
                            });
                          }
                        });
                      },
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
                                        ApiService.delete_Knowledge(
                                                knowledgeInfo.id)
                                            .then((value) => setState(() {}));
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
