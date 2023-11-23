
// ignore_for_file: library_private_types_in_public_api, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import '../../state.dart';

class ChatRightTop extends StatefulWidget {
  @override
  _ChatRightTop createState() => _ChatRightTop();
}

class _ChatRightTop extends State<ChatRightTop> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  bool isMax = false;

  @override
  void initState() {
    super.initState();

    // 在 initState 中执行异步操作
    windowManager.isMaximized().then((value) {
      setState(() {
        isMax = value;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: Container(
          height: 20,
          margin: EdgeInsets.only(top: 20,right: 5),
          padding: EdgeInsets.only(top: 5,left: 5,bottom: 5),
          child: MyPopupMenuButton(),
        ),
        title: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("这是标题"),
              Text(
                "这是副标题",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        actions: [
          SizedBox(
            // color: Colors.lightBlue,
            width: 150,
            height: 200,
            child: Transform.translate(
                offset: const Offset(0, -16), // 控制水平偏移量
                child: const windRightButton()),
          )
        ],
      ),
    );
  }
}
class MyPopupMenuButton extends StatefulWidget {
  @override
  _MyPopupMenuButtonState createState() => _MyPopupMenuButtonState();
}

class _MyPopupMenuButtonState extends State<MyPopupMenuButton> {
  String selectedValue = 'Option 1'; // 初始选中的值
  List<String> menuItems = ['Option 1', 'Option 2', 'Option 3'];

  @override
  Widget build(BuildContext context) {
    //Color buttonColor = Theme.of(context).buttonTheme.colorScheme!.primary;
   TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;
    return PopupMenuButton<String>(
      onSelected: (String value) {
        setState(() {
          selectedValue = value;
        });
      },
      itemBuilder: (BuildContext context) {
        return menuItems.map((String item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList();
      },
      offset: Offset(0, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(selectedValue,style: textStyle,), // 显示选中的值
          SizedBox(width: 8),
          Icon(Icons.arrow_drop_down), // 向下箭头图标
        ],
      ), // 设置弹出菜单的位置
    );
  }
}

class windRightButton extends StatefulWidget {
  const windRightButton({super.key});

  @override
  _windRightButton createState() => _windRightButton();
}

class _windRightButton extends State<windRightButton> {
  bool isMax = false;
  bool isAlway = false;


  @override
  void initState() {
    super.initState();
    // 在 initState 中执行异步操作
    windowManager.isMaximized().then((value) {
      setState(() {
        isMax = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Theme.of(context).buttonTheme.colorScheme!.primary;
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  isAlway = !isAlway;
                  windowManager.setAlwaysOnTop(isAlway);
                });
              },
              child: Container(
                padding: const EdgeInsets.only(top: 5),
                color: !isAlway?null:Colors.black12,
                child: SvgPicture.asset(
                  "assets/images/nail.svg",
                  colorFilter:ColorFilter.mode(buttonColor, BlendMode.srcIn),
                  width: 28,
                ),
              ),
            )),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                windowManager.minimize();
              },
              child: Icon(Icons.minimize),
            )),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                //filter_none
                //windowManager.maximize();

                if (isMax) {
                  windowManager.unmaximize();
                } else {
                  windowManager.maximize();
                }
                setState(() {
                  isMax = !isMax;
                });
              },
              child: isMax ? Icon(Icons.filter_none) : Icon(Icons.crop_square),
            )),
        Expanded(
            flex: 1,
            child: InkWell(
              hoverColor: Colors.red, // 悬浮的颜色
              onTap: () {
                windowManager.close();
              },
              child: Icon(
                Icons.close_sharp,
                weight: 100,
              ),
            )),
      ],
    );
  }
}
