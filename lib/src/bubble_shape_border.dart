import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../bubble_popup_window.dart';

class _BubbleBorderArrowProperties {
  /// 箭头宽度的一半
  final double halfWidth;

  /// 箭头斜边的长度
  final double hypotenuse;

  /// 该斜边在主轴上的投影（水平时为X轴）
  final double projectionOnMain;

  /// 该斜边在纵轴上的投影（水平时为Y轴）
  final double projectionOnCross;

  /// 计算箭头半径在主轴上的投影（水平时为X轴）
  final double arrowProjectionOnMain;

  /// 计算箭头半径尖尖的长度
  final double topLen;

  _BubbleBorderArrowProperties({
    required this.halfWidth,
    required this.hypotenuse,
    required this.projectionOnMain,
    required this.projectionOnCross,
    required this.arrowProjectionOnMain,
    required this.topLen,
  });
}

class BubbleShapeBorder extends OutlinedBorder {
  final BorderRadius borderRadius;
  final ArrowDirection arrowDirection;
  final double arrowWidth;
  final double arrowHeight;
  final double arrowRadius;
  final double? arrowOffset;

  const BubbleShapeBorder({
    super.side,
    this.borderRadius = BorderRadius.zero,
    required this.arrowDirection,
    this.arrowWidth = 10.0,
    this.arrowHeight = 5.0,
    this.arrowRadius = 0.0,
    this.arrowOffset,
  });

