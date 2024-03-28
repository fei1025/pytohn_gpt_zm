import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:open_ui/page/model/ChatDetails.dart';
import 'package:open_ui/page/model/Chat_hist_list.dart';
import 'package:open_ui/page/uiModule/uiModel.dart';
import 'package:provider/provider.dart';

import '../../api/api_service.dart';
import '../../state.dart';

class ChatRightSenMsg extends StatefulWidget {
  final Function onPressedWithParam;

  ChatRightSenMsg({super.key, required this.onPressedWithParam});

  @override
  State<ChatRightSenMsg> createState() => _ChatRightSenMsg();
}

class _ChatRightSenMsg extends State<ChatRightSenMsg> {
  final TextEditingController _controller = TextEditingController();
  //List<bool> _isCheckedList = [false, true, false];
  List<ToolsSelect> _isCheckedList = [];

  void _sendMessage(MyAppState appState) async {
    if (_controller.text.isNotEmpty) {
      widget.onPressedWithParam(_controller.text);
    }
  }


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isDarkMode = appState.isDarkMode;
    return Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween, // 添加这一行
            children: [
          Expanded(
            flex: 1,
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      ApiService.getAllToolList().then((value){
                        int? chatId = appState.cuChatId;
                        // if(chatId == null){
                        //   showToastr("请选择一个对话",context);
                        //   return;
                        // }
                        if(appState.cuChatHist!=null){
                          String tools=appState.cuChatHist!.tools;
                          _isCheckedList=value.map((e) =>  ToolsSelect(toolsName: e["name"],isSelect: tools.contains(e["key"]),key:e["key"],details: e["details"])).toList();
                        }else{
                          _isCheckedList=value.map((e) =>  ToolsSelect(toolsName: e["name"],isSelect: false,key:e["key"],details: e["details"])).toList();
                        }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: const Text('插件'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: List.generate(
                                            _isCheckedList.length,
                                                (index) {
                                              return CheckboxListTile(
                                                title: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [Text(_isCheckedList[index].toolsName),SizedBox(width:20),
                                                  Tooltip(
                                                      message:_isCheckedList[index].details ,
                                                      child: Icon(Icons.question_mark,size: 15,semanticLabel:_isCheckedList[index].details,color:Colors.red))],),
                                                value: _isCheckedList[index].isSelect,
                                                onChanged: (bool? value) {
                                                  setState(() {
                                                    _isCheckedList[index].isSelect = value!;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            String s="";
                                            _isCheckedList.map((e){
                                              if(e.isSelect){
                                                s=s+","+e.key;
                                              }
                                            }).toString();
                                            if(s.length >1){
                                              s=s.substring(1);
                                            }
                                            print("选择的数据:${s}");
                                            if(chatId == null){
                                              appState.setCurSelectTool(s);
                                            }else{
                                              ApiService.update_chat(chatId, null,null,s).then((value) {
                                                appState.setCuChatHistTools(s);
                                              });
                                            }
                                            Navigator.of(context).pop(); // Close the dialog

                                          },
                                          child: Text('确认'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('Close'),
                                        )
                                      ],
                                    );
                                  });
                            });
                      });

                    },
                    icon: Icon(Icons.add))
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Stack(children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.68,
                child: TextField(
                  controller: _controller,
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: '输入消息',
                    fillColor: isDarkMode ? null : Colors.grey[200],
                    // 输入框背景颜色
                    //filled: true,
                    // 启用填充背景颜色
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      // 输入框圆角
                      //borderSide: BorderSide.none, // 移除边框
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                top: 60,
                child: IconButton(
                  icon: appState.isSend
                      ? const Icon(Icons.stop_circle_rounded)
                      : const Icon(Icons.send),
                  onPressed: () {
                    if (!appState.isSend) {
                      _sendMessage(appState);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ]),
          ),
        ]));
  }
}
class ToolsSelect{
  String toolsName;
  bool isSelect;
  String key;
  String details;
  ToolsSelect({required this.toolsName,required this.isSelect,required this.key,required this.details});
}

