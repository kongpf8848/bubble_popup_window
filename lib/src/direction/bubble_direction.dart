import 'package:flutter/material.dart';

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

  bool get isVertical =>
      this == BubbleDirection.topStart ||
      this == BubbleDirection.topCenter ||
      this == BubbleDirection.topEnd ||
      this == BubbleDirection.bottomStart ||
      this == BubbleDirection.bottomCenter ||
      this == BubbleDirection.bottomEnd;

  bool get isHorizontal =>
      this == BubbleDirection.leftStart ||
          this == BubbleDirection.leftCenter ||
          this == BubbleDirection.leftEnd ||
          this == BubbleDirection.rightStart ||
          this == BubbleDirection.rightCenter ||
          this == BubbleDirection.rightEnd;

  //方向反转
  BubbleDirection operator ~() {
    switch (this) {
      case BubbleDirection.topStart:
        return BubbleDirection.bottomStart;
      case BubbleDirection.topCenter:
        return BubbleDirection.bottomCenter;
      case BubbleDirection.topEnd:
        return BubbleDirection.bottomEnd;
      case BubbleDirection.bottomStart:
        return BubbleDirection.topStart;
      case BubbleDirection.bottomCenter:
        return BubbleDirection.topCenter;
      case BubbleDirection.bottomEnd:
        return BubbleDirection.topEnd;
      case BubbleDirection.leftStart:
        return BubbleDirection.rightStart;
      case BubbleDirection.leftCenter:
        return BubbleDirection.rightCenter;
      case BubbleDirection.leftEnd:
        return BubbleDirection.rightEnd;
      case BubbleDirection.rightStart:
        return BubbleDirection.leftStart;
      case BubbleDirection.rightCenter:
        return BubbleDirection.leftCenter;
      case BubbleDirection.rightEnd:
        return BubbleDirection.leftEnd;
    }
  }
}
