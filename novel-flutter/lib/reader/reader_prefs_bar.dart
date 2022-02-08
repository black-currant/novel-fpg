import 'dart:async';

import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:novel_flutter/provider/provider_widget.dart';
import 'package:novel_flutter/reader/reader_config.dart';
import 'package:novel_flutter/reader/reader_model.dart';
import 'package:novel_flutter/utils/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

/// 阅读器偏好选项条
///
/// 亮度，字体尺寸，行间距，首行缩进
class ReaderPrefsBar extends StatefulWidget {
  final void Function(int index) onTap;
  final ReaderModel readerModel;
  final void Function() onLayout;

  const ReaderPrefsBar({
    Key? key,
    required this.onTap,
    required this.readerModel,
    required this.onLayout,
  }) : super(key: key);

  @override
  State createState() => _ReaderPrefsBarState();
}

class _ReaderPrefsBarState extends State<ReaderPrefsBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void setup() async {}

  @override
  initState() {
    super.initState();
    setup();

    _controller = AnimationController(
      duration: const Duration(milliseconds: ReaderConfig.duration),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _animation.addListener(() {
      setState(() {});
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void hide(int index) async {
    _controller.reverse();
    Timer(const Duration(milliseconds: ReaderConfig.duration), () {
      widget.onTap(index);
//      widget.readerModel.menuIndex = ReaderModel.nothing;
    });
  }

  Widget _buildBottomView() {
    return Positioned(
        bottom: -(ScreenUtil.bottomSafeHeight + 180) * (1 - _animation.value),
        left: 0,
        right: 0,
        child: Container(
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.only(
            left: horizontalMargin,
            right: horizontalMargin,
            top: verticalMargin,
            bottom: ScreenUtil.bottomSafeHeight + verticalMargin,
          ),
          child: ProviderWidget<ReaderModel>(
            autoDispose: false,
            model: widget.readerModel,
            builder: (_, model, child) {
              return Column(
                children: <Widget>[
                  _buildScreenBrightness(model),
                  _buildFontSize(model),
                  _buildLineHeight(model),
                ],
              );
            },
          ),
        ));
  }

  Widget _buildScreenBrightness(ReaderModel model) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: <Widget>[
          const Padding(
            child: Icon(Icons.brightness_low, size: 24),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Slider(
                value: model.screenBrightness,
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveColor: Theme.of(context).textTheme.headline6!.color,
                onChanged: (value) async {
                  try {
                    await ScreenBrightness().setScreenBrightness(value);
                  } catch (e) {
                    print(e);
                  }
                  model.screenBrightness = value;
                  setState(() {});
                },
              ),
            ),
            flex: 1,
          ),
          const Padding(
            child: Icon(Icons.brightness_high, size: 24),
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          ),
        ],
      ),
    );
  }

  Widget _buildFontSize(ReaderModel model) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: <Widget>[
          OutlineButton(
            highlightedBorderColor: Colors.transparent,
            onPressed: () {
              if (model.fontSize == ReaderConfig.minFontSize) return;
              model.fontSize = model.fontSize - 1;
              setState(() {});
              widget.onLayout();
            },
            child: const Text('Aa-'),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Text(
                model.fontSize.toInt().toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            flex: 1,
          ),
          OutlineButton(
            highlightedBorderColor: Colors.transparent,
            onPressed: () {
              if (model.fontSize == ReaderConfig.maxFontSize) return;
              model.fontSize = model.fontSize + 1;
              setState(() {});
              widget.onLayout();
            },
            child: Text('Aa+'),
          ),
          const SizedBox(width: 30),
          OutlineButton(
            highlightedBorderColor: Colors.transparent,
            onPressed: () {
              if (model.fontSize == ReaderConfig.fontSize) return;
              model.fontSize = ReaderConfig.fontSize;
              setState(() {});
              widget.onLayout();
            },
            child: Text(S.of(context).default_),
          ),
        ],
      ),
    );
  }

  Widget _buildLineHeight(ReaderModel model) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Row(
        children: <Widget>[
          OutlineButton(
            highlightedBorderColor: Colors.transparent,
            onPressed: () {
              if (model.lineHeight == ReaderConfig.minLineHeight) return;
              model.lineHeight = (model.lineHeight * 10 - 1) / 10;
              setState(() {});
              widget.onLayout();
            },
            child: Text(S.of(context).lineSpacing + '-'),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: Text(
                model.lineHeight.toString(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            flex: 1,
          ),
          OutlineButton(
            highlightedBorderColor: Colors.transparent,
            onPressed: () {
              if (model.lineHeight == ReaderConfig.maxLineHeight) return;
              model.lineHeight = (model.lineHeight * 10 + 1) / 10;
              setState(() {});
              widget.onLayout();
            },
            child: Text(S.of(context).lineSpacing + '+'),
          ),
          const SizedBox(width: 30),
          OutlineButton(
            highlightedBorderColor: Colors.transparent,
            onPressed: () {
              if (model.lineHeight == ReaderConfig.lineHeight) return;
              model.lineHeight = ReaderConfig.lineHeight;
              setState(() {});
              widget.onLayout();
            },
            child: Text(S.of(context).default_),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTapDown: (_) {
              hide(ReaderModel.nothing);
            },
            child: Container(color: Colors.transparent),
          ),
          _buildBottomView(),
        ],
      ),
    );
  }
}
