import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Duration _kDuration = Duration(milliseconds: 300);

enum BubblePopupPosition {
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

  double angle() {
    switch (this) {
      case BubblePopupPosition.topStart:
      case BubblePopupPosition.topCenter:
      case BubblePopupPosition.topEnd:
        return 0.0;
      case BubblePopupPosition.bottomStart:
      case BubblePopupPosition.bottomCenter:
      case BubblePopupPosition.bottomEnd:
        return math.pi;
      case BubblePopupPosition.leftStart:
      case BubblePopupPosition.leftCenter:
      case BubblePopupPosition.leftEnd:
        return -math.pi / 2;
      case BubblePopupPosition.rightStart:
      case BubblePopupPosition.rightCenter:
      case BubblePopupPosition.rightEnd:
        return math.pi / 2;
    }
  }
}

enum _Id {
  pop,
  arrow,
}

class BubblePopupWindow {
  static void show({
    //锚点上下文
    required BuildContext anchorContext,
    //弹窗布局，用户自定义
    required Widget child,
    //弹窗方向
    BubblePopupPosition popupPosition = BubblePopupPosition.bottomCenter,
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
    //箭头大小
    Size arrowSize = const Size(10.0, 5.0),
    //箭头颜色
    Color arrowColor = Colors.white,
  }) {
    final routeLayout = _BubblePopupRouteLayout(
      anchorContext: anchorContext,
      popupPosition: popupPosition,
      gap: gap,
      miniEdgeMargin: miniEdgeMargin,
      showArrow: showArrow,
      arrowSize: arrowSize,
      arrowColor: arrowColor,
    );
    var layout = CustomMultiChildLayout(
      delegate: routeLayout,
      children: [
        LayoutId(
          id: _Id.pop,
          child: Material(
            color: Colors.transparent,
            child: child,
          ),
        ),
        if (showArrow)
          LayoutId(
            id: _Id.arrow,
            child: _Arrow(
              positionNotifier: routeLayout.positionNotifier,
              arrowSize: arrowSize,
              arrowColor: arrowColor,
            ),
          ),
      ],
    );
    Navigator.of(anchorContext).push(
      _BubblePopupRoute(
        maskColor: maskColor,
        dismissOnTouchOutside: dismissOnTouchOutside,
        layout: layout,
      ),
    );
  }
}

class _ArrowClipper extends CustomClipper<Path> {
  const _ArrowClipper();

