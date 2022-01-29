import 'dart:async';

import 'package:novel_flutter/utils/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 网页
class WebPage extends StatefulWidget {
  final String url;
  final String title;

  const WebPage({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<WebPage> {
  String _title = '';
  late WebViewController _webViewController;
  final Completer<bool> _finishedCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: WebViewTitle(
          title: _title,
          future: _finishedCompleter.future,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      bottom: false,
      child: WebView(
        // 初始化加载的url
        initialUrl: widget.url,
        // 加载js
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) {
          ///TODO isForMainFrame为false,页面不跳转.导致网页内很多链接点击没效果
          debugPrint('导航$request');
          return NavigationDecision.navigate;
        },
        onWebViewCreated: (WebViewController controller) {
          _webViewController = controller;
          _webViewController.currentUrl().then((url) {
            debugPrint('Web view current url:$url');
          });
        },
        onPageFinished: (String value) async {
          debugPrint('Web view page finished:$value');
          if (!_finishedCompleter.isCompleted) {
            _finishedCompleter.complete(true);
          }
        },
      ),
    );
  }
}

class WebViewTitle extends StatelessWidget {
  final String title;
  final Future<bool> future;

  const WebViewTitle({Key? key, required this.title, required this.future})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder<bool>(
          future: future,
          initialData: false,
          builder: (context, snapshot) {
            return Offstage(
              offstage: snapshot.data!,
              child: const Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: CupertinoActivityIndicator()),
            );
          },
        ),
        Expanded(
            child: Text(
          //移除html标签
          Util.removeHtmlLabel(title),
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).primaryTextTheme.headline6,
        ))
      ],
    );
  }
}
