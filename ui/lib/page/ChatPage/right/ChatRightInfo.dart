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
    var appState = context.read<MyAppState>();
    List<String> msessage = [];
    msessage.add("### 这是一个标题");
    msessage.add("这是一个普通内容");
    msessage.add(
        ""
            "这是一个普通内容"
            "```   "
            "class MarkdownHelper {Map<String, Widget> getTitleWidget(m.Node node) "
            "=> title.getTitleWidget(node);Widget getPWidget(m.Element node) => p.getPWidget(node);"
            "Widget getPreWidget(m.Node node) => pre.getPreWidget(node); }"
            "```");
    bool isDarkMode = appState.isDarkMode;
    final config =
    isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);
    return ListView.builder(
        itemCount: msessage.length,
        itemBuilder: (context, index) {
          return  ListTile(title:Container(child: Column(
              children: MarkdownGenerator(
                  ).buildWidgets(msessage[index]))));

        });
  }
}