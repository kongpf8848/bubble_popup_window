import '../../bubble_popup_window.dart';

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