  @override
  Path getClip(Size size) {
    var width = size.width;
    var height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(width, 0);
    path.lineTo(width / 2, height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _Arrow extends StatelessWidget {
  final ValueNotifier<BubblePopupPosition> positionNotifier;
  final Size arrowSize;
  final Color arrowColor;

  const _Arrow({
    required this.positionNotifier,
    required this.arrowSize,
    required this.arrowColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<BubblePopupPosition>(
      valueListenable: positionNotifier,
      builder: (context, value, child) {
        return Transform.rotate(
          angle: value.angle(),
          child: ClipPath(
            clipper: const _ArrowClipper(),
            child: Container(
              width: arrowSize.width,
              height: arrowSize.height,
              color: arrowColor,
            ),
          ),
        );
      },
    );
  }
}

class _BubblePopupRoute<T> extends PopupRoute<T> {
  final Color? maskColor;
  final bool dismissOnTouchOutside;
  final Widget layout;

  _BubblePopupRoute({
    required this.maskColor,
    required this.dismissOnTouchOutside,
    required this.layout,
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
    return layout;
  }
}

class _BubblePopupRouteLayout extends MultiChildLayoutDelegate {
  final BuildContext anchorContext;
  BubblePopupPosition popupPosition;
  final double gap;
  final EdgeInsets miniEdgeMargin;
  final bool showArrow;
  final Size arrowSize;
  final Color arrowColor;
  Rect anchorRect = Rect.zero;

  final ValueNotifier<BubblePopupPosition> _positionNotifier =
      ValueNotifier(BubblePopupPosition.bottomCenter);

  ValueNotifier<BubblePopupPosition> get positionNotifier => _positionNotifier;

  _BubblePopupRouteLayout({
    required this.anchorContext,
    required this.popupPosition,
    required this.gap,
    required this.miniEdgeMargin,
    required this.showArrow,
    required this.arrowSize,
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
    positionNotifier.value = popupPosition;
  }

  @override
  void performLayout(Size size) {
    EdgeInsets systemPadding =
        MediaQuery.of(Navigator.of(anchorContext).overlay!.context).padding;
    EdgeInsets padding = systemPadding + miniEdgeMargin;
    Rect boundaryRect = Rect.fromLTRB(padding.left, padding.top,
        size.width - padding.right, size.height - padding.bottom);
    Rect outRect = getOutRect(boundaryRect);
    BubblePopupPosition newPopupPosition = popupPosition;

    //定位pop
    if (hasChild(_Id.pop)) {
      var popSize = layoutChild(_Id.pop, BoxConstraints.loose(size));
      var popRect = getRect(_Id.pop, popupPosition, popSize, arrowHeight + gap);
      newPopupPosition = _adjustPosition(popupPosition, outRect, popRect);
      if (newPopupPosition != popupPosition) {
        popRect =
            getRect(_Id.pop, newPopupPosition, popSize, arrowHeight + gap);
      }
      popRect = _keepInside(boundaryRect, popRect);

      positionChild(_Id.pop, popRect.topLeft);
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _positionNotifier.value = newPopupPosition;
    });

    //定位arrow
    if (hasChild(_Id.arrow)) {
      var arrowSize = layoutChild(_Id.arrow, BoxConstraints.loose(size));
      var arrowRect = getRect(_Id.arrow, newPopupPosition, arrowSize, gap);
      positionChild(_Id.arrow, arrowRect.topLeft);
    }
  }

  @override
  bool shouldRelayout(covariant MultiChildLayoutDelegate oldDelegate) {
    return true;
  }

  double get arrowHeight => showArrow ? arrowSize.height : 0.0;

  ///获取pop所在的边界范围
  Rect getOutRect(Rect boundaryRect) {
    switch (popupPosition) {
      case BubblePopupPosition.topStart:
        return Rect.fromLTRB(
          anchorRect.left,
          boundaryRect.top,
          boundaryRect.right,
          anchorRect.top - arrowHeight,
        );
      case BubblePopupPosition.topCenter:
        return Rect.fromLTRB(
          boundaryRect.left,
          boundaryRect.top,
          boundaryRect.right,
          anchorRect.top - arrowHeight,
        );
      case BubblePopupPosition.topEnd:
        return Rect.fromLTRB(
          boundaryRect.left,
          boundaryRect.top,
          anchorRect.right,
          anchorRect.top - arrowHeight,
        );
      case BubblePopupPosition.bottomStart:
        return Rect.fromLTRB(
          anchorRect.left,
          anchorRect.bottom + arrowHeight,
          boundaryRect.right,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.bottomCenter:
        return Rect.fromLTRB(
          boundaryRect.left,
          anchorRect.bottom + arrowHeight,
          boundaryRect.right,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.bottomEnd:
        return Rect.fromLTRB(
          boundaryRect.left,
          anchorRect.bottom + arrowHeight,
          anchorRect.right,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.leftStart:
        return Rect.fromLTRB(
          boundaryRect.left,
          anchorRect.top,
          anchorRect.left - arrowHeight,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.leftCenter:
        return Rect.fromLTRB(
          boundaryRect.left,
          boundaryRect.top,
          anchorRect.left - arrowHeight,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.leftEnd:
        return Rect.fromLTRB(
          boundaryRect.left,
          boundaryRect.top,
          anchorRect.left - arrowHeight,
          anchorRect.bottom,
        );
      case BubblePopupPosition.rightStart:
        return Rect.fromLTRB(
          anchorRect.right + arrowHeight,
          anchorRect.top,
          boundaryRect.right,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.rightCenter:
        return Rect.fromLTRB(
          anchorRect.right + arrowHeight,
          boundaryRect.top,
          boundaryRect.right,
          boundaryRect.bottom,
        );
      case BubblePopupPosition.rightEnd:
        return Rect.fromLTRB(
          anchorRect.right + arrowHeight,
          boundaryRect.top,
          anchorRect.right,
          boundaryRect.bottom,
        );
    }
  }

  Rect getRect(
      _Id id, BubblePopupPosition popupPosition, Size targetSize, double gap) {
    var dx = (anchorRect.width + targetSize.width) / 2 + gap;
    var dy = (anchorRect.height + targetSize.height) / 2 + gap;

    if (id == _Id.arrow &&
        (popupPosition == BubblePopupPosition.leftStart ||
            popupPosition == BubblePopupPosition.leftCenter ||
            popupPosition == BubblePopupPosition.leftEnd ||
            popupPosition == BubblePopupPosition.rightStart ||
            popupPosition == BubblePopupPosition.rightCenter ||
            popupPosition == BubblePopupPosition.rightEnd)) {
      dx = (anchorRect.width + targetSize.height) / 2 + gap;
    }
    Offset offset;
    BubblePopupPosition position = popupPosition;
    if (id == _Id.arrow) {
      switch (position) {
        case BubblePopupPosition.topStart:
        case BubblePopupPosition.topCenter:
        case BubblePopupPosition.topEnd:
          position = BubblePopupPosition.topCenter;
          break;
        case BubblePopupPosition.bottomStart:
        case BubblePopupPosition.bottomCenter:
        case BubblePopupPosition.bottomEnd:
          position = BubblePopupPosition.bottomCenter;
          break;
        case BubblePopupPosition.leftStart:
        case BubblePopupPosition.leftCenter:
        case BubblePopupPosition.leftEnd:
          position = BubblePopupPosition.leftCenter;
          break;
        case BubblePopupPosition.rightStart:
        case BubblePopupPosition.rightCenter:
        case BubblePopupPosition.rightEnd:
          position = BubblePopupPosition.rightCenter;
          break;
      }
    }
    switch (position) {
      case BubblePopupPosition.topStart:
        offset = Offset((targetSize.width - anchorRect.width) / 2, -dy);
        break;
      case BubblePopupPosition.topCenter:
        offset = Offset(0, -dy);
        break;
      case BubblePopupPosition.topEnd:
        offset = Offset((anchorRect.width - targetSize.width) / 2, -dy);
        break;
      case BubblePopupPosition.bottomStart:
        offset = Offset((targetSize.width - anchorRect.width) / 2, dy);
        break;
      case BubblePopupPosition.bottomCenter:
        offset = Offset(0, dy);
        break;
      case BubblePopupPosition.bottomEnd:
        offset = Offset((anchorRect.width - targetSize.width) / 2, dy);
        break;
      case BubblePopupPosition.leftStart:
        offset = Offset(-dx, (targetSize.height - anchorRect.height) / 2);
        break;
      case BubblePopupPosition.leftCenter:
        offset = Offset(-dx, 0);
        break;
      case BubblePopupPosition.leftEnd:
        offset = Offset(-dx, (anchorRect.height - targetSize.height) / 2);
        break;
      case BubblePopupPosition.rightStart:
        offset = Offset(dx, (targetSize.height - anchorRect.height) / 2);
        break;
      case BubblePopupPosition.rightCenter:
        offset = Offset(dx, 0);
        break;
      case BubblePopupPosition.rightEnd:
        offset = Offset(dx, (anchorRect.height - targetSize.height) / 2);
        break;
    }
    Offset center = anchorRect.center.translate(offset.dx, offset.dy);
    return Rect.fromCenter(
        center: center, width: targetSize.width, height: targetSize.height);
  }

  //调整弹窗方向
  BubblePopupPosition _adjustPosition(
      BubblePopupPosition position, Rect container, Rect child) {
    switch (popupPosition) {
      case BubblePopupPosition.topStart:
        if (child.top < container.top) {
          return BubblePopupPosition.bottomStart;
        }
        break;
      case BubblePopupPosition.topCenter:
        if (child.top < container.top) {
          return BubblePopupPosition.bottomCenter;
        }
        break;
      case BubblePopupPosition.topEnd:
        if (child.top < container.top) {
          return BubblePopupPosition.bottomEnd;
        }
        break;
      case BubblePopupPosition.bottomStart:
        if (child.bottom > container.bottom) {
          return BubblePopupPosition.topStart;
        }
        break;
      case BubblePopupPosition.bottomCenter:
        if (child.bottom > container.bottom) {
          return BubblePopupPosition.topCenter;
        }
        break;
      case BubblePopupPosition.bottomEnd:
        if (child.bottom > container.bottom) {
          return BubblePopupPosition.topEnd;
        }
        break;
      case BubblePopupPosition.leftStart:
        if (child.left < container.left) {
          return BubblePopupPosition.rightStart;
        }
        break;
      case BubblePopupPosition.leftCenter:
        if (child.left < container.left) {
          return BubblePopupPosition.rightCenter;
        }
        break;
      case BubblePopupPosition.leftEnd:
        if (child.left < container.left) {
          return BubblePopupPosition.rightEnd;
        }
        break;
      case BubblePopupPosition.rightStart:
        if (child.right > container.right) {
          return BubblePopupPosition.leftStart;
        }
        break;
      case BubblePopupPosition.rightCenter:
        if (child.right > container.right) {
          return BubblePopupPosition.leftCenter;
        }
        break;
      case BubblePopupPosition.rightEnd:
        if (child.right > container.right) {
          return BubblePopupPosition.leftEnd;
        }
        break;
    }
    return position;
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
