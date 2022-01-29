import 'package:novel_flutter/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/utils/util.dart';

/// 签到结果对话框
class CheckInResultDialog extends Dialog {
  final String reward;
  final int progress;

  const CheckInResultDialog(
      {Key? key, required this.reward, required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(Util.assetImage('check_in_bg.png')),
            Positioned(
              top: 96,
              left: 90,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: '+ ',
                      style: TextStyle(color: Color(0xFFfa7736), fontSize: 18),
                    ),
                    TextSpan(
                      text: reward,
                      style: const TextStyle(
                        color: Color(0xFFfa7736),
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                    TextSpan(
                      text: S.of(context).virtualCurrency,
                      style: const TextStyle(
                        color: Color(0xFFfa7736),
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              child: Text(
                S.of(context).checkInProgress(progress.toString()),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        IconButton(
          onPressed: () {
            Navigator.maybePop(context);
          },
          icon: Image.asset(Util.assetImage('close_circle.png')),
        ),
      ],
    );
  }
}
