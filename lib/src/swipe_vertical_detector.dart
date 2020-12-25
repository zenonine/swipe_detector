import 'package:flutter/widgets.dart';

enum SwipeVerticalDirection { up, down }

class SwipeVerticalDetails {
  final double initialGlobalDy;
  final double initialLocalDy;
  final double globalDy;
  final double localDy;

  double get distance {
    return globalDy - initialGlobalDy;
  }

  SwipeVerticalDirection? get direction {
    if (distance == 0) {
      return null;
    }

    return distance < 0
        ? SwipeVerticalDirection.up
        : SwipeVerticalDirection.down;
  }

  final double? velocity;

  bool get ended => velocity != null;

  SwipeVerticalDetails({
    required this.initialGlobalDy,
    required this.initialLocalDy,
    required this.globalDy,
    required this.localDy,
    this.velocity,
  });

  @override
  String toString() => 'SwipeVerticalDetails{'
      'initialGlobalDy: $initialGlobalDy'
      ', initialLocalDy: $initialLocalDy'
      ', globalDy: $globalDy'
      ', localDy: $localDy'
      ', distance: $distance'
      ', direction: $direction'
      ', velocity: $velocity'
      ', ended: $ended'
      '}';
}

typedef BeforeSwipeVerticalStartCallback = bool Function(
    SwipeVerticalDetails details);
typedef OnSwipeVerticalCallback = void Function(SwipeVerticalDetails details);
typedef AfterSwipeVerticalEndCallback = void Function(
    SwipeVerticalDetails details);

class SwipeVerticalDetector extends StatelessWidget {
  final Widget child;

  /// return true to enable onSwipe events. Otherwise, return false to skip onSwipe events.
  /// When true is returned, this callback will not be triggered anymore.
  final BeforeSwipeVerticalStartCallback? beforeSwipeStart;
  final OnSwipeVerticalCallback? onSwipe;
  final AfterSwipeVerticalEndCallback? afterSwipeEnd;
  final HitTestBehavior? behavior;

  SwipeVerticalDetector({
    required this.child,
    this.beforeSwipeStart,
    this.onSwipe,
    this.afterSwipeEnd,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    var triggered = false;
    DragDownDetails? downDetails;
    DragStartDetails? startDetails;
    DragUpdateDetails? updateDetails;

    return GestureDetector(
      child: child,
      behavior: behavior,
      onVerticalDragDown: (details) {
        downDetails = details;
      },
      onVerticalDragStart: (details) {
        startDetails = details;

        final swipeVerticalDetails = SwipeVerticalDetails(
          initialGlobalDy:
              (downDetails?.globalPosition ?? startDetails?.globalPosition)!.dy,
          initialLocalDy:
              (downDetails?.localPosition ?? startDetails?.localPosition)!.dy,
          globalDy: details.globalPosition.dy,
          localDy: details.localPosition.dy,
        );

        triggered = triggered || checkTrigger(swipeVerticalDetails);
        if (triggered) {
          onSwipe?.call(swipeVerticalDetails);
        }
      },
      onVerticalDragUpdate: (details) {
        updateDetails = details;
        if (downDetails == null && startDetails == null) {
          return;
        }

        final swipeVerticalDetails = SwipeVerticalDetails(
          initialGlobalDy:
              (downDetails?.globalPosition ?? startDetails?.globalPosition)!.dy,
          initialLocalDy:
              (downDetails?.localPosition ?? startDetails?.localPosition)!.dy,
          globalDy: details.globalPosition.dy,
          localDy: details.localPosition.dy,
        );

        triggered = triggered || checkTrigger(swipeVerticalDetails);
        if (triggered) {
          onSwipe?.call(swipeVerticalDetails);
        }
      },
      onVerticalDragEnd: (details) {
        final globalPosition =
            (updateDetails?.globalPosition ?? startDetails?.globalPosition)!;
        final swipeVerticalDetails = SwipeVerticalDetails(
          initialGlobalDy:
              (downDetails?.globalPosition ?? startDetails?.globalPosition)!.dy,
          initialLocalDy:
              (downDetails?.localPosition ?? startDetails?.localPosition)!.dy,
          globalDy: globalPosition.dy,
          localDy:
              (updateDetails?.localPosition ?? startDetails?.localPosition)!.dy,
          velocity: details.primaryVelocity,
        );

        triggered = triggered || checkTrigger(swipeVerticalDetails);
        if (triggered) {
          // reset when swipe ended and ready for next swipe
          triggered = false;
          downDetails = null;
          startDetails = null;
          updateDetails = null;

          onSwipe?.call(swipeVerticalDetails);
          afterSwipeEnd?.call(swipeVerticalDetails);
        }
      },
    );
  }

  bool checkTrigger(final SwipeVerticalDetails details) {
    return beforeSwipeStart?.call(details) ?? true;
  }
}
