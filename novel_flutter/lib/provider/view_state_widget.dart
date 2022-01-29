import 'package:novel_flutter/app/dimens.dart';
import 'package:novel_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'view_state.dart';

/// 加载中
class ViewStateBusyWidget extends StatelessWidget {
  final Color? indicatorColor;

  ViewStateBusyWidget({this.indicatorColor});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
          indicatorColor ?? Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}

/// 基础Widget
class ViewStateWidget extends StatelessWidget {
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback onPressed;

  const ViewStateWidget(
      {Key? key,
      this.image,
      this.title,
      this.message,
      this.buttonText,
      required this.onPressed,
      this.buttonTextData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var titleStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
          color: Colors.grey,
        );
    var messageStyle = titleStyle.copyWith(
      color: titleStyle.color!.withOpacity(0.7),
      fontSize: 14,
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          image ?? Icon(Icons.error_outline, size: 48, color: Colors.grey[500]),
          const SizedBox(height: dividerMediumSize),
          Text(
            title ?? S.of(context).viewStateMessageError,
            style: titleStyle,
          ),
          const SizedBox(height: dividerMediumSize),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 150),
            child: SingleChildScrollView(
              child: Text(
                message ?? '',
                style: messageStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ViewStateButton(
            child: buttonText,
            textData: buttonTextData,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}

/// ErrorWidget
class ViewStateErrorWidget extends StatelessWidget {
  final ViewStateError error;
  final String? title;
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final String? buttonTextData;
  final VoidCallback onPressed;

  const ViewStateErrorWidget({
    Key? key,
    required this.error,
    this.image,
    this.title,
    this.message,
    this.buttonText,
    this.buttonTextData,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon? defaultImage;
    String? defaultTitle;
    var errorMessage = error.message;
    String defaultTextData = S.of(context).viewStateButtonRetry;
    switch (error.errorType) {
      case ViewStateErrorType.networkTimeOutError:
        defaultImage =
            Icon(Icons.error_outline, size: 48, color: Colors.grey[500]);
        defaultTitle = S.of(context).viewStateMessageNetworkError;
        // errorMessage = ''; // 网络异常移除message提示
        break;
      case ViewStateErrorType.unauthorizedError:
        return ViewStateUnAuthWidget(
          image: image,
          message: message,
          buttonText: buttonText,
          onPressed: onPressed,
        );
      default:
        defaultImage =
            Icon(Icons.error_outline, size: 48, color: Colors.grey[500]);
        defaultTitle = S.of(context).viewStateMessageError;
        break;
    }

    return ViewStateWidget(
      onPressed: onPressed,
      image: image ?? defaultImage,
      title: title ?? defaultTitle,
      message: message ?? errorMessage,
      buttonTextData: buttonTextData ?? defaultTextData,
      buttonText: buttonText,
    );
  }
}

/// 页面无数据
class ViewStateEmptyWidget extends StatelessWidget {
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final VoidCallback onPressed;

  const ViewStateEmptyWidget(
      {Key? key,
      this.image,
      this.message,
      this.buttonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: onPressed,
      image:
          image ?? Icon(Icons.error_outline, size: 48, color: Colors.grey[500]),
      title: message ?? S.of(context).viewStateMessageEmpty,
      buttonText: buttonText,
      buttonTextData: S.of(context).viewStateButtonRefresh,
    );
  }
}

/// 页面未授权
class ViewStateUnAuthWidget extends StatelessWidget {
  final String? message;
  final Widget? image;
  final Widget? buttonText;
  final VoidCallback onPressed;

  const ViewStateUnAuthWidget(
      {Key? key,
      this.image,
      this.message,
      this.buttonText,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewStateWidget(
      onPressed: onPressed,
      image: image ?? ViewStateUnAuthImage(),
      title: message ?? S.of(context).viewStateMessageUnAuth,
      buttonText: buttonText,
      buttonTextData: S.of(context).signIn,
    );
  }
}

/// 未授权图片
class ViewStateUnAuthImage extends StatelessWidget {
  const ViewStateUnAuthImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.error_outline, size: 48, color: Colors.grey[500]);
  }
}

/// 公用Button
class ViewStateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget? child;
  final String? textData;

  ViewStateButton({required this.onPressed, this.child, this.textData})
      : assert(child == null || textData == null);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      child: child ??
          Text(
            textData ?? S.of(context).viewStateButtonRetry,
            style: const TextStyle(wordSpacing: 5),
          ),
      textColor: Colors.grey,
      splashColor: Theme.of(context).splashColor,
      onPressed: onPressed,
      highlightedBorderColor: Theme.of(context).splashColor,
    );
  }
}
