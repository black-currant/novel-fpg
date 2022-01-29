import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:provider/provider.dart';

/// Provider封装类
/// 方便数据初始化
class ProviderWidget<T extends ChangeNotifier, Myadapters>
    extends StatefulWidget {
  final ValueWidgetBuilder<Myadapters> builder;
  final Myadapters Function(BuildContext, T) selector;
  final T model;
  final Widget? child;
  final Function(T model)? onModelReady;
  final bool? autoDispose;

  const ProviderWidget({
    Key? key,
    required this.builder,
    required this.model,
    required this.selector,
    this.child,
    this.onModelReady,
    this.autoDispose,
  }) : super(key: key);

  @override
  _ProviderWidgetState<T> createState() => _ProviderWidgetState<T>();
}

class _ProviderWidgetState<T extends ChangeNotifier>
    extends State<ProviderWidget<T, S>> {
  late T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose!) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Selector<T, S>(
        selector: widget.selector,
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
