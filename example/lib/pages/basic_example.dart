import 'package:flutter/material.dart';

import 'package:bubble_popup_window/bubble_popup_window.dart';

class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  final List<String> menuList = ["Share", "Save", "Cancel"];
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
                BubblePopupPosition.bottomEnd,
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
            left: 80,
            top: 120,
            child: _button(BubblePopupPosition.topStart),
          ),
          Positioned(
            left: 180,
            top: 120,
            child: _button(BubblePopupPosition.topCenter),
          ),
          Positioned(
            left: 280,
            top: 120,
            child: _button(BubblePopupPosition.topEnd),
          ),
          Positioned(
            left: 80,
            top: 200,
            child: _button(BubblePopupPosition.bottomStart),
          ),
          Positioned(
            left: 180,
            top: 200,
            child: _button(BubblePopupPosition.bottomCenter),
          ),
          Positioned(
            left: 280,
            top: 200,
            child: _button(BubblePopupPosition.bottomEnd),
          ),
          Positioned(
            left: 80,
            top: 280,
            child: _button(BubblePopupPosition.leftStart),
          ),
          Positioned(
            left: 180,
            top: 280,
            child: _button(BubblePopupPosition.leftCenter),
          ),
          Positioned(
            left: 280,
            top: 280,
            child: _button(BubblePopupPosition.leftEnd),
          ),
          Positioned(
            left: 80,
            top: 360,
            child: _button(BubblePopupPosition.rightStart),
          ),
          Positioned(
            left: 180,
            top: 360,
            child: _button(BubblePopupPosition.rightCenter),
          ),
          Positioned(
            left: 280,
            top: 360,
            child: _button(BubblePopupPosition.rightEnd),
          ),
        ],
      ),
    );
  }

  Widget _button(BubblePopupPosition position) {
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

  void _showBubblePopup(
      BuildContext context, BubblePopupPosition popupPosition) {
    List<Widget> children = [];

    Widget menuItem(String text, void Function() onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          width: 100,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            text,
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
        menuList[i],
        () {
          //close popup
          Navigator.of(context).pop();
          print("+++++++++onMenuTap:${menuList[i]}");
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
      popupPosition: popupPosition,
      miniEdgeMargin: const EdgeInsets.only(left: 10, right: 10),
      arrowColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              blurRadius: 6, // Shadow range
              spreadRadius: 1, // Shadow density
              color: const Color(0xFF000000).withOpacity(0.2), // Shadow color
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
