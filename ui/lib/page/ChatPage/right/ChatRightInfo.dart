import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:provider/provider.dart';

import '../../md/code_wrapper.dart';
import '../../state.dart';

class ChatRightInfo extends StatefulWidget {
  const ChatRightInfo({super.key});

  @override
  _ChatRightInfo createState() => _ChatRightInfo();
}

class _ChatRightInfo extends State<ChatRightInfo> {
  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List msessage = [];
    bool isDarkMode = appState.isDarkMode;

    msessage.add({"user": "me", "conter": "##这是一个标题"});
    msessage.add({"user": "me", "conter": "#### 这是一个普通内容"});
    msessage.add({"user": "you", "conter": "#### 这是一个普通内容"});
    msessage.add({"user": "you", "conter": "#### 这是一个普通内容"});
    msessage.add({"user": "you", "conter": "#### 这是一个普通内容"});
    msessage.add({"user": "you", "conter": "这是一个普通内容"});
    msessage.add({
      "user": "you",
      "conter": ""
          "### 这是一个普通内容 \r"
          "``` "
          "\r class MarkdownHelper {Map<String, Widget> getTitleWidget(m.Node node)  \r"
          "=> title.getTitleWidget(node);   \r Widget getPWidget(m.Element node) => p.getPWidget(node); \r"
          "Widget getPreWidget(m.Node node) => pre.getPreWidget(node); } \r"
          " ```"
    });

    return Scaffold(
      body: SelectionArea(
        child: ListView.builder(
            itemCount: msessage.length,
            itemBuilder: (context, index) {
              return ListTile(
                  leading: msessage[index]["user"] == "me"
                      ? null
                      : const CircleAvatar(child: Text("gpt")),
                  trailing: msessage[index]["user"] == "me"
                      ? const CircleAvatar(child: Text("you"))
                      : null,
                  title: Column(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width * 0.6, // 限制宽度
                        ),
                        alignment: msessage[index]["user"] == "me"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: msessage[index]["user"] == "me"
                            ? Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDarkMode ? null : Colors.blue[100],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(msessage[index]["conter"]),
                              )
                            : Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          isDarkMode ? null : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: getmd(context,
                                            msessage[index]["conter"])),
                                  ),
                                ],
                              ),
                      ),
                      msessage[index]["user"] == "me"
                          ? Row()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Clipboard.setData(ClipboardData(text: msessage[index]["conter"]));
                                      _showToast("复制成功");
                                    },
                                    icon: Icon(
                                      Icons.copy_all,
                                      size: 15,
                                    ))
                              ],
                            )
                    ],
                  ));
            }),
      ),
    );
  }
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
        : PreConfig().copy(
            wrapper: codeWrapper, padding: EdgeInsets.only(top: 20, bottom: 0))
  ]);

  return MarkdownGenerator().buildWidgets(
    data,
    config: config1,
  );
}
