import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

@immutable
class BubbleAnimationStyle with Diagnosticable {
  /// Creates an instance of Animation Style class.
  BubbleAnimationStyle({
    this.curve,
    this.duration,
    this.reverseCurve,
    this.reverseDuration,
  });

  /// Creates an instance of Animation Style class with no animation.
  static BubbleAnimationStyle noAnimation = BubbleAnimationStyle(
    duration: Duration.zero,
    reverseDuration: Duration.zero,
  );

  /// When specified, the animation will use this curve.
  final Curve? curve;

  /// When specified, the animation will use this duration.
  final Duration? duration;

  /// When specified, the reverse animation will use this curve.
  final Curve? reverseCurve;

  /// When specified, the reverse animation will use this duration.
  final Duration? reverseDuration;

  /// Creates a new [BubbleAnimationStyle] based on the current selection, with the
  /// provided parameters overridden.
  BubbleAnimationStyle copyWith({
    final Curve? curve,
    final Duration? duration,
    final Curve? reverseCurve,
    final Duration? reverseDuration,
  }) {
    return BubbleAnimationStyle(
      curve: curve ?? this.curve,
      duration: duration ?? this.duration,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      reverseDuration: reverseDuration ?? this.reverseDuration,
    );
  }

  /// Linearly interpolate between two animation styles.
  static BubbleAnimationStyle? lerp(BubbleAnimationStyle? a, BubbleAnimationStyle? b, double t) {
    if (identical(a, b)) {
      return a;
    }
    return BubbleAnimationStyle(
      curve: t < 0.5 ? a?.curve : b?.curve,
      duration: t < 0.5 ? a?.duration : b?.duration,
      reverseCurve: t < 0.5 ? a?.reverseCurve : b?.reverseCurve,
      reverseDuration: t < 0.5 ? a?.reverseDuration : b?.reverseDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is BubbleAnimationStyle &&
        other.curve == curve &&
        other.duration == duration &&
        other.reverseCurve == reverseCurve &&
        other.reverseDuration == reverseDuration;
  }

  @override
  int get hashCode => Object.hash(
        curve,
        duration,
        reverseCurve,
        reverseDuration,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<Curve>('curve', curve, defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>('duration', duration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Curve>('reverseCurve', reverseCurve,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Duration>(
        'reverseDuration', reverseDuration,
        defaultValue: null));
  }
}
