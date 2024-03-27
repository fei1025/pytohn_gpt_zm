import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

void editTitleDialog(BuildContext context, String title, int chatId, Function(String) onConfirm) async {
  TextEditingController controller = TextEditingController();
  controller.text = title;

  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('修改'),
        content: TextField(
          controller: controller,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              onConfirm(controller.text); // Execute callback on confirmation
              Navigator.of(context).pop();
            },
            child: Text('确认'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 取消
            },
            child: Text('取消'),
          ),
        ],
      );
    },
  );
}

void showToastr(String msg,BuildContext context, {int? duration, int? position}){
    FlutterToastr.show(msg, context, duration: duration, position: position);
}

void progressBarDialog(){

}


