import 'dart:math';
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
  final Color? fillColor;

  @override
  OutlinedBorder copyWith({
    ArrowDirection? arrowDirection,
    BorderSide? side,
    BorderRadius? borderRadius,
    double? arrowWidth,
    double? arrowHeight,
    double? arrowRadius,
    double? arrowOffset,
    Color? fillColor,
  }) {
    return BubbleShapeBorder(
      arrowDirection: arrowDirection ?? this.arrowDirection,
      side: side ?? this.side,
      borderRadius: borderRadius ?? this.borderRadius,
      arrowHeight: arrowHeight ?? this.arrowHeight,
      arrowWidth: arrowWidth ?? this.arrowWidth,
      arrowRadius: arrowRadius ?? this.arrowRadius,
      arrowOffset: arrowOffset ?? this.arrowOffset,
      fillColor: fillColor ?? this.fillColor,
    );
  }

  const BubbleShapeBorder({
    super.side,
    required this.arrowDirection,
    this.borderRadius = BorderRadius.zero,
    this.arrowWidth = 10.0,
    this.arrowHeight = 5.0,
    this.arrowRadius = 3,
    this.arrowOffset,
    this.fillColor,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return _buildPath(rect);
  }

  _BubbleBorderArrowProperties _calculateArrowProperties() {
    final arrowHalfWidth = arrowWidth / 2;
    final double hypotenuse =
        sqrt(arrowHeight * arrowHeight + arrowHalfWidth * arrowHalfWidth);
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

  /// 核心逻辑：构建路径
  /// 计算方向为：上、右、下、左
  Path _buildPath(Rect rect) {
    final path = Path();
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
    final nRect = Rect.fromLTRB(
        rect.left + padding.left,
        rect.top + padding.top,
        rect.right - padding.right,
        rect.bottom - padding.bottom);

    final arrowProp = _calculateArrowProperties();

    final startPoint = Offset(nRect.left + borderRadius.topLeft.x, nRect.top);

    path.moveTo(startPoint.dx, startPoint.dy);
    // 箭头在上边
    if (arrowDirection == ArrowDirection.top) {
      Offset pointCenter =
          Offset(nRect.left + (arrowOffset ?? nRect.width / 2), nRect.top);
      Offset pointStart =
          Offset(pointCenter.dx - arrowProp.halfWidth, nRect.top);
      Offset pointArrow = Offset(pointCenter.dx, rect.top);
      Offset pointEnd = Offset(pointCenter.dx + arrowProp.halfWidth, nRect.top);

      // 下面计算开始的圆弧
      {
        Offset pointStartArcBegin =
            Offset(pointStart.dx - arrowRadius, pointStart.dy);
        Offset pointStartArcEnd = Offset(
            pointStart.dx + arrowProp.projectionOnMain,
            pointStart.dy - arrowProp.projectionOnCross);
        path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
        path.quadraticBezierTo(pointStart.dx, pointStart.dy,
            pointStartArcEnd.dx, pointStartArcEnd.dy);
      }
      // 计算中间箭头的圆弧
      {
        Offset pointArrowArcBegin = Offset(
            pointArrow.dx - arrowProp.arrowProjectionOnMain,
            pointArrow.dy + arrowProp.topLen);
        Offset pointArrowArcEnd = Offset(
            pointArrow.dx + arrowProp.arrowProjectionOnMain,
            pointArrow.dy + arrowProp.topLen);
        path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
        path.quadraticBezierTo(pointArrow.dx, pointArrow.dy,
            pointArrowArcEnd.dx, pointArrowArcEnd.dy);
      }
      // 下面计算结束的圆弧
      {
        Offset pointEndArcBegin = Offset(
            pointEnd.dx - arrowProp.projectionOnMain,
            pointEnd.dy - arrowProp.projectionOnCross);
        Offset pointEndArcEnd = Offset(pointEnd.dx + arrowRadius, pointEnd.dy);
        path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
        path.quadraticBezierTo(
            pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
      }
    }

    path.lineTo(nRect.right - borderRadius.topRight.x, nRect.top);
    // topRight radius
    path.arcToPoint(Offset(nRect.right, nRect.top + borderRadius.topRight.y),
        radius: borderRadius.topRight, rotation: 90);

    // 箭头在右边
    if (arrowDirection == ArrowDirection.right) {
      Offset pointCenter =
          Offset(nRect.right, nRect.top + (arrowOffset ?? nRect.height / 2));
      Offset pointStart =
          Offset(nRect.right, pointCenter.dy - arrowProp.halfWidth);
      Offset pointArrow = Offset(rect.right, pointCenter.dy);
      Offset pointEnd =
          Offset(nRect.right, pointCenter.dy + arrowProp.halfWidth);

      // 下面计算开始的圆弧
      {
        Offset pointStartArcBegin =
            Offset(pointStart.dx, pointStart.dy - arrowRadius);
        Offset pointStartArcEnd = Offset(
            pointStart.dx + arrowProp.projectionOnCross,
            pointStart.dy + arrowProp.projectionOnMain);
        path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
        path.quadraticBezierTo(pointStart.dx, pointStart.dy,
            pointStartArcEnd.dx, pointStartArcEnd.dy);
      }
      // 计算中间箭头的圆弧
      {
        Offset pointArrowArcBegin = Offset(pointArrow.dx - arrowProp.topLen,
            pointArrow.dy - arrowProp.arrowProjectionOnMain);
        Offset pointArrowArcEnd = Offset(pointArrow.dx - arrowProp.topLen,
            pointArrow.dy + arrowProp.arrowProjectionOnMain);
        path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
        path.quadraticBezierTo(pointArrow.dx, pointArrow.dy,
            pointArrowArcEnd.dx, pointArrowArcEnd.dy);
      }
      // 下面计算结束的圆弧
      {
        Offset pointEndArcBegin = Offset(
            pointEnd.dx + arrowProp.projectionOnCross,
            pointEnd.dy - arrowProp.projectionOnMain);
        Offset pointEndArcEnd = Offset(pointEnd.dx, pointEnd.dy + arrowRadius);
        path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
        path.quadraticBezierTo(
            pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
      }
    }

    path.lineTo(nRect.right, nRect.bottom - borderRadius.bottomRight.y);
    // bottomRight radius
    path.arcToPoint(
        Offset(nRect.right - borderRadius.bottomRight.x, nRect.bottom),
        radius: borderRadius.bottomRight,
        rotation: 90);

    // 箭头在下边
    if (arrowDirection == ArrowDirection.bottom) {
      Offset pointCenter =
          Offset(nRect.left + (arrowOffset ?? nRect.width / 2), nRect.bottom);
      Offset pointStart =
          Offset(pointCenter.dx + arrowProp.halfWidth, nRect.bottom);
      Offset pointArrow = Offset(pointCenter.dx, rect.bottom);
      Offset pointEnd =
          Offset(pointCenter.dx - arrowProp.halfWidth, nRect.bottom);

      // 下面计算开始的圆弧
      {
        Offset pointStartArcBegin =
            Offset(pointStart.dx + arrowRadius, pointStart.dy);
        Offset pointStartArcEnd = Offset(
            pointStart.dx - arrowProp.projectionOnMain,
            pointStart.dy + arrowProp.projectionOnCross);
        path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
        path.quadraticBezierTo(pointStart.dx, pointStart.dy,
            pointStartArcEnd.dx, pointStartArcEnd.dy);
      }
      // 计算中间箭头的圆弧
      {
        Offset pointArrowArcBegin = Offset(
            pointArrow.dx + arrowProp.arrowProjectionOnMain,
            pointArrow.dy - arrowProp.topLen);
        Offset pointArrowArcEnd = Offset(
            pointArrow.dx - arrowProp.arrowProjectionOnMain,
            pointArrow.dy - arrowProp.topLen);
        path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
        path.quadraticBezierTo(pointArrow.dx, pointArrow.dy,
            pointArrowArcEnd.dx, pointArrowArcEnd.dy);
      }
      // 下面计算结束的圆弧
      {
        Offset pointEndArcBegin = Offset(
            pointEnd.dx + arrowProp.projectionOnMain,
            pointEnd.dy + arrowProp.projectionOnCross);
        Offset pointEndArcEnd = Offset(pointEnd.dx - arrowRadius, pointEnd.dy);
        path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
        path.quadraticBezierTo(
            pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
      }
    }

    path.lineTo(nRect.left + borderRadius.bottomLeft.x, nRect.bottom);
    // bottomLeft radius
    path.arcToPoint(
        Offset(nRect.left, nRect.bottom - borderRadius.bottomRight.y),
        radius: borderRadius.bottomLeft,
        rotation: 90);

    // 箭头在左边
    if (arrowDirection == ArrowDirection.left) {
      Offset pointCenter =
          Offset(nRect.left, nRect.top + (arrowOffset ?? nRect.height / 2));
      Offset pointStart =
          Offset(nRect.left, pointCenter.dy + arrowProp.halfWidth);
      Offset pointArrow = Offset(rect.left, pointCenter.dy);
      Offset pointEnd =
          Offset(nRect.left, pointCenter.dy - arrowProp.halfWidth);

      // 下面计算开始的圆弧
      {
        Offset pointStartArcBegin =
            Offset(pointStart.dx, pointStart.dy + arrowRadius);
        Offset pointStartArcEnd = Offset(
            pointStart.dx - arrowProp.projectionOnCross,
            pointStart.dy - arrowProp.projectionOnMain);
        path.lineTo(pointStartArcBegin.dx, pointStartArcBegin.dy);
        path.quadraticBezierTo(pointStart.dx, pointStart.dy,
            pointStartArcEnd.dx, pointStartArcEnd.dy);
      }
      // 计算中间箭头的圆弧
      {
        Offset pointArrowArcBegin = Offset(pointArrow.dx + arrowProp.topLen,
            pointArrow.dy + arrowProp.arrowProjectionOnMain);
        Offset pointArrowArcEnd = Offset(pointArrow.dx + arrowProp.topLen,
            pointArrow.dy - arrowProp.arrowProjectionOnMain);
        path.lineTo(pointArrowArcBegin.dx, pointArrowArcBegin.dy);
        path.quadraticBezierTo(pointArrow.dx, pointArrow.dy,
            pointArrowArcEnd.dx, pointArrowArcEnd.dy);
      }
      // 下面计算结束的圆弧
      {
        Offset pointEndArcBegin = Offset(
            pointEnd.dx - arrowProp.projectionOnCross,
            pointEnd.dy + arrowProp.projectionOnMain);
        Offset pointEndArcEnd = Offset(pointEnd.dx, pointEnd.dy - arrowRadius);
        path.lineTo(pointEndArcBegin.dx, pointEndArcBegin.dy);
        path.quadraticBezierTo(
            pointEnd.dx, pointEnd.dy, pointEndArcEnd.dx, pointEndArcEnd.dy);
      }
    }

    path.lineTo(nRect.left, nRect.top + borderRadius.topLeft.y);
    path.arcToPoint(startPoint, radius: borderRadius.topLeft, rotation: 90);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (fillColor == null && side == BorderSide.none) {
      return;
    }
    final path = _buildPath(rect);
    final Paint paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke;
    if (fillColor != null) {
      paint.color = fillColor!;
      paint.style = PaintingStyle.fill;
      canvas.drawPath(path, paint);
    }
    if (side != BorderSide.none) {
      paint.color = side.color;
      paint.strokeWidth = side.width;
      paint.style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
    }
  }

  @override
  ShapeBorder scale(double t) {
    return BubbleShapeBorder(
      arrowDirection: arrowDirection,
      side: side.scale(t),
      borderRadius: borderRadius * t,
      arrowHeight: arrowHeight * t,
      arrowWidth: arrowWidth * t,
      arrowRadius: arrowRadius * t,
      arrowOffset: (arrowOffset ?? 0) * t,
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
        other.arrowHeight == arrowHeight &&
        other.arrowWidth == arrowWidth &&
        other.arrowRadius == arrowRadius &&
        other.arrowDirection == arrowDirection &&
        other.arrowOffset == arrowOffset &&
        other.fillColor == fillColor;
  }

  @override
  int get hashCode => Object.hash(
        side,
        borderRadius,
        arrowHeight,
        arrowWidth,
        arrowRadius,
        arrowDirection,
        arrowOffset,
        fillColor,
      );
}
