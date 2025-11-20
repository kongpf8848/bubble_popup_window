import 'package:bubble_popup_window/bubble_popup_window.dart';
import 'package:bubble_popup_window/src/buble_animation_style.dart';
import 'package:flutter/material.dart';

const Duration _kPopupDuration = Duration(milliseconds: 300);
const double _kPopupCloseIntervalEnd = 2.0 / 3.0;

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
    BorderSide? border = BorderSide.none,
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
    //弹窗动画
    BubbleAnimationStyle? animationStyle,
    //是否显示箭头
    bool showArrow = true,
    //箭头宽度
    double arrowWidth = 10.0,
    //箭头高度
    double arrowHeight = 5.0,
    //箭头半径
    double arrowRadius = 0.0,
  }) {
    final bubbleWidget = _BubblePopupWidget(
      anchorContext: anchorContext,
      bubbleChild: child,
      direction: direction,
      color: color,
      radius: radius,
      border: border,
      shadows: shadows,
      padding: padding,
      gap: gap,
      miniEdgeMargin: miniEdgeMargin,
      showArrow: showArrow,
      arrowWidth: arrowWidth,
      arrowHeight: arrowHeight,
      arrowRadius: arrowRadius,
    );

    Navigator.of(anchorContext).push(
      _BubblePopupRoute(
        animationStyle: animationStyle,
        maskColor: maskColor,
        dismissOnTouchOutside: dismissOnTouchOutside,
        child: bubbleWidget,
      ),
    );
  }
}

//气泡弹窗路由
class _BubblePopupRoute<T> extends PopupRoute<T> {
  final BubbleAnimationStyle? animationStyle;
  final Color? maskColor;
  final bool dismissOnTouchOutside;
  final Widget child;

