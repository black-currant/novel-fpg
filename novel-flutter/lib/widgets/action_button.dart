import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';

/// 操作按钮
class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? width;
  final double? height;
  final bool isProgress;

  const ActionButton(
      {Key? key,
      required this.onPressed,
      this.width,
      this.height,
      this.isProgress = false,
      required this.label})
      : super(key: key);

  const ActionButton.expand(
      {Key? key,
      required this.onPressed,
      this.isProgress = false,
      required this.label})
      : width = double.infinity,
        height = buttonHeight,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
          ),
          primary: Theme.of(context).colorScheme.secondary,
        ),
        clipBehavior: Clip.none,
        onPressed: onPressed,
        child: isProgress
            ? const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              )
            : Text(label,
                style: Theme.of(context).textTheme.button!.copyWith(
                      color: Colors.white,
                    )),
      ),
    );
  }
}
