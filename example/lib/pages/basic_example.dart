import 'package:flutter/material.dart';
import 'package:bubble_popup_window/bubble_popup_window.dart';

class BasicExample extends StatefulWidget {
  const BasicExample({super.key});

  @override
  State<BasicExample> createState() => _BasicExampleState();
}

class _BasicExampleState extends State<BasicExample> {
  final List<String> _menuList = ["分享", "保存", "取消"];
  final _colorMap = {
    "白色": Colors.white,
    "红色": Colors.red,
    "绿色": Colors.blue,
    "蓝色": Colors.green,
  };

  final GlobalKey moreKey = GlobalKey();

  Color _color = Colors.white;
  Color? _borderColor;
  BubbleDirection _direction = BubbleDirection.bottomCenter;
  bool _showArrow = true;
  bool _showBorder = false;
  bool _dismissOnTouchOutside = true;
  double _gap = 0.0;
  double _radius = 0.0;

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
                );
              },
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                "弹窗显示方向:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              DropdownMenu<BubbleDirection>(
                width: 180,
                initialSelection: _direction,
                onSelected: (BubbleDirection? direction) {
                  _direction = direction!;
                },
                dropdownMenuEntries: BubbleDirection.values
                    .map<DropdownMenuEntry<BubbleDirection>>(
                        (BubbleDirection direction) {
                  return DropdownMenuEntry(
                    value: direction,
                    label: direction.name,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Text(
                "弹窗背景颜色:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              DropdownMenu<Color>(
                width: 180,
                initialSelection: _color,
                leadingIcon: SizedBox(
                    width: 50,
                    height: 50,
                    child: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _color,
                          border: _color == Colors.white
                              ? Border.all(color: Colors.grey)
                              : null,
                        ),
                      ),
                    )),
                onSelected: (Color? color) {
                  setState(() {
                    _color = color!;
                  });
                },
                dropdownMenuEntries: List.generate(_colorMap.length, (index) {
                  return DropdownMenuEntry(
                    label: _colorMap.keys.elementAt(index),
                    value: _colorMap.values.elementAt(index),
                    leadingIcon: Container(
                      width: 40,
                      height: 40,
                      color: _colorMap.values.elementAt(index),
                    ),
                  );
                }),
              )
            ],
          ),
        ),
        SwitchListTile(
          title: const Text(
            "是否显示边框:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          value: _showBorder,
          onChanged: (bool newValue) {
            setState(() {
              _showBorder = newValue;
              if (newValue) {
                _borderColor ??= _colorMap.values.first;
              }
            });
          },
        ),
        if (_showBorder)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  "边框颜色:",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const Spacer(),
                DropdownMenu<Color>(
                  width: 180,
                  initialSelection: _borderColor,
                  leadingIcon: SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _borderColor,
                            border: _borderColor == Colors.white
                                ? Border.all(color: Colors.grey)
                                : null,
                          ),
                        ),
                      )),
                  onSelected: (Color? color) {
                    setState(() {
                      _borderColor = color!;
                    });
                  },
                  dropdownMenuEntries: List.generate(_colorMap.length, (index) {
                    return DropdownMenuEntry(
                      label: _colorMap.keys.elementAt(index),
                      value: _colorMap.values.elementAt(index),
                      leadingIcon: Container(
                        width: 40,
                        height: 40,
                        color: _colorMap.values.elementAt(index),
                      ),
                    );
                  }),
                )
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                "弹窗圆角半径(${_radius.toStringAsFixed(1)}):",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Slider(
                  min: 0,
                  max: 20,
                  value: _radius,
                  onChanged: (double newValue) {
                    setState(() {
                      _radius = newValue;
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                "弹窗距离锚点的间距(${_gap.toStringAsFixed(1)}):",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              Slider(
                  min: 0,
                  max: 20,
                  value: _gap,
                  onChanged: (double newValue) {
                    setState(() {
                      _gap = newValue;
                    });
                  })
            ],
          ),
        ),
        SwitchListTile(
          title: const Text(
            "是否显示箭头:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          value: _showArrow,
          onChanged: (bool newValue) {
            setState(() {
              _showArrow = newValue;
            });
          },
        ),
        SwitchListTile(
          title: const Text(
            "点击弹窗外部是否关闭弹窗:",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          value: _dismissOnTouchOutside,
          onChanged: (bool newValue) {
            setState(() {
              _dismissOnTouchOutside = newValue;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        _button(),
      ],
    );
  }

  Widget _button() {
    return Builder(
      builder: (anchorContext) {
        return GestureDetector(
          onTap: () {
            _showBubblePopup(anchorContext);
          },
          child: Container(
            height: 60,
            width: 120,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.red,
              ),
            ),
            alignment: Alignment.center,
            child: const Text(
              "点我显示菜单",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showBubblePopup(BuildContext context) {
    List<Widget> children = [];
    Widget menuItem(int index, void Function() onTap) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          width: 90,
          height: 40,
          //color: Colors.primaries[index % Colors.primaries.length],
          alignment: Alignment.center,
          child: Text(
            _menuList[index],
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    for (int i = 0; i < _menuList.length; i++) {
      children.add(menuItem(
        i,
        () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("你点击了:${_menuList[i]}"),
          ));
          //close popup
          Navigator.of(context).pop();
        },
      ));
    }
    BubblePopupWindow.show(
      anchorContext: context,
      miniEdgeMargin: const EdgeInsets.only(left: 10, right: 10),
      direction: _direction,
      color: _color,
      border: (_showBorder && _borderColor != null)
          ? BorderSide(color: _borderColor!)
          : null,
      gap: _gap,
      radius: BorderRadius.circular(_radius),
      showArrow: _showArrow,
      dismissOnTouchOutside: _dismissOnTouchOutside,
      shadows: [
        BoxShadow(
          blurRadius: 6,
          spreadRadius: 1,
          color: const Color(0xff000000).withOpacity(0.2),
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
