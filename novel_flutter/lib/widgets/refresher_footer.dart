import 'package:flutter/material.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 通用的footer
///
/// 由于国际化需要context的原因,所以无法在[RefreshConfiguration]配置
class RefresherFooter extends StatelessWidget {
  const RefresherFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClassicFooter(
      failedText: S.of(context).loadMoreFailed,
      idleText: S.of(context).loadMoreIdle,
      loadingText: S.of(context).loadMoreLoading,
      noDataText: S.of(context).loadMoreNoData,
    );
  }
}
