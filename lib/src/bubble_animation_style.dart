import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

enum BubbleAnimationType {
  fade, // 淡入淡出
  scale, // 缩放
  custom, // 自定义
}

class BubbleAnimationStyle {
  final BubbleAnimationType type;
  final Duration duration;
  final Curve curve;
  final Curve? reverseCurve;

  const BubbleAnimationStyle({
    this.type = BubbleAnimationType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.linear,
    this.reverseCurve,
  });

  // 预定义动画样式
  static const BubbleAnimationStyle fade = BubbleAnimationStyle(
    type: BubbleAnimationType.fade,
    curve: Curves.easeOut,
  );

  static const BubbleAnimationStyle scale = BubbleAnimationStyle(
    type: BubbleAnimationType.scale,
    curve: Curves.easeOut,
  );
}
