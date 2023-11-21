// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state.dart';

class ChatTitleCard extends StatefulWidget {
  final String title;
  final int curIndex;
  final int selectIndex;
  final VoidCallback onTap;
  const ChatTitleCard({super.key, required this.title, required this.curIndex,required this.onTap, required this.selectIndex,

  });

  @override
  _ChatTitleCardState createState() => _ChatTitleCardState();
}

class _ChatTitleCardState extends State<ChatTitleCard> {
  bool isHovered = false;
  var isSelect =false;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var titleIndex = appState.titleIndex;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onHover: (bool key){
          setState(() {
            isHovered=key;
          });
        },
        onTap: () {
          widget.onTap();
          setState(() {
            isSelect=true;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.curIndex == titleIndex ? !appState.isDarkMode? Theme.of(context).primaryColor:Theme.of(context).primaryColorDark.withOpacity(0.5): Colors.transparent ,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),

          ),
          child: ListTile(
            minLeadingWidth:10,
            minVerticalPadding:10,
            dense: true,
            selected: widget.curIndex == titleIndex,
            // leading: true
            //     ? null
            //     : const Padding(
            //   padding: EdgeInsets.only(left: 1, top: 3),
            //   child: Icon(Icons.chat_bubble_outline, size: 15),
            // ),
            title: Text(widget.title),
            trailing: isHovered ||  (widget.curIndex == titleIndex)?
                Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.translate(
                  offset: const Offset(10, 0), // 控制水平偏移量
                  child:     InkWell(
                    onTap:(){print("点击修改了");},
                    child: const Icon(Icons.edit, size: 18, color: Colors.blueAccent),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(10, 0), // 控制水平偏移量
                  child:     InkWell(
                    onTap:(){print("点击修改了");},
                    child:  Icon(Icons.delete_outlined, size: 18, color:Colors.red.shade400),
                  ),
                ),
              ],
            ):null,
          ),
        ),
      ),
    );
  }
}
