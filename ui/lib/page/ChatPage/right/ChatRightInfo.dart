import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:markdown_widget/config/all.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:open_ui/page/model/ChatDetails.dart';
import 'package:provider/provider.dart';
import '../../md/code_wrapper.dart';
import '../../state.dart';

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
    return list.length == 0
        ? const Center(child: Text("今天我能帮助你吗?"))
        : Scaffold(
            body: ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  ChatDetails chatDetails = list[index];
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
                                          decoration: BoxDecoration(
                                            color: isDarkMode
                                                ? null
                                                : Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.only(
                                              right: 10, left: 10),
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: getmd(context,
                                                  chatDetails.content)),
                                        ),
                                        Visibility(
                                          visible: chatDetails.other_data != null,
                                          /// 隐藏时是否保持占位
                                          maintainState: false,
                                          /// 隐藏时是否保存动态状态
                                          maintainAnimation: false,
                                          /// 隐藏时是否保存子组件所占空间的大小，不会消耗过多的性能
                                          maintainSize: false,
                                          child: SizedBox(
                                            height: 50,
                                            child: Scaffold(
                                              body: ListView.builder(
                                                  itemCount: chatDetails
                                                      .other_data?.length,
                                                  itemBuilder: (context, index) {
                                                    return Text(chatDetails.other_data![index]);
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                          chatDetails.role == "user"
                              ? const Row()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                              text: chatDetails.content));
                                          _showToast("复制成功");
                                        },
                                        child: const Icon(
                                          Icons.copy_all,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                        ],
                      ));
                }),
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
        : const PreConfig().copy(
            wrapper: codeWrapper, padding: EdgeInsets.only(top: 20, bottom: 0))
  ]);

  return MarkdownGenerator().buildWidgets(
    data,
    config: config1,
  );
}