  _BubbleBorderArrowProperties _calculateArrowProperties() {
    final arrowHalfWidth = arrowWidth / 2;
    final double hypotenuse =
        math.sqrt(arrowHeight * arrowHeight + arrowHalfWidth * arrowHalfWidth);
    final double projectionOnMain = arrowHalfWidth * arrowRadius / hypotenuse;
    final double projectionOnCross =
        projectionOnMain * arrowHeight / arrowHalfWidth;
    final double arrowProjectionOnMain = arrowHeight * arrowRadius / hypotenuse;
    final double pointArrowTopLen =
        arrowProjectionOnMain * arrowHeight / arrowHalfWidth;
    return _BubbleBorderArrowProperties(
      halfWidth: arrowHalfWidth,
      hypotenuse: hypotenuse,
      projectionOnMain: projectionOnMain,
      projectionOnCross: projectionOnCross,
      arrowProjectionOnMain: arrowProjectionOnMain,
      topLen: pointArrowTopLen,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect.deflate(side.strokeInset), true);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect, false);
  }

  Rect _getRoundedRect(Rect rect) {
    EdgeInsets padding = EdgeInsets.zero;
    if (arrowDirection == ArrowDirection.top) {
      padding = EdgeInsets.only(top: arrowHeight);
    } else if (arrowDirection == ArrowDirection.right) {
      padding = EdgeInsets.only(right: arrowHeight);
    } else if (arrowDirection == ArrowDirection.bottom) {
      padding = EdgeInsets.only(bottom: arrowHeight);
    } else if (arrowDirection == ArrowDirection.left) {
      padding = EdgeInsets.only(left: arrowHeight);
    }
    return Rect.fromLTRB(
      rect.left + padding.left,
      rect.top + padding.top,
      rect.right - padding.right,
      rect.bottom - padding.bottom,
    );
  }

  //计算方向为：上、右、下、左
  Path _buildPath(Rect rect, bool isInner) {
    final path = Path();
    final nRect = _getRoundedRect(rect);
    final sideOffset = isInner ? side.strokeInset : side.strokeOutset;

    final arrowProp = _calculateArrowProperties();

    path.moveTo(nRect.left + borderRadius.topLeft.x, nRect.top);

    //top arrow
    if (arrowDirection == ArrowDirection.top) {
      Offset pointCenter = Offset(
          nRect.left + (arrowOffset ?? nRect.width / 2) - sideOffset,
          nRect.top);
      Offset pointStart =
          Offset(pointCenter.dx - arrowProp.halfWidth, nRect.top);
      Offset pointArrow = Offset(pointCenter.dx, rect.top);
      Offset pointEnd = Offset(pointCenter.dx + arrowProp.halfWidth, nRect.top);

      Offset pointStartArcBegin =
          Offset(pointStart.dx - arrowRadius, pointStart.dy);
      Offset pointStartArcEnd = Offset(
          pointStart.dx + arrowProp.projectionOnMain,
          pointStart.dy - arrowProp.projectionOnCross);
      path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
      path.quadraticBezierTo(pointStart.dx, pointStart.dy, pointStartArcEnd.dx,
          pointStartArcEnd.dy);

      Offset pointArrowArcBegin = Offset(
          pointArrow.dx - arrowProp.arrowProjectionOnMain,
          pointArrow.dy + arrowProp.topLen);
      Offset pointArrowArcEnd = Offset(
          pointArrow.dx + arrowProp.arrowProjectionOnMain,
          pointArrow.dy + arrowProp.topLen);
      path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
      path.quadraticBezierTo(pointArrow.dx, pointArrow.dy, pointArrowArcEnd.dx,
          pointArrowArcEnd.dy);

      Offset pointEndArcBegin = Offset(pointEnd.dx - arrowProp.projectionOnMain,
          pointEnd.dy - arrowProp.projectionOnCross);
      Offset pointEndArcEnd = Offset(pointEnd.dx + arrowRadius, pointEnd.dy);
      path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
      path.quadraticBezierTo(
          pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
    }

    path.lineTo(nRect.right - borderRadius.topRight.x, nRect.top);

    // topRight radius
    path.arcToPoint(
      Offset(nRect.right, nRect.top + borderRadius.topRight.y),
      radius: borderRadius.topRight,
      rotation: 90,
    );

    //right arrow
    if (arrowDirection == ArrowDirection.right) {
      Offset pointCenter = Offset(nRect.right,
          nRect.top + (arrowOffset ?? nRect.height / 2) - sideOffset);
      Offset pointStart =
          Offset(nRect.right, pointCenter.dy - arrowProp.halfWidth);
      Offset pointArrow = Offset(rect.right, pointCenter.dy);
      Offset pointEnd =
          Offset(nRect.right, pointCenter.dy + arrowProp.halfWidth);

      Offset pointStartArcBegin =
          Offset(pointStart.dx, pointStart.dy - arrowRadius);
      Offset pointStartArcEnd = Offset(
          pointStart.dx + arrowProp.projectionOnCross,
          pointStart.dy + arrowProp.projectionOnMain);
      path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
      path.quadraticBezierTo(pointStart.dx, pointStart.dy, pointStartArcEnd.dx,
          pointStartArcEnd.dy);

      Offset pointArrowArcBegin = Offset(pointArrow.dx - arrowProp.topLen,
          pointArrow.dy - arrowProp.arrowProjectionOnMain);
      Offset pointArrowArcEnd = Offset(pointArrow.dx - arrowProp.topLen,
          pointArrow.dy + arrowProp.arrowProjectionOnMain);
      path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
      path.quadraticBezierTo(pointArrow.dx, pointArrow.dy, pointArrowArcEnd.dx,
          pointArrowArcEnd.dy);

      Offset pointEndArcBegin = Offset(
          pointEnd.dx + arrowProp.projectionOnCross,
          pointEnd.dy - arrowProp.projectionOnMain);
      Offset pointEndArcEnd = Offset(pointEnd.dx, pointEnd.dy + arrowRadius);
      path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
      path.quadraticBezierTo(
          pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
    }

    path.lineTo(nRect.right, nRect.bottom - borderRadius.bottomRight.y);

    // bottomRight radius
    path.arcToPoint(
      Offset(nRect.right - borderRadius.bottomRight.x, nRect.bottom),
      radius: borderRadius.bottomRight,
      rotation: 90,
    );

    //bottom arrow
    if (arrowDirection == ArrowDirection.bottom) {
      Offset pointCenter = Offset(
          nRect.left + (arrowOffset ?? nRect.width / 2) - sideOffset,
          nRect.bottom);
      Offset pointStart =
          Offset(pointCenter.dx + arrowProp.halfWidth, nRect.bottom);
      Offset pointArrow = Offset(pointCenter.dx, rect.bottom);
      Offset pointEnd =
          Offset(pointCenter.dx - arrowProp.halfWidth, nRect.bottom);

      Offset pointStartArcBegin =
          Offset(pointStart.dx + arrowRadius, pointStart.dy);
      Offset pointStartArcEnd = Offset(
          pointStart.dx - arrowProp.projectionOnMain,
          pointStart.dy + arrowProp.projectionOnCross);
      path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
      path.quadraticBezierTo(pointStart.dx, pointStart.dy, pointStartArcEnd.dx,
          pointStartArcEnd.dy);

      Offset pointArrowArcBegin = Offset(
          pointArrow.dx + arrowProp.arrowProjectionOnMain,
          pointArrow.dy - arrowProp.topLen);
      Offset pointArrowArcEnd = Offset(
          pointArrow.dx - arrowProp.arrowProjectionOnMain,
          pointArrow.dy - arrowProp.topLen);
      path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
      path.quadraticBezierTo(pointArrow.dx, pointArrow.dy, pointArrowArcEnd.dx,
          pointArrowArcEnd.dy);

      Offset pointEndArcBegin = Offset(pointEnd.dx + arrowProp.projectionOnMain,
          pointEnd.dy + arrowProp.projectionOnCross);
      Offset pointEndArcEnd = Offset(pointEnd.dx - arrowRadius, pointEnd.dy);
      path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
      path.quadraticBezierTo(
          pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
    }

    path.lineTo(nRect.left + borderRadius.bottomLeft.x, nRect.bottom);

    // bottomLeft radius
    path.arcToPoint(
      Offset(nRect.left, nRect.bottom - borderRadius.bottomLeft.y),
      radius: borderRadius.bottomLeft,
      rotation: 90,
    );

    // left arrow
    if (arrowDirection == ArrowDirection.left) {
      Offset pointCenter = Offset(nRect.left,
          nRect.top + (arrowOffset ?? nRect.height / 2) - sideOffset);
      Offset pointStart =
          Offset(nRect.left, pointCenter.dy + arrowProp.halfWidth);
      Offset pointArrow = Offset(rect.left, pointCenter.dy);
      Offset pointEnd =
          Offset(nRect.left, pointCenter.dy - arrowProp.halfWidth);

      Offset pointStartArcBegin =
          Offset(pointStart.dx, pointStart.dy + arrowRadius);
      Offset pointStartArcEnd = Offset(
          pointStart.dx - arrowProp.projectionOnCross,
          pointStart.dy - arrowProp.projectionOnMain);
      path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
      path.quadraticBezierTo(pointStart.dx, pointStart.dy, pointStartArcEnd.dx,
          pointStartArcEnd.dy);

      Offset pointArrowArcBegin = Offset(pointArrow.dx + arrowProp.topLen,
          pointArrow.dy + arrowProp.arrowProjectionOnMain);
      Offset pointArrowArcEnd = Offset(pointArrow.dx + arrowProp.topLen,
          pointArrow.dy - arrowProp.arrowProjectionOnMain);
      path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
      path.quadraticBezierTo(pointArrow.dx, pointArrow.dy, pointArrowArcEnd.dx,
          pointArrowArcEnd.dy);

      Offset pointEndArcBegin = Offset(
          pointEnd.dx - arrowProp.projectionOnCross,
          pointEnd.dy + arrowProp.projectionOnMain);
      Offset pointEndArcEnd = Offset(pointEnd.dx, pointEnd.dy - arrowRadius);
      path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
      path.quadraticBezierTo(
          pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
    }

    path.lineTo(nRect.left, nRect.top + borderRadius.topLeft.y);

    //topLeft radius
    path.arcToPoint(
      Offset(nRect.left + borderRadius.topLeft.x, nRect.top),
      radius: borderRadius.topLeft,
      rotation: 90,
    );

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        if (side.width > 0.0) {
          var outerPath = getOuterPath(rect);
          var innerPath = getInnerPath(rect);
          innerPath.fillType = PathFillType.evenOdd;
          Path path =
              Path.combine(PathOperation.difference, outerPath, innerPath);
          final Paint paint = Paint()
            ..color = side.color
            ..style = PaintingStyle.fill;
          canvas.drawPath(path, paint);
        }
    }
  }

  @override
  BubbleShapeBorder copyWith({
    BorderSide? side,
    BorderRadius? borderRadius,
    ArrowDirection? arrowDirection,
    double? arrowWidth,
    double? arrowHeight,
    double? arrowRadius,
    double? arrowOffset,
    Color? fillColor,
  }) {
    return BubbleShapeBorder(
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      arrowDirection: arrowDirection ?? this.arrowDirection,
      arrowWidth: arrowWidth ?? this.arrowWidth,
      arrowHeight: arrowHeight ?? this.arrowHeight,
      arrowRadius: arrowRadius ?? this.arrowRadius,
      arrowOffset: arrowOffset ?? this.arrowOffset,
    );
  }

  @override
  ShapeBorder scale(double t) {
    return BubbleShapeBorder(
      side: side.scale(t),
      borderRadius: borderRadius * t,
      arrowDirection: arrowDirection,
      arrowWidth: arrowWidth * t,
      arrowHeight: arrowHeight * t,
      arrowRadius: arrowRadius * t,
      arrowOffset: (arrowOffset ?? 0.0) * t,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BubbleShapeBorder &&
        other.side == side &&
        other.borderRadius == borderRadius &&
        other.arrowWidth == arrowWidth &&
        other.arrowHeight == arrowHeight &&
        other.arrowDirection == arrowDirection &&
        other.arrowRadius == arrowRadius &&
        other.arrowOffset == arrowOffset;
  }

  @override
  int get hashCode => Object.hash(
        side,
        borderRadius,
        arrowDirection,
        arrowWidth,
        arrowHeight,
        arrowRadius,
        arrowOffset,
      );
}
