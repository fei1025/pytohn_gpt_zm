import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/blocks/leaf/link.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';

import '../../md/MarkdownPage.dart';
import '../../md/code_wrapper.dart';
import '../../state.dart';

class ChatRightInfo extends StatefulWidget {
  const ChatRightInfo({super.key});

  @override
  _ChatRightInfo createState() => _ChatRightInfo();
}

class _ChatRightInfo extends State<ChatRightInfo> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List msessage = [];

    msessage.add({"user":"me","conter":"## 这是一个标题"});
    msessage.add({"user":"me","conter":"#### 这是一个普通内容"});
    msessage.add({"user":"you","conter":  ""
        "这是一个普通内容"
        "``` "
        "class MarkdownHelper {Map<String, Widget> getTitleWidget(m.Node node) "
        "=> title.getTitleWidget(node);Widget getPWidget(m.Element node) => p.getPWidget(node);"
        "Widget getPreWidget(m.Node node) => pre.getPreWidget(node); }"
        " ```"});

    return Scaffold(
      body: SelectionArea(
          child: ListView.builder(
              itemCount: msessage.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:msessage[index]["user"]=="me" ?CircleAvatar(child: Text("you"),) :CircleAvatar(child: Text("gpt"),),
                    title: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width *
                              0.6, // 限制宽度
                        ),
                        alignment: msessage[index]["user"] == "me"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,                        child: Column(
                            children: getmd(context,msessage[index]["conter"]))


                    ));
              }),
      ),
    );
  }
}


List<Widget> getmd(BuildContext  context,String data){
  var appState = context.watch<MyAppState>(); // 使用 context.watch 监听 MyAppsState 的变化
  bool isDarkMode = appState.isDarkMode;
  final config =
  isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
  codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);
  final config1 = config.copy(configs: [
    isDarkMode? PreConfig.darkConfig.copy(wrapper: codeWrapper): PreConfig().copy(wrapper: codeWrapper)
  ]);

  return MarkdownGenerator().buildWidgets(data,config: config1
  );
}






