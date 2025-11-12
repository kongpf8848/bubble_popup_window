import 'package:bubble_popup_window/bubble_popup_window.dart';
import 'package:bubble_popup_window/src/direction/direction_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Duration _kDuration = Duration(milliseconds: 300);

class BubblePopupWindow {
  static void show({
    //锚点上下文
    required BuildContext anchorContext,
    //弹窗布局，用户自定义
    required Widget child,
    //弹窗方向
    BubbleDirection direction = BubbleDirection.bottomCenter,
    //弹窗颜色
    Color color = Colors.white,
    //弹窗圆角半径
    BorderRadius? radius = BorderRadius.zero,
    //弹窗边框
    BorderSide border = BorderSide.none,
    //弹窗阴影
    List<BoxShadow>? shadows,
    //弹窗内边距
    EdgeInsetsGeometry? padding,
    //弹窗距离锚点间距
    double gap = 0.0,
    //弹窗距离屏幕边缘最小间距
    EdgeInsets miniEdgeMargin = EdgeInsets.zero,
    //遮罩层颜色
    Color? maskColor,
    //点击弹窗外部时是否自动关闭弹窗
    bool dismissOnTouchOutside = true,
    //是否显示箭头
    bool showArrow = true,
    //箭头宽度
    double arrowWidth = 10.0,
    //箭头高度
    double arrowHeight = 5.0,
  }) {
    final routeLayout = _BubblePopupRouteLayout(
      anchorContext: anchorContext,
      direction: direction,
      gap: gap,
      miniEdgeMargin: miniEdgeMargin,
      showArrow: showArrow,
      arrowWidth: arrowWidth,
      arrHeight: arrowHeight,
      arrowColor: color,
    );

    var widget = ValueListenableBuilder(
      valueListenable: routeLayout.offsetNotifier,
      builder: (BuildContext context, Offset offset, Widget? child) {
        var direction = routeLayout.lastDireciton ?? routeLayout.direction;
        double? arrowOffset;
        if (offset != Offset.zero) {
          if (direction.isVertical) {
            arrowOffset = routeLayout.anchorRect.center.dx - offset.dx;
          } else if (direction.isHorizontal) {
            arrowOffset = routeLayout.anchorRect.center.dy - offset.dy;
          }
        }
        return BubbleContainer(
          borderRadius: radius,
          border: border,
          shadows: shadows,
          padding: padding,
          color: color,
          showArrow: showArrow,
          arrowWidth: arrowWidth,
          arrowHeight: arrowHeight,
          arrowRadius: 0.0,
          arrowOffset: arrowOffset,
          arrowDirection: bubbleToArrow(direction),
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        type: MaterialType.transparency,
        child: child,
      ),
    );

    Navigator.of(anchorContext).push(
      _BubblePopupRoute(
        maskColor: maskColor,
        dismissOnTouchOutside: dismissOnTouchOutside,
        child: CustomSingleChildLayout(
          delegate: routeLayout,
          child: widget,
        ),
      ),
    );
  }
}

class _BubblePopupRoute<T> extends PopupRoute<T> {
  final Color? maskColor;
  final bool dismissOnTouchOutside;
  final Widget child;

  _BubblePopupRoute({
    required this.maskColor,
    required this.dismissOnTouchOutside,
    required this.child,
  });

  @override
  String? get barrierLabel => null;

  @override
  Color? get barrierColor => maskColor;

  @override
  bool get barrierDismissible => dismissOnTouchOutside;

  @override
  Duration get transitionDuration => _kDuration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    print("+++++++++++++++++buildPage:$child");
    return child;
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    print("+++++++++++++++++buildTransitions:$child");
    return super
        .buildTransitions(context, animation, secondaryAnimation, child);
  }

  @override
  TickerFuture didPush() {
    print("++++++++++++++++didPush");
    return super.didPush();
  }
}

class _BubblePopupRouteLayout extends SingleChildLayoutDelegate {
  final BuildContext anchorContext;
  final BubbleDirection direction;
  final double gap;
  final EdgeInsets miniEdgeMargin;
  final bool showArrow;
  final double arrowWidth;
  final double arrHeight;
  final Color arrowColor;
  Rect anchorRect = Rect.zero;
  Size childSize = Size.zero;

  BubbleDirection? lastDireciton;

  final ValueNotifier<Offset> offsetNotifier = ValueNotifier(Offset.zero);

  _BubblePopupRouteLayout({
    required this.anchorContext,
    required this.direction,
    required this.gap,
    required this.miniEdgeMargin,
    required this.showArrow,
    required this.arrowWidth,
    required this.arrHeight,
    required this.arrowColor,
  }) {
    final RenderBox anchor = anchorContext.findRenderObject()! as RenderBox;
    final RenderBox overlay = Navigator.of(anchorContext)
        .overlay!
        .context
        .findRenderObject()! as RenderBox;
    final Offset offset = anchor.localToGlobal(Offset.zero, ancestor: overlay);
    anchorRect = Rect.fromLTWH(
        offset.dx, offset.dy, anchor.size.width, anchor.size.height);
    lastDireciton = direction;
  }

