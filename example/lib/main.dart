import 'package:bubble_popup_window/bubble_popup_window.dart';
import 'package:example/pages/complex_example.dart';
import 'package:flutter/material.dart';
import 'package:example/pages/basic_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bubble PopupWindow Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Bubble PopupWindow Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(5),
                    color: const Color(0xff98e165),
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.top,
                    child: const Text(
                      "箭头向上的气泡",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(2),
                    color: const Color(0xff98e165),
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.bottom,
                    child: const Text(
                      "箭头向下的气泡",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(2),
                    color: Colors.red,
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.right,
                    child: const Text(
                      "箭头向右的气泡",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(2),
                    color: Colors.red,
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.left,
                    child: const Text(
                      "箭头向左的气泡",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    border: const BorderSide(width: 1.0, color: Colors.red),
                    arrowDirection: ArrowDirection.top,
                    child: const Text(
                      "带边框的气泡",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(2),
                    color: Colors.white,
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    shadows: [
                      BoxShadow(
                        blurRadius: 6,
                        spreadRadius: 1,
                        color: const Color(0xff000000).withOpacity(0.2),
                        offset: const Offset(0, 2),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.bottom,
                    child: const Text(
                      "带阴影的气泡",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(2),
                    color: Colors.blue,
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.right,
                    arrowOffset: 15,
                    child: const Text(
                      "箭头偏上的气泡",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  BubbleContainer(
                    padding: const EdgeInsets.all(2),
                    color: Colors.blue,
                    alignment: Alignment.center,
                    constraints:
                        const BoxConstraints(minWidth: 100, minHeight: 50),
                    borderRadius: BorderRadius.circular(4.0),
                    arrowDirection: ArrowDirection.left,
                    arrowOffset: 35,
                    arrowRadius: 2,
                    child: const Text(
                      "箭头偏下的气泡",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Builder(builder: (anchorContext) {
              return ElevatedButton(
                onPressed: () {
                  _showBubble(anchorContext);
                },
                child: const Text("ToolTip"),
              );
            }),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const BasicExample();
                  },
                ));
              },
              child: const Text("Basic Example"),
            ),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ComplexExample();
                  },
                ));
              },
              child: const Text("Complex Example"),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _showBubble(BuildContext anchorContext) {
    BubblePopupWindow.show(
      //锚点上下文
      anchorContext: anchorContext,
      //弹窗布局，用户自定义
      child: const Text(
        '这是一个气泡弹窗',
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.normal,
        ),
      ),
      //弹窗方向
      direction: BubbleDirection.bottomCenter,
      //弹窗颜色
      color: Colors.white,
      //弹窗圆角半径
      radius: BorderRadius.circular(8),
      //弹窗边框
      border: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
      //弹窗内边距
      padding: const EdgeInsets.all(16),
      //弹窗距离锚点间距
      gap: 4.0,
      //弹窗距离屏幕边缘最小间距
      miniEdgeMargin: const EdgeInsets.only(left: 10, right: 10),
      //遮罩层颜色
      maskColor: null,
      //点击弹窗外部时是否自动关闭弹窗
      dismissOnTouchOutside: true,
      //是否显示箭头
      showArrow: true,
      //箭头宽度
      arrowWidth: 12.0,
      //箭头高度
      arrowHeight: 6.0,
      //箭头半径
      arrowRadius: 2.0,
    );
  }
}
