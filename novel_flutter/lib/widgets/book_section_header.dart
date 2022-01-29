import 'package:flutter/material.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/utils/util.dart';

/// 书籍列表分组前的标识
class BookSectionHeader extends StatefulWidget {
  final String label;
  final String? action;
  final GestureTapCallback? onPressed;

  const BookSectionHeader({
    Key? key,
    required this.label,
    this.action,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BookSectionHeaderState();
  }
}

class _BookSectionHeaderState extends State<BookSectionHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        setState(() {
          _running = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        const SizedBox(width: double.infinity, height: 24),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 4,
              height: 16,
              margin: const EdgeInsets.only(right: 10),
              decoration: accentDecoration,
            ),
            Text(
              widget.label,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        Visibility(
          visible: widget.action != null,
          child: Positioned(
            right: 0,
            child: InkWell(
              onTap: () {
                if (_running) return;
                setState(() {
                  _running = true;
                });
                _controller.forward();
                widget.onPressed?.call();
              },
              child: Row(
                children: <Widget>[
                  Text(
                    '${widget.action}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  const SizedBox(width: 6),
                  RotationTransition(
                    alignment: Alignment.center,
                    turns: _controller,
                    child: Image.asset(Util.assetImage('refresh.png')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