  @override
  bool shouldRelayout(covariant _BubblePopupRouteLayout oldDelegate) {
    return true;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    print(
        "++++++++++++++++BubblePopupRouteLayout getSize，constraints:$constraints");
    return super.getSize(constraints);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    print(
        "++++++++++++++++BubblePopupRouteLayout getConstraintsForChild，constraints:$constraints");
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    print(
        "++++++++++++++++BubblePopupRouteLayout getPositionForChild，Size:$size,childSize:$childSize");

    EdgeInsets systemPadding =
        MediaQuery.of(Navigator.of(anchorContext).overlay!.context).padding;
    EdgeInsets padding = systemPadding + miniEdgeMargin;
    Rect boundaryRect = Rect.fromLTRB(padding.left, padding.top,
        size.width - padding.right, size.height - padding.bottom);
    var popRect = calculateRect(direction, childSize, gap);
    lastDireciton = _adjustDirection(direction, boundaryRect, popRect);
    if (lastDireciton != direction) {
      popRect = calculateRect(lastDireciton!, childSize, gap);
    }
    popRect = _keepInside(boundaryRect, popRect);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      offsetNotifier.value = popRect.topLeft;
    });
    return popRect.topLeft;
  }

  //计算弹窗展示区域
  Rect calculateRect(BubbleDirection direction, Size targetSize, double gap) {
    var dx = (anchorRect.width + targetSize.width) / 2 + gap;
    var dy = (anchorRect.height + targetSize.height) / 2 + gap;
    Offset offset;
    switch (direction) {
      case BubbleDirection.topStart:
        offset = Offset((targetSize.width - anchorRect.width) / 2, -dy);
        break;
      case BubbleDirection.topCenter:
        offset = Offset(0, -dy);
        break;
      case BubbleDirection.topEnd:
        offset = Offset((anchorRect.width - targetSize.width) / 2, -dy);
        break;
      case BubbleDirection.bottomStart:
        offset = Offset((targetSize.width - anchorRect.width) / 2, dy);
        break;
      case BubbleDirection.bottomCenter:
        offset = Offset(0, dy);
        break;
      case BubbleDirection.bottomEnd:
        offset = Offset((anchorRect.width - targetSize.width) / 2, dy);
        break;
      case BubbleDirection.leftStart:
        offset = Offset(-dx, (targetSize.height - anchorRect.height) / 2);
        break;
      case BubbleDirection.leftCenter:
        offset = Offset(-dx, 0);
        break;
      case BubbleDirection.leftEnd:
        offset = Offset(-dx, (anchorRect.height - targetSize.height) / 2);
        break;
      case BubbleDirection.rightStart:
        offset = Offset(dx, (targetSize.height - anchorRect.height) / 2);
        break;
      case BubbleDirection.rightCenter:
        offset = Offset(dx, 0);
        break;
      case BubbleDirection.rightEnd:
        offset = Offset(dx, (anchorRect.height - targetSize.height) / 2);
        break;
    }
    Offset center = anchorRect.center.translate(offset.dx, offset.dy);
    return Rect.fromCenter(
        center: center, width: targetSize.width, height: targetSize.height);
  }

  //调整弹窗方向
  BubbleDirection _adjustDirection(
      BubbleDirection direction, Rect container, Rect child) {
    switch (direction) {
      case BubbleDirection.topStart:
      case BubbleDirection.topCenter:
      case BubbleDirection.topEnd:
        if (child.top < container.top) {
          return ~direction;
        }
        break;
      case BubbleDirection.bottomStart:
      case BubbleDirection.bottomCenter:
      case BubbleDirection.bottomEnd:
        if (child.bottom > container.bottom) {
          return ~direction;
        }
        break;
      case BubbleDirection.leftStart:
      case BubbleDirection.leftCenter:
      case BubbleDirection.leftEnd:
        if (child.left < container.left) {
          return ~direction;
        }
        break;
      case BubbleDirection.rightStart:
      case BubbleDirection.rightCenter:
      case BubbleDirection.rightEnd:
        if (child.right > container.right) {
          return ~direction;
        }
        break;
    }
    return direction;
  }

  //保持child在parent范围内
  Rect _keepInside(Rect parent, Rect child) {
    if (child.left < parent.left ||
        child.right > parent.right ||
        child.top < parent.top ||
        child.bottom > parent.bottom) {
      double dx = 0;
      double dy = 0;

      if (child.left < parent.left) {
        dx = parent.left - child.left;
      } else if (child.right > parent.right) {
        dx = parent.right - child.right;
      }
      if (child.top < parent.top) {
        dy = parent.top - child.top;
      } else if (child.bottom > parent.bottom) {
        dy = parent.bottom - child.bottom;
      }
      return child.shift(Offset(dx, dy));
    } else {
      return child;
    }
  }
}
