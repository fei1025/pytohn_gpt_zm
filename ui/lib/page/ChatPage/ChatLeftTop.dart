// ignore_for_file: library_private_types_in_public_api

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../state.dart';

class ChatLeftTop extends StatefulWidget {
  @override
  _ChatLeftTop createState() => _ChatLeftTop();
}

class _ChatLeftTop extends State<ChatLeftTop> {
  // final FocusNode _focusNode = FocusNode();
  // final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    //_focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    // _focusNode.addListener(() {
    //   appState.setIsIconVisible(_focusNode.hasFocus);
    // });
    // void _clearTextField() {
    //   _textController.clear();
    // }

    return Row(children: [
      // Expanded(
      //   flex: 6,
      //   child: Container(
      //     height: 50,
      //     // color: Colors.cyan,
      //     margin: const EdgeInsets.only(left: 5, right: 0, top: 25, bottom: 10),
      //     decoration: BoxDecoration(
      //       // color: Colors.grey.withAlpha(40),
      //       borderRadius: BorderRadius.circular(10), // 设置圆角半径
      //     ),
      //     //padding: EdgeInsets.only(left: 5, bottom: 0),
      //     child: TextField(
      //         focusNode: _focusNode,
      //         controller: _textController,
      //         style: const TextStyle(fontSize: 12),
      //         onChanged: (String s) {
      //           print("输入的文章$s");
      //         },
      //         decoration: InputDecoration(
      //             prefixIcon: appState.isIconVisible
      //                 ? null
      //                 : const Icon(
      //                     Icons.search,
      //                     size: 20,
      //                   ),
      //             contentPadding:
      //                 const EdgeInsets.only(bottom: 1, top: 2, left: 10),
      //             filled: true,
      //             hintText: appState.isIconVisible ? null : "搜索",
      //             fillColor: Colors.grey.withAlpha(0),
      //             // 设置输入框背景色为灰色,并设置透明度
      //             border: const OutlineInputBorder(
      //               borderRadius:
      //                   BorderRadius.all(Radius.circular(10.0)), //圆角边框
      //
      //             ),
      //             suffixIcon: appState.isIconVisible
      //                 ? InkWell(
      //                     onTap: _clearTextField,
      //                     child: const Icon(
      //                       Icons.close,
      //                       size: 20,
      //                     ),
      //                   )
      //                 : null
      //
      //             )),
      //   ),
      // ),
      Expanded(
        flex: 7,
        child: Container(
          //color: Colors.lightBlue,
          // margin: const EdgeInsets.only(right: 15,top: 25,bottom: 10,left: 5),
          padding: const EdgeInsets.only(left: 0, bottom: 0, top: 15),
          child: TextButton(onPressed: () {
            appState.setTitle(-1);
            appState.setCuChatId(null);
            appState.setChatDetails([]);
          }, child:Row(children:[ const SizedBox(width: 10),Icon(Icons.add),Text("新的聊天",style: TextStyle(
            fontWeight: FontWeight.bold, // 设置字体粗细
          ))],),
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
                              ApiService.delete_all_chat();
                              ApiService.getAllHist("0").then((value) =>context.read<MyAppState>().setChatHistList(value));
                              appState.setTitle(-1);
                              appState.setCuTitle("");
                              appState.setCuChatId(null);
                              appState.setChatDetails([]);
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
      )
    ]);
  }
}
