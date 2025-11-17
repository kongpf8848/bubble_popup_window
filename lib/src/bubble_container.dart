import 'package:flutter/material.dart';
import 'arrow_direction.dart';
import './bubble_shape_border.dart';

class BubbleContainer extends StatelessWidget {
  final BorderRadius? borderRadius;
  final BorderSide? border;
  final bool showArrow;
  final ArrowDirection arrowDirection;
  final double arrowWidth;
  final double arrowHeight;
  final double? arrowOffset;
  final double arrowRadius;

  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? shadows;
  final Matrix4? transform;
  final AlignmentGeometry? transformAlignment;
  final Widget? child;
  final Clip clipBehavior;

  const BubbleContainer({
    Key? key,
    this.alignment,
    this.padding,
    this.color,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.shadows,
    this.transform,
    this.transformAlignment,
    this.child,
    this.clipBehavior = Clip.none,
    this.border = BorderSide.none,
    this.borderRadius = BorderRadius.zero,
    this.showArrow = true,
    required this.arrowDirection,
    this.arrowWidth = 10.0,
    this.arrowHeight = 5.0,
    this.arrowRadius = 0.0,
    this.arrowOffset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EdgeInsets bubblePadding = EdgeInsets.zero;
    if (showArrow) {
      if (arrowDirection == ArrowDirection.top) {
        bubblePadding = EdgeInsets.only(top: arrowHeight);
      } else if (arrowDirection == ArrowDirection.bottom) {
        bubblePadding = EdgeInsets.only(bottom: arrowHeight);
      } else if (arrowDirection == ArrowDirection.left) {
        bubblePadding = EdgeInsets.only(left: arrowHeight);
      } else if (arrowDirection == ArrowDirection.right) {
        bubblePadding = EdgeInsets.only(right: arrowHeight);
      }
    }

    return Container(
      key: key,
      alignment: alignment,
      margin: margin,
      width: width,
      height: height,
      constraints: constraints,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      padding: bubblePadding.add(padding ?? EdgeInsets.zero),
      decoration: showArrow
          ? ShapeDecoration(
              shape: BubbleShapeBorder(
                side: border ?? BorderSide.none,
                borderRadius: borderRadius ?? BorderRadius.zero,
                fillColor: color,
                arrowDirection: arrowDirection,
                arrowWidth: arrowWidth,
                arrowHeight: arrowHeight,
                arrowRadius: arrowRadius,
                arrowOffset: arrowOffset,
              ),
              shadows: shadows,
              color: color
            )
          : BoxDecoration(
              color: color,
              border: border != null
                  ? Border.all(
                      width: border!.width,
                      color: border!.color,
                      style: border!.style,
                      strokeAlign: border!.strokeAlign,
                    )
                  : null,
              borderRadius: borderRadius ?? BorderRadius.zero,
              boxShadow: shadows,
            ),
      child: child,
    );
  }
}
