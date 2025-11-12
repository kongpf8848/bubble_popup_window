import 'package:flutter/material.dart';

import 'package:bubble_popup_window/bubble_popup_window.dart';

class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  final List<String> menuList = ["分享", "保存", "取消"];
  final GlobalKey moreKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('BasicExample'),
        actions: [
          IconButton(
            key: moreKey,
            padding: EdgeInsets.zero,
            icon: Icon(Icons.adaptive.more),
            onPressed: () {
              _showBubblePopup(
                moreKey.currentContext!,
                BubbleDirection.bottomCenter,
              );
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 60,
            top: 120,
            child: _button(BubbleDirection.topStart),
          ),
          Positioned(
            left: 180,
            top: 120,
            child: _button(BubbleDirection.topCenter),
          ),
          Positioned(
            left: 300,
            top: 120,
            child: _button(BubbleDirection.topEnd),
          ),
          Positioned(
            left: 60,
            top: 200,
            child: _button(BubbleDirection.bottomStart),
          ),
          Positioned(
            left: 180,
            top: 200,
            child: _button(BubbleDirection.bottomCenter),
          ),
          Positioned(
            left: 300,
            top: 200,
            child: _button(BubbleDirection.bottomEnd),
          ),
          Positioned(
            left: 60,
            top: 280,
            child: _button(BubbleDirection.leftStart),
          ),
          Positioned(
            left: 180,
            top: 280,
            child: _button(BubbleDirection.leftCenter),
          ),
          Positioned(
            left: 300,
            top: 280,
            child: _button(BubbleDirection.leftEnd),
          ),
          Positioned(
            left: 60,
            top: 360,
            child: _button(BubbleDirection.rightStart),
          ),
          Positioned(
            left: 180,
            top: 360,
            child: _button(BubbleDirection.rightCenter),
          ),
          Positioned(
            left: 300,
            top: 360,
            child: _button(BubbleDirection.rightEnd),
          ),
        ],
      ),
    );
  }

  Widget _button(BubbleDirection position) {
    return Builder(
      builder: (anchorContext) {
        return GestureDetector(
          onTap: () {
            _showBubblePopup(anchorContext, position);
          },
          child: Container(
            height: 60,
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              position.name,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBubblePopup(BuildContext context, BubbleDirection bubblePosition) {
    List<Widget> children = [];

    Widget menuItem(int index, void Function() onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          width: 110,
          height: 40,
          //color: Colors.primaries[index % Colors.primaries.length],
          alignment: Alignment.center,
          child: Text(
            menuList[index],
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < menuList.length; i++) {
      children.add(menuItem(
        i,
        () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("你点击了:${menuList[i]}"),
          ));
          //close popup
          Navigator.of(context).pop();
        },
      ));
      if (i != menuList.length - 1) {
        children.add(Container(
          height: 1,
          width: 76,
          color: const Color(0XFFEDEDED),
        ));
      }
    }
    BubblePopupWindow.show(
      anchorContext: context,
      miniEdgeMargin: const EdgeInsets.only(left: 10, right: 10),
      direction: bubblePosition,
      color: Colors.white,
      border: const BorderSide(color: Colors.blue),
      radius: BorderRadius.circular(6),
      shadows: [
        BoxShadow(
          blurRadius: 6, // Shadow range
          spreadRadius: 1, // Shadow density
          color: const Color(0xff000000).withOpacity(0.2), // Shadow color
          offset: const Offset(0, 2),
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
