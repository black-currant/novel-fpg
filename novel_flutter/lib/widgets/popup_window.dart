import 'package:flutter/material.dart';

const int _windowPopupDuration = 300;
const double _kWindowCloseIntervalEnd = 2.0 / 3.0;
const Duration _kWindowDuration = Duration(milliseconds: _windowPopupDuration);

class PopupWindowButton<T> extends StatefulWidget {
  const PopupWindowButton({
    Key? key,
    required this.child,
    required this.window,
    this.offset = Offset.zero,
    this.elevation = 2.0,
    this.duration = 300,
    this.type = MaterialType.card,
    required this.onTap,
  }) : super(key: key);

  /// 显示按钮button
  final Widget child;

  /// window 出现的位置。
  final Offset offset;

  /// 阴影
  final double elevation;

  /// 需要显示的window
  final Widget window;

  /// 按钮按钮后到显示window 出现的时间
  final int duration;

  final MaterialType type;

  final GestureTapCallback onTap;

  @override
  _PopupWindowButtonState createState() {
    return _PopupWindowButtonState();
  }
}

void showWindow<T>({
  required BuildContext context,
  required RelativeRect position,
  required Widget window,
  double elevation = 8.0,
  int duration = _windowPopupDuration,
  String? semanticLabel,
  required MaterialType type,
}) {
  Navigator.push(
    context,
    _PopupWindowRoute<T>(
        position: position,
        child: window,
        elevation: elevation,
        duration: duration,
        semanticLabel: semanticLabel,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        type: type),
  );
}

class _PopupWindowButtonState<T> extends State<PopupWindowButton> {
  void _showWindow() {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showWindow<T>(
      context: context,
      window: widget.window,
      position: position,
      duration: widget.duration,
      elevation: widget.elevation,
      type: widget.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        _showWindow();
      },
      child: widget.child,
    );
  }
}

class _PopupWindowRoute<T> extends PopupRoute<T> {
  _PopupWindowRoute({
    required this.position,
    required this.child,
    required this.elevation,
    this.theme,
    required this.barrierLabel,
    required this.semanticLabel,
    required this.duration,
    this.type = MaterialType.card,
  });

  @override
  Animation<double> createAnimation() {
    return CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kWindowCloseIntervalEnd));
  }

  final RelativeRect position;
  final Widget child;
  final double elevation;
  final ThemeData? theme;
  final String? semanticLabel;
  @override
  final String barrierLabel;
  final int duration;
  final MaterialType type;

  @override
  Duration get transitionDuration =>
      duration == 0 ? _kWindowDuration : Duration(milliseconds: duration);

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final CurveTween opacity =
        CurveTween(curve: const Interval(0.0, 1.0 / 3.0));

    return Builder(
      builder: (BuildContext context) {
        return CustomSingleChildLayout(
          delegate: _PopupWindowLayout(position),
          child: AnimatedBuilder(
              child: child,
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Opacity(
                  opacity: opacity.evaluate(animation),
                  child: Material(
                    type: type,
                    elevation: elevation,
                    child: child,
                  ),
                );
              }),
        );
      },
    );
  }
}

class _PopupWindowLayout extends SingleChildLayoutDelegate {
  _PopupWindowLayout(this.position);

  // Rectangle of underlying button, relative to the overlay's dimensions.
  final RelativeRect position;

  // We put the child wherever position specifies, so long as it will fit within
  // the specified parent size padded (inset) by 8. If necessary, we adjust the
  // child's position so that it fits.

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    // The menu can be at most the size of the overlay minus 8.0 pixels in each
    // direction.
    return BoxConstraints.loose(constraints.biggest);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // size: The size of the overlay.
    // childSize: The size of the menu, when fully open, as determined by
    // getConstraintsForChild.

    // Find the ideal vertical position.
    double y = position.top;

    // Find the ideal horizontal position.
    late double x;
    if (position.left > position.right) {
      // Menu button is closer to the right edge, so grow to the left, aligned to the right edge.
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      // Menu button is closer to the left edge, so grow to the right, aligned to the left edge.
      x = position.left;
    }
    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupWindowLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}
