import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';

import '../../MarkdownPage.dart';
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
        "```class MarkdownHelper {Map<String, Widget> getTitleWidget(m.Node node) => title.getTitleWidget(node);Widget getPWidget(m.Element node) => p.getPWidget(node);"
            "Widget getPreWidget(m.Node node) => pre.getPreWidget(node); }```");
    // TODO: implement build
    return ListView.builder(
        itemCount: msessage.length,
        itemBuilder: (context, index) {
          return Container( width: 100,height: 100,child: MarkdownPage(msessage[index])) ;
          // return Column(children: MarkdownGenerator().buildWidgets(msessage[index],
          //   // appState.isDarkMode?MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig
          //   config:MarkdownConfig(configs: [
          //     PreConfig(theme: a11yLightTheme, language: 'dart'),
          //   ])
          //));
        });
  }
}