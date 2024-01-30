import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/knowledge/right/KnowledgeRightHorizontalList.dart';
import 'package:open_ui/page/knowledge/right/KnowledgeRightInfo.dart';
import 'package:open_ui/page/knowledge/right/KnowledgeRightTop.dart';
import 'package:open_ui/page/model/knowledgeInfo.dart';
import 'package:open_ui/page/state.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:window_manager/window_manager.dart';

class KnowledgeRight extends StatefulWidget {
  const KnowledgeRight({super.key});

  @override
  State<KnowledgeRight> createState() => _KnowledgeRightState();
}

class _KnowledgeRightState extends State<KnowledgeRight> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: GestureDetector(  behavior: HitTestBehavior.translucent,
            onPanUpdate: (details) {
              // 处理拖动事件
              windowManager.startDragging();
            }, child: KnowledgeRightTop())),
        const Divider(
          height: 0.1,
        ),
         Expanded(flex: 9, child: appState.knowledgeIndex== -1? const HorizontalList():const KnowledgeRightInfo())
      ],
    );
  }
}

