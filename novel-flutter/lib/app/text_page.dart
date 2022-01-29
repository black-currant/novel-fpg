import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';

/// 纯文本页面
/// 手册，说明，规则
class TextPage extends StatelessWidget {
  final String title;
  final String body;

  const TextPage({Key? key, required this.title, required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: verticalMargin,
          horizontal: horizontalMargin,
        ),
        child: Text(
          body,
          overflow: TextOverflow.fade,
          style: Theme.of(context).textTheme.subtitle1,
        ),
      ),
    );
  }
}
