import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_highlight/themes/a11y-light.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
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
  _showToast(String msg, {int? duration, int? position}) {
    FlutterToastr.show(msg, context, duration: duration, position: position);
  }
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    List msessage = [];
    bool isDarkMode=appState.isDarkMode;

    msessage.add({"user":"me","conter":"##这是一个标题"});
    msessage.add({"user":"me","conter":"#### 这是一个普通内容"});
    msessage.add({"user":"you","conter":  ""
        "这是一个普通内容 \r"
        "``` "
        "\r class MarkdownHelper {Map<String, Widget> getTitleWidget(m.Node node)  \r"
        "=> title.getTitleWidget(node);   \r Widget getPWidget(m.Element node) => p.getPWidget(node); \r"
        "Widget getPreWidget(m.Node node) => pre.getPreWidget(node); } \r"
        " ```"});

    return Scaffold(
      body: SelectionArea(
          child: ListView.builder(
              itemCount: msessage.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading:msessage[index]["user"]=="me" ?null :const CircleAvatar(child: Text("gpt")),
                    trailing:msessage[index]["user"]=="me" ?const CircleAvatar(child: Text("you")):null ,
                    title: Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width *
                              0.6, // 限制宽度
                        ),
                        alignment: msessage[index]["user"] == "me"
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: msessage[index]["user"]=="me"?
                          Container(
                              decoration: BoxDecoration(
                                color:isDarkMode?null:Colors.blue[100],
                                borderRadius: BorderRadius.circular(5),
                              ),
                            child: Text(msessage[index]["conter"])  ,
                          ):
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:isDarkMode?null:Colors.grey[200],
                                  borderRadius: BorderRadius.circular(5),
                              ),
                                margin: const EdgeInsets.only(right: 100,) ,
                                child: Column(
                                    children: getmd(context,msessage[index]["conter"])),
                              ),
                              Container(
                                  margin: const EdgeInsets.only(right: 100,) ,

                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [IconButton(onPressed: (){
                                      _showToast("复制成功");
                                      // Clipboard.setData(ClipboardData(text: msessage[index]["conter"]));
                                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      //   padding: EdgeInsets.only(bottom: 50),
                                      //   content: Text('复制成功'),
                                      // ));

                                    }, icon: Icon(Icons.copy_all,size: 20,))],)
                              )

                            ],

                          ),



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






