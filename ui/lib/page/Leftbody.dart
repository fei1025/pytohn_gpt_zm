import 'package:flutter/material.dart';

class Leftbody extends StatelessWidget {
  const Leftbody({super.key});
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Expanded(
          //空间占比组件
          flex: 1, //空间占比
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0), //填充
            child: Text("logo"), //logo实现
          ),
        ),
        Expanded(
          //空间占比组件
          flex: 1, //空间占比
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //child: User(), //User
          ),
        ),
        Expanded(
          //空间占比组件
          flex: 1, //空间占比
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
            //child: Friends(), //Friends
          ),
        ),
      ],
    );
  }
}