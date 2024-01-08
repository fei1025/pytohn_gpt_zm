// https://cloud.tencent.com/developer/article/2112778?areaId=106001
// https://cloud.tencent.com/developer/article/2112771


import 'package:flutter/material.dart';
import 'package:open_ui/page/ChatPage/ChatPageMain.dart';
import 'package:open_ui/page/FavoritesPage.dart';
import 'package:open_ui/page/knowledge/KnowledgePage.dart';
import 'package:open_ui/page/setting/SettingPage.dart';
import 'package:open_ui/page/api/api_service.dart';
import 'package:open_ui/page/state.dart';
import 'package:open_ui/windowsUtil.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  createWindowsinit();
  runApp(const MyApp());
}

// https://blog.csdn.net/yujiayinshi/article/details/131184825

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MyAppState()),
        ],
        child: Consumer<MyAppState>(builder: (context, themeProvider, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: const Locale('zh', 'CN'),
            // 设置默认语言为简体中文
            title: 'openAi',
            //theme:themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            theme: ThemeData(
              useMaterial3: true,
              //primarySwatch: Colors.blue,
               //colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
              visualDensity: VisualDensity.adaptivePlatformDensity,
              brightness:themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
            ),
            home: MyHomePage(),
          );
        }));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? selectedIndex = 0; // ← Add this property.
  var curSelectedIndex = 0;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // 在这里执行初始化操作，此时可以访问到 context。
      init(context);
    });
  }
  void _demo() {
    final appState = context.read<MyAppState>();
    appState.toggleTheme();

  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // ← Add this.
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var appState = context.watch<MyAppState>();

    Widget buildPage() {
      switch (curSelectedIndex) {
        case 0:
          return ChatPageMain();
        case 1:
          return KnowledgePage();
        case 2:
          return SettingPage();
        default:
          throw UnimplementedError('no widget for $selectedIndex');
      }
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
                    label: Text('知识库'),
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
                            icon: appState.isDarkMode? const Icon(Icons.brightness_5_outlined):const Icon(Icons.brightness_2_outlined),
                          ),
                           Text(
                            appState.isDarkMode?"月":"日",
                            style: TextStyle(fontSize: 12.0),
                          ),
                          IconButton(onPressed: (){
                            setState(() {
                              curSelectedIndex = 2;
                              selectedIndex=null;
                            });
                          }, icon: const Icon(Icons.settings)),
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
                    curSelectedIndex = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: buildPage(),
            ),
          ),
        ],
      ),
    );
  }
}


void init(BuildContext context){
  ApiService.getAllHist("0").then((value) =>context.read<MyAppState>().setChatHistList(value));
}
