# Bubble Popup Window

一个功能强大的Flutter气泡弹窗库，提供带箭头指示器的浮动弹窗组件。

[![pub package](https://img.shields.io/pub/v/bubble_popup_window?label=bubble_popup_window&color=green)](https://pub.dev/packages/bubble_popup_window)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/kongpf8848/bubble_popup_window/refs/heads/master/LICENSE)

## 截图

<div style="display: flex;">
  <img src="https://raw.githubusercontent.com/kongpf8848/bubble_popup_window/refs/heads/master/screenshots/screenshot_1.png" width=30%>
  <img src="https://raw.githubusercontent.com/kongpf8848/bubble_popup_window/refs/heads/master/screenshots/screenshot_2.png" width=30%>
  <img src="https://raw.githubusercontent.com/kongpf8848/bubble_popup_window/refs/heads/master/screenshots/screenshot_3.png" width=30%>
</div>

## 功能特性

- 🎯 **12种定位选项**：支持上下左右各个方向及对齐方式的弹窗定位
- 🔄 **智能调整位置**：自动检测边界并调整弹窗位置确保完全可见
- 🎨 **高度可定制**：支持自定义弹窗背景、圆角、间距、箭头大小和颜色等
- 🎭 **功能丰富**：支持点击外部关闭弹窗、设置遮罩层颜色等功能

## 安装

在pubspec.yaml文件中添加依赖：

```yaml
dependencies:
  bubble_popup_window: ^0.0.9
```

## 使用

```dart
import 'package:bubble_popup_window/bubble_popup_window.dart';

GlobalKey key = GlobalKey();

ElevatedButton(
  key: key,
  onPressed: () {
    _showToolTip(key.currentContext!);
  },
  child: const Text("Tooltip"),
)

void _showToolTip(BuildContext anchorContext) {
  BubblePopupWindow.show(
    //锚点上下文
    anchorContext: anchorContext,
    //弹窗打开回调
    onPopupOpened: (){
      debugPrint("+++++++++++++++++onPopupOpened");
    },
    //弹窗关闭回调
    onPopupClosed: (){
      debugPrint("+++++++++++++++++onPopupClosed");
    },
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
    //箭头颜色，为 null 时跟随弹窗颜色
    arrowColor: Colors.red,
  );
}

```
anchorContext 用于确定锚点的位置和尺寸，可通过以下方式获取：
- ‌使用GlobalKey
  
  为组件设置GlobalKey后，通过key.currentContext!获取上下文
  
  ```dart
  GlobalKey key = GlobalKey();
  ElevatedButton(
    key: key,
  )
  
  //获取上下文
  BuildContext anchorContext = key.currentContext!;
  ```
 
- 使用Builder组件
  
  通过Builder组件的回调函数直接获取anchorContext
  ```dart
  Builder(
    builder: (BuildContext anchorContext) {
      //在此使用anchorContext
      return Container();
    }
  )
  ```
  
## 参数说明

| 参数名                     | 类型                    | 默认值                            | 描述           |
|:------------------------|:----------------------|:-------------------------------|:-------------|
| `anchorContext`         | `BuildContext`        | 无                              | 锚点上下文        |
| `onPopupOpened`         | `VoidCallback?`       | 无                              | 弹窗打开回调        |
| `onPopupClosed`         | `VoidCallback?`       | 无                              | 弹窗关闭回调        |
| `child`                 | `Widget`              | 无                              | 弹窗内容，用户自定义   |
| `direction`             | `BubbleDirection`     | `BubbleDirection.bottomCenter` | 弹窗方向         |
| `color`                 | `Color`               | `Colors.white`                 | 弹窗颜色         |
| `radius`                | `BorderRadius`        | `BorderRadius.zero`            | 弹窗圆角半径       |
| `border`                | `BorderSide`          | `BorderSide.none`              | 弹窗边框         |
| `shadows`               | `List<BoxShadow>?`    | 无                              | 弹窗阴影         |
| `padding`               | `EdgeInsetsGeometry?` | 无                              | 弹窗内边距        |
| `gap`                   | `double`              | `0.0`                          | 弹窗距离锚点的间距    |
| `maskColor`             | `Color?`              | `null`                         | 遮罩层颜色        |
| `dismissOnTouchOutside` | `bool`                | `true`                         | 点击弹窗外部是否关闭弹窗 |
| `miniEdgeMargin`        | `EdgeInsets`          | `EdgeInsets.zero`              | 弹窗距离屏幕边缘最小间距 |
| `showArrow`             | `bool`                | `true`                         | 是否显示箭头       |
| `arrowWidth`            | `Double`              | `10.0`                         | 箭头宽度         |
| `arrowHeight`           | `Double`              | `5.0`                          | 箭头高度         |
| `arrowRadius`           | `Double`              | `0.0`                          | 箭头半径         |
| `arrowColor`            | `Color?`              | `null`                         | 箭头颜色，为空时跟随弹窗颜色 |


## 弹窗方向选项

`BubbleDirection` 枚举提供了以下12种位置选项：

- **上方**: `topStart`, `topCenter`, `topEnd`
- **下方**: `bottomStart`, `bottomCenter`, `bottomEnd`
- **左侧**: `leftStart`, `leftCenter`, `leftEnd`
- **右侧**: `rightStart`, `rightCenter`, `rightEnd`
```dart
enum BubbleDirection {
  //弹窗在锚点上方，和锚点左边对齐
  topStart,
  //弹窗在锚点上方，和锚点居中对齐
  topCenter,
  //弹窗在锚点上方，和锚点右边对齐
  topEnd,

  //弹窗在锚点下方，和锚点左边对齐
  bottomStart,
  //弹窗在锚点下方，和锚点居中对齐
  bottomCenter,
  //弹窗在锚点下方，和锚点右边对齐
  bottomEnd,

  //弹窗在锚点左侧，和锚点顶部对齐
  leftStart,
  //弹窗在锚点左侧，和锚点居中对齐
  leftCenter,
  //弹窗在锚点左侧，和锚点底部对齐
  leftEnd,

  //弹窗在锚点右侧，和锚点顶部对齐
  rightStart,
  //弹窗在锚点右侧，和锚点居中对齐
  rightCenter,
  //弹窗在锚点右侧，和锚点底部对齐
  rightEnd;
}
```

## 许可证

[MIT License](https://raw.githubusercontent.com/kongpf8848/bubble_popup_window/refs/heads/master/LICENSE)
