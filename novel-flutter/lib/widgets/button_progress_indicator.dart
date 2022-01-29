import 'package:flutter/material.dart';

/// 按钮进度条
class ButtonProgressIndicator extends StatelessWidget {
  final double size;
  final Color color;

  const ButtonProgressIndicator({
    Key? key,
    this.size = 24.0,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(color),
      ),
    );
  }
}
