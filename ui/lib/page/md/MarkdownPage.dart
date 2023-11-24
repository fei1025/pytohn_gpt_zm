import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/config/markdown_generator.dart';
import 'package:markdown_widget/config/toc.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/blocks/leaf/link.dart';
import 'package:markdown_widget/widget/markdown.dart';
import 'package:provider/provider.dart';

import '../state.dart';
import 'code_wrapper.dart';
import 'markdown_custom/custom_node.dart';
import 'markdown_custom/latex.dart';
import 'markdown_custom/video.dart';

class MarkdownPage extends StatelessWidget {
  final String data;

  MarkdownPage(this.data);

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    bool isDarkMode = appState.isDarkMode;
    final config =
        isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);
    final config1 = config.copy(configs: [
      LinkConfig(
        style: TextStyle(
          color: Colors.red,
          decoration: TextDecoration.underline,
        ),
        onTap: (url) {
          ///TODO:on tap
        },
      ),
      isDarkMode
          ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
          : PreConfig().copy(wrapper: codeWrapper)
    ]);
    // return Column(children: MarkdownGenerator().buildWidgets(data,config:config1
    // ),);

    return  MarkdownWidget(
      data: data,
      config: config.copy(configs: [
        isDarkMode
            ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
            : PreConfig().copy(wrapper: codeWrapper)
      ]),
      markdownGenerator: MarkdownGenerator(
          generators: [videoGeneratorWithTag, latexGenerator],
          inlineSyntaxList: [LatexSyntax()],
          textGenerator: (node, config, visitor) =>
              CustomTextNode(node.textContent, config, visitor)),
    );
  }

  Widget buildMarkdown(BuildContext context) {
    final TocController controller = TocController();
    var appState = context.watch<MyAppState>();
    bool isDarkMode = appState.isDarkMode;
    final config =
        isDarkMode ? MarkdownConfig.darkConfig : MarkdownConfig.defaultConfig;
    codeWrapper(child, text) => CodeWrapperWidget(child: child, text: text);
    return MarkdownWidget(
        data: data,
        config: config.copy(configs: [
          isDarkMode
              ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
              : PreConfig().copy(wrapper: codeWrapper)
        ]),
        tocController: controller,
        markdownGenerator: MarkdownGenerator(
            generators: [videoGeneratorWithTag, latexGenerator],
            inlineSyntaxList: [LatexSyntax()],
            textGenerator: (node, config, visitor) =>
                CustomTextNode(node.textContent, config, visitor)));
  }
}
