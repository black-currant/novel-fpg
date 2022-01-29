import 'package:novel_flutter/widgets/space_divider.dart';
import 'package:flutter/material.dart';

showLoadingDialog(BuildContext context, String message) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LoadingDialog(message: message);
      });
}

closeLoadingDialog(BuildContext context) => Navigator.pop(context);

/// 加载中对话框
class LoadingDialog extends Dialog {
  final String message;

  const LoadingDialog({Key? key, required this.message}) : super(key: key);

  Widget _buildBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SpaceDivider(height: 24),
          Text(
            message,
            maxLines: 2,
            style: Theme.of(context).textTheme.subtitle2,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = (MediaQuery.of(context).size.width / 3).ceilToDouble();
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: _buildBody(context),
      ),
    );
  }
}
