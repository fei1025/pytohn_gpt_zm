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
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // ↓ Add this.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // ↓ Add the code below.
  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.
void _demo(){

  print("object");
}

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
