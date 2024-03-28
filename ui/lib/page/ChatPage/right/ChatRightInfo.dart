import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/model/ChatDetails.dart';
import 'package:provider/provider.dart';
import '../../md/code_wrapper.dart';
import '../../state.dart';
import 'dart:ui' as ui;

@override
bool shouldRepaint(CustomPainter oldDelegate) {
  return false;
}

class ChatRightInfo extends StatefulWidget {
  const ChatRightInfo({super.key});

  @override
  _ChatRightInfo createState() => _ChatRightInfo();
}

class _ChatRightInfo extends State<ChatRightInfo> {
  final ScrollController _scrollController = ScrollController();

  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scrollController.positions.isNotEmpty) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        // 处理ScrollController未连接到滚动视图的情况
      }
    });
    _scrollController.addListener(() {
      //判断是否到底
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
    });

    var appState = context.watch<MyAppState>();
    List<ChatDetails> list = appState.chatDetailsList;
    bool isDarkMode = appState.isDarkMode;
    Map<String, Widget> iconMap = appState.iconMap;

    return list.isEmpty
        ? const Center(child: Text("今天我能帮助你吗?"))
        : Scaffold(
            body: ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  ChatDetails chatDetails = list[index];
                  List<Widget> listInfo = [];
                  String tools="";
                  final toolList = chatDetails.toolList;
                  if (toolList != null) {
                    List<Widget> aa = toolList.map((e) {
                      tools=tools+e.tools;
                      return Container(
                          alignment: Alignment.centerLeft, // 将容器左对齐
                          padding: const EdgeInsets.only(bottom: 1),
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              e.isLoad? const CircularProgressIndicator(color: Colors.black54, strokeWidth: 2): e.isExpanded? getToolDetail(context, e, () {
                                          setState(() {
                                            e.isExpanded = false;
                                          });
                                        })
                                      : InkWell(
                                          onTap: () {
                                            setState(() {
                                              e.isExpanded = true;
                                            });
                                          },
                                          child: iconMap[e.tools] ?? CircleAvatar( child: Text(e.tools[0]))),
                            ],
                          ));
                    }).toList();
                    listInfo.addAll(aa);
                  }
                  bool isDownload=tools.contains("lobe_image_designer");

                  return ListTile(
                      leading: chatDetails.role != "user"
                          ? const CircleAvatar(
                              child: Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text("gpt"),
                            ))
                          : null,
                      trailing: chatDetails.role == "user"
                          ? const CircleAvatar(child: Text("you"))
                          : null,
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SelectionArea(
                            child: Container(
                              padding: chatDetails.role != "user"
                                  ? const EdgeInsets.only(top: 30)
                                  : const EdgeInsets.only(top: 10),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width *
                                    0.6, // 限制宽度
                              ),
                              alignment: chatDetails.role == "user"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: chatDetails.role == "user"
                                  ? Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: isDarkMode
                                            ? null
                                            : Colors.blue[100],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(chatDetails.content),
                                    )
                                  : Column(
                                      children: [
                                        Container(
                                          alignment:
                                              Alignment.centerLeft, // 将容器左对齐
                                          padding:
                                              const EdgeInsets.only(bottom: 1),
                                          child: Column(
                                            children: listInfo,
                                          ),
                                        ),
                                        Container(
                                          alignment:
                                              Alignment.centerLeft, // 将容器左对齐
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: isDarkMode
                                                  ? null
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            padding: const EdgeInsets.only(
                                                right: 10, left: 10),
                                            child: Column(mainAxisSize: MainAxisSize.min,children: getmd(context, chatDetails.content)),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          chatDetails.role == "user" ? const Row(): Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Tooltip(
                                        message:"复制原文",
                                        child: InkWell(
                                          onTap: () {
                                            Clipboard.setData(ClipboardData(
                                                text: chatDetails.content));
                                            _showToast("复制成功");
                                          },
                                          child: const Icon(
                                            Icons.copy_all,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    isDownload?Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Tooltip(
                                        message: "下载回复中的所有图片",
                                        child: InkWell(
                                          onTap: () {
                                            FilePicker.platform.getDirectoryPath().then((value){
                                              final toolList1 = chatDetails.toolList;
                                              toolList1?.forEach((element) {
                                                List<String> images = jsonDecode(element.tool_data).cast<String>();
                                                images.forEach((element) {
                                                  double num=0;
                                                  ApiService().downloadFile(element,value!,(int totalBytes,int contentLength){


                                                  },(String path){

                                                    _showToast("下载成功,保存地址${path}");
                                                    num=0;

                                                  });
                                                });
                                              });
                                            });
                                          },
                                          child: const Icon(
                                            Icons.download,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ):const Row(),
                                  ],
                                )
                        ],
                      ));
                }),
          );
  }
}

Widget getToolDetail(BuildContext context, ToolList data, Function() onComplete) {
  var appState =context.watch<MyAppState>(); // 使用 context.watch 监听 MyAppsState 的变化
  bool isDarkMode = appState.isDarkMode;
  return Column(
    children: [
      Container(
          alignment: Alignment.centerLeft,
          //margin: const EdgeInsets.only(left: 0,),
          child:Row(
            mainAxisSize: MainAxisSize.min, // 这将使 Row 只占用所需的最小空间

            children:[ TextButton(

              onPressed: () {
                onComplete();
              },
              child: Text("收起"),


            )],
          )
      ),
      const SizedBox(height: 5),
      Container(
        alignment: Alignment.centerLeft, // 将容器左对齐
        child: Container(
          decoration: BoxDecoration(
            color: isDarkMode ? null : Colors.grey[200],
            borderRadius: BorderRadius.circular(5),
          ),
          padding: const EdgeInsets.only(right: 10, left: 10),
            constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width *
            0.59, // 限制宽度
            ),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: getmd(
                  context, "问题: \n ${data.problem} \r\n 回答: \n ${data.tool_data}")),
        ),
      )
    ],
  );
}

List<Widget> getmd(BuildContext context, String data) {
  var appState =
      context.watch<MyAppState>(); // 使用 context.watch 监听 MyAppsState 的变化
  bool isDarkMode = appState.isDarkMode;
  final config =
      isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
  codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);
  final config1 = config.copy(configs: [
    isDarkMode
        ? PreConfig.darkConfig.copy(
            wrapper: codeWrapper,
          )
        : const PreConfig().copy(
            wrapper: codeWrapper, padding: EdgeInsets.only(top: 20, bottom: 0))
  ]);

  return MarkdownGenerator().buildWidgets(
    data,
    config: config1,
  );
}
