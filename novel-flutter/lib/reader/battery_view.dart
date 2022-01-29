import 'dart:io';

import 'package:novel_flutter/reader/reader_config.dart';
import 'package:battery/battery.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:novel_flutter/utils/util.dart';

/// 电量视图
class BatteryView extends StatefulWidget {
  const BatteryView({Key? key}) : super(key: key);

  @override
  _BatteryViewState createState() => _BatteryViewState();
}

class _BatteryViewState extends State<BatteryView> {
  double batteryLevel = 0;

  getBatteryLevel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      if (!androidInfo.isPhysicalDevice) {
        return;
      }
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfo.iosInfo;
      if (!iosInfo.isPhysicalDevice) {
        return;
      }
    }

    var level = await Battery().batteryLevel;
    setState(() {
      batteryLevel = level / 100.0;
    });
  }

  @override
  void initState() {
    super.initState();
    getBatteryLevel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 12,
      child: Stack(
        children: <Widget>[
          Image.asset(Util.assetImage('reader_battery.png')),
          Container(
            margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
            width: 20 * batteryLevel,
            color: ReaderConfig.golden,
          )
        ],
      ),
    );
  }
}
