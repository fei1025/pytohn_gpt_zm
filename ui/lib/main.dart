// https://cloud.tencent.com/developer/article/2112778?areaId=106001
// https://cloud.tencent.com/developer/article/2112771

import 'dart:io';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:open_ui/page/ChatPage/ChatPageMain.dart';
import 'package:open_ui/page/FavoritesPage.dart';
import 'package:open_ui/page/GeneratorPage/generator.dart';
import 'package:open_ui/windowsUtil.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async  {
  createWindowsinit();
  runApp(MyApp());
}

// https://blog.csdn.net/yujiayinshi/article/details/131184825

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'openAi',
        theme: ThemeData(
          brightness:Brightness.dark,
          useMaterial3: true,
          //colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
          // colorScheme: ColorScheme.dark().copyWith(
          //     primary:ColorScheme.fromSeed(seedColor: Colors.red).primary
          //
          // ),

        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {

  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }


  int titleIndex =-1;
  void setTitle(int index){
    titleIndex=index;
    notifyListeners();

  }



  // ↓ Add the code below.
  var favorites = <WordPair>[];


}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.
  bool isDarkMode = false;


void _demo(){

  final appState = context.read<MyAppState>();
  appState.toggleTheme();}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);       // ← Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ChatPageMain();
        break;
      case 1:
        page = FavoritesPage();
        break;
      case 2:
        page = GeneratorPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: GestureDetector(
              onPanUpdate: (details) {
                // 处理拖动事件
                windowManager.startDragging();
              },
              // 删除这里的 child 参数
              child: NavigationRail(
                extended: false,
                elevation: 1,
                labelType: NavigationRailLabelType.all,

                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('聊天'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('收藏'),
                  ),
                ],
                trailing: Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: _demo, // 添加新聊天
                            icon: const Icon(Icons.telegram),
                          ),
                          const Text(
                            "主题",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          IconButton(
                            onPressed: _demo, // 添加新聊天
                            icon: const Icon(Icons.settings),
                          ),
                          const Text(
                            "设置",
                            style: TextStyle(fontSize: 12.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}