  _BubblePopupRoute({
    required this.animationStyle,
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
  Duration get transitionDuration =>
      animationStyle?.duration ?? _kPopupDuration;

  @override
  Animation<double> createAnimation() {
    if (animationStyle != BubbleAnimationStyle.noAnimation) {
      return CurvedAnimation(
        parent: super.createAnimation(),
        curve: animationStyle?.curve ?? Curves.bounceOut,
        reverseCurve: animationStyle?.reverseCurve ??
            const Interval(0.0, _kPopupCloseIntervalEnd),
      );
    }
    return super.createAnimation();
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }
}

class _BubblePopupWidget extends StatefulWidget {
  final BuildContext anchorContext;
  final Widget bubbleChild;
  final BubbleDirection direction;
  final Color color;
  final BorderRadius? radius;
  final BorderSide? border;
  final List<BoxShadow>? shadows;
  final EdgeInsetsGeometry? padding;
  final double gap;
  final EdgeInsets miniEdgeMargin;
  final bool showArrow;
  final double arrowWidth;
  final double arrowHeight;
  final double arrowRadius;

  const _BubblePopupWidget({
    super.key,
    required this.anchorContext,
    required this.bubbleChild,
    required this.direction,
    required this.color,
    this.radius,
    this.border,
    this.shadows,
    this.padding,
    required this.gap,
    required this.miniEdgeMargin,
    required this.showArrow,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.arrowRadius,
  });

  @override
  State<_BubblePopupWidget> createState() => _BubblePopupWidgetState();
}

class _BubblePopupWidgetState extends State<_BubblePopupWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _bubbleKey = GlobalKey();

  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _bubbleOffset = Offset.zero;
  BubbleDirection? _finalDirection;
  double? _arrowOffset;
  Rect _anchorRect = Rect.zero;
  Rect _boundaryRect = Rect.zero;

  @override
  void initState() {
    super.initState();
    _finalDirection = widget.direction;
    _initializeAnimation();
    _schedulePositionCalculation();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: _kPopupDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
    _controller.forward();
  }

  void _schedulePositionCalculation() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _calculatePosition();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _calculatePosition() {
    final RenderBox anchor =
        widget.anchorContext.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    final anchorOffset = anchor.localToGlobal(Offset.zero, ancestor: overlay);
    _anchorRect = Rect.fromLTWH(anchorOffset.dx, anchorOffset.dy,
        anchor.size.width, anchor.size.height);

    final padding = MediaQuery.of(context).padding + widget.miniEdgeMargin;
    _boundaryRect = Rect.fromLTRB(
      padding.left,
      padding.top,
      overlay.size.width - padding.right,
      overlay.size.height - padding.bottom,
    );

    final bubbleRenderObject = _bubbleKey.currentContext?.findRenderObject();
    if (bubbleRenderObject is! RenderBox) return;
    final bubbleSize = bubbleRenderObject.size;

    //计算弹窗区域
    var popRect = _calculateRect(widget.direction, _anchorRect, bubbleSize);
    //调整方向
    _finalDirection = _adjustDirection(popRect);
    if (_finalDirection != widget.direction) {
      popRect = _calculateRect(_finalDirection!, _anchorRect, bubbleSize);
    }
    popRect = _constrainToBoundary(popRect);

    // 计算箭头偏移
    final arrowOffset = _calculateArrowOffset(popRect);

    // 刷新UI
    setState(() {
      if (mounted) {
        _bubbleOffset = popRect.topLeft;
        _arrowOffset = arrowOffset;
      }
    });
  }

  double? _calculateArrowOffset(Rect popRect) {
    if (!widget.showArrow) {
      return null;
    }

    if (_finalDirection!.isVertical) {
      return _anchorRect.center.dx - popRect.left;
    } else if (_finalDirection!.isHorizontal) {
      return _anchorRect.center.dy - popRect.top;
    }

    return 0.0;
  }

  Rect _calculateRect(
      BubbleDirection direction, Rect anchorRect, Size bubbleSize) {
    final dx = (anchorRect.width + bubbleSize.width) / 2 + widget.gap;
    final dy = (anchorRect.height + bubbleSize.height) / 2 + widget.gap;
    Offset offset;

    switch (direction) {
      case BubbleDirection.topStart:
        offset = Offset((bubbleSize.width - anchorRect.width) / 2, -dy);
        break;
      case BubbleDirection.topCenter:
        offset = Offset(0, -dy);
        break;
      case BubbleDirection.topEnd:
        offset = Offset((anchorRect.width - bubbleSize.width) / 2, -dy);
        break;
      case BubbleDirection.bottomStart:
        offset = Offset((bubbleSize.width - anchorRect.width) / 2, dy);
        break;
      case BubbleDirection.bottomCenter:
        offset = Offset(0, dy);
        break;
      case BubbleDirection.bottomEnd:
        offset = Offset((anchorRect.width - bubbleSize.width) / 2, dy);
        break;
      case BubbleDirection.leftStart:
        offset = Offset(-dx, (bubbleSize.height - anchorRect.height) / 2);
        break;
      case BubbleDirection.leftCenter:
        offset = Offset(-dx, 0);
        break;
      case BubbleDirection.leftEnd:
        offset = Offset(-dx, (anchorRect.height - bubbleSize.height) / 2);
        break;
      case BubbleDirection.rightStart:
        offset = Offset(dx, (bubbleSize.height - anchorRect.height) / 2);
        break;
      case BubbleDirection.rightCenter:
        offset = Offset(dx, 0);
        break;
      case BubbleDirection.rightEnd:
        offset = Offset(dx, (anchorRect.height - bubbleSize.height) / 2);
        break;
    }

    final center = anchorRect.center.translate(offset.dx, offset.dy);
    return Rect.fromCenter(
        center: center, width: bubbleSize.width, height: bubbleSize.height);
  }

  BubbleDirection _adjustDirection(Rect popRect) {
    switch (widget.direction) {
      case BubbleDirection.topStart:
      case BubbleDirection.topCenter:
      case BubbleDirection.topEnd:
        if (popRect.top < _boundaryRect.top) {
          return ~widget.direction;
        }
        break;
      case BubbleDirection.bottomStart:
      case BubbleDirection.bottomCenter:
      case BubbleDirection.bottomEnd:
        if (popRect.bottom > _boundaryRect.bottom) {
          return ~widget.direction;
        }
        break;
      case BubbleDirection.leftStart:
      case BubbleDirection.leftCenter:
      case BubbleDirection.leftEnd:
        if (popRect.left < _boundaryRect.left) {
          return ~widget.direction;
        }
        break;
      case BubbleDirection.rightStart:
      case BubbleDirection.rightCenter:
      case BubbleDirection.rightEnd:
        if (popRect.right > _boundaryRect.right) {
          return ~widget.direction;
        }
        break;
    }
    return widget.direction;
  }

  Rect _constrainToBoundary(Rect child) {
    double dx = 0;
    double dy = 0;
    if (child.left < _boundaryRect.left) {
      dx = _boundaryRect.left - child.left;
    } else if (child.right > _boundaryRect.right) {
      dx = _boundaryRect.right - child.right;
    }

    if (child.top < _boundaryRect.top) {
      dy = _boundaryRect.top - child.top;
    } else if (child.bottom > _boundaryRect.bottom) {
      dy = _boundaryRect.bottom - child.bottom;
    }

    return child.shift(Offset(dx, dy));
  }

  ArrowDirection bubbleToArrow(BubbleDirection bubbleDirection) {
    final ArrowDirection arrowDirection;
    switch (bubbleDirection) {
      case BubbleDirection.topStart:
      case BubbleDirection.topCenter:
      case BubbleDirection.topEnd:
        arrowDirection = ArrowDirection.bottom;
        break;
      case BubbleDirection.rightStart:
      case BubbleDirection.rightCenter:
      case BubbleDirection.rightEnd:
        arrowDirection = ArrowDirection.left;
        break;
      case BubbleDirection.bottomStart:
      case BubbleDirection.bottomCenter:
      case BubbleDirection.bottomEnd:
        arrowDirection = ArrowDirection.top;
        break;
      case BubbleDirection.leftStart:
      case BubbleDirection.leftCenter:
      case BubbleDirection.leftEnd:
        arrowDirection = ArrowDirection.right;
        break;
    }
    return arrowDirection;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_bubbleOffset != null && _finalDirection != null) ...[
          Positioned(
            key: _bubbleKey,
            left: _bubbleOffset!.dx,
            top: _bubbleOffset!.dy,
            child: FadeTransition(
              opacity: _animation,
              child: BubbleContainer(
                borderRadius: widget.radius,
                border: widget.border,
                shadows: widget.shadows,
                padding: widget.padding,
                color: widget.color,
                showArrow: widget.showArrow,
                arrowWidth: widget.arrowWidth,
                arrowHeight: widget.arrowHeight,
                arrowRadius: widget.arrowRadius,
                arrowOffset: _arrowOffset,
                arrowDirection: bubbleToArrow(_finalDirection!),
                child: Material(
                  color: Colors.transparent,
                  type: MaterialType.transparency,
                  child: widget.bubbleChild,
                ),
              ),
            ),
          )
        ],
      ],
    );
  }
}
