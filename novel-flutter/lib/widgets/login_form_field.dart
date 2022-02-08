import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/app/styles.dart';
import 'package:novel_flutter/generated/l10n.dart';

/// 登录表单字段框
class LoginFormField extends StatefulWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final bool visibly;
  final bool autofocus;
  final FocusNode? focusNode;

  const LoginFormField({
    Key? key,
    this.hintText,
    this.prefixIcon,
    this.controller,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.visibly = false,
    this.autofocus = false,
    this.focusNode,
  }) : super(key: key);

  @override
  _LoginFormFieldState createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  late TextEditingController controller;

  /// 默认遮挡密码
  late ValueNotifier<bool> obscureNotifier;

  @override
  void initState() {
    controller = widget.controller ?? TextEditingController();
    obscureNotifier = ValueNotifier(widget.obscureText);
    super.initState();
  }

  @override
  void dispose() {
    obscureNotifier.dispose();
    // 默认没有传入controller,需要内部释放
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: textFieldHeight,
      margin: const EdgeInsets.only(bottom: verticalMargin),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: textFieldDecoration(context: context),
      child: ValueListenableBuilder(
        valueListenable: obscureNotifier,
        builder: (BuildContext context, bool value, Widget? child) =>
            TextFormField(
          controller: controller,
          obscureText: value,
          validator: (text) {
            var validator = widget.validator ?? (_) => null;
            return text!.trim().isNotEmpty
                ? validator(text)
                : S.of(context).pleaseTypeContent;
          },
          textInputAction: widget.textInputAction,
          autofocus: widget.autofocus,
          focusNode: widget.focusNode,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            prefixIcon: Icon(
              widget.prefixIcon,
              color: Theme.of(context).colorScheme.secondary,
              size: 20,
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(fontSize: 15),
            suffixIcon: LoginFormFieldSuffixIcon(
              controller: controller,
              obscureText: widget.obscureText,
              obscureNotifier: obscureNotifier,
              visibly: widget.visibly,
            ),
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
        ),
      ),
    );
  }
}

/// 后缀图标
class LoginFormFieldSuffixIcon extends StatelessWidget {
  final TextEditingController controller;

  final ValueNotifier<bool> obscureNotifier;

  final bool obscureText;
  final bool visibly; // 密码可见

  const LoginFormFieldSuffixIcon({
    Key? key,
    required this.controller,
    required this.obscureNotifier,
    this.obscureText = true, // 晦涩的文字
    this.visibly = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: visibly ? _password(theme) : _normal(theme),
    );
  }

  List<Widget> _password(ThemeData theme) {
    return [
      Offstage(
        offstage: !obscureText,
        child: GestureDetector(
          onTap: () {
            obscureNotifier.value = !obscureNotifier.value;
          },
          child: ValueListenableBuilder(
            valueListenable: obscureNotifier,
            builder: (BuildContext context, bool value, Widget? child) => Icon(
              value ? CupertinoIcons.eye_slash : CupertinoIcons.eye,
              color: value ? theme.hintColor : theme.colorScheme.secondary,
            ),
          ),
        ),
      ),
      LoginFormFieldClearIcon(controller),
    ];
  }

  List<Widget> _normal(ThemeData theme) {
    return [
      LoginFormFieldClearIcon(controller),
    ];
  }
}

/// 清空图标
class LoginFormFieldClearIcon extends StatefulWidget {
  final TextEditingController controller;

  const LoginFormFieldClearIcon(this.controller, {Key? key}) : super(key: key);

  @override
  _LoginFormFieldClearIconState createState() =>
      _LoginFormFieldClearIconState();
}

class _LoginFormFieldClearIconState extends State<LoginFormFieldClearIcon> {
  late ValueNotifier<bool> notifier;

  @override
  void initState() {
    notifier = ValueNotifier(widget.controller.text.isEmpty);
    widget.controller.addListener(() {
      notifier.value = widget.controller.text.isEmpty;
    });
    super.initState();
  }

  @override
  void dispose() {
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, bool value, child) {
        return Offstage(
          offstage: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          widget.controller.clear();
        },
        child: Icon(
          Icons.clear,
          color: Theme.of(context).hintColor,
        ),
      ),
    );
  }
}
