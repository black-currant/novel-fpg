# novel-flutter

## 1、线上体验 App

- Android 安装包[下载地址](https://github.com/black-currant/novel-fpg/raw/main/novel-flutter/app-release.apk)

## 2、安装和配置 Flutter 开发环境

&ensp;&ensp; 下面步骤是在 macOS 操作系统进行的，其他操作系统请看：

- [在 Windows 操作系统上安装和配置 Flutter 开发环境](https://flutter.cn/docs/get-started/install/windows)
- [在 Linux 操作系统上安装和配置 Flutter 开发环境](https://flutter.cn/docs/get-started/install/linux)

## 3、获取 Flutter

- [下载 Flutter 2.5.3](https://storage.flutter-io.cn/flutter_infra_release/releases/stable/macos/flutter_macos_2.5.3-stable.zip)

- 解压，并记住路径

- 将 Flutter 添加到 Path 路径。打开（或创建）你的 shell 的 rc 文件，路径一般是$HOME/.\*rc，并加入下列内容

```
export PATH=${PATH}:[Flutter 解压的路径]/flutter/bin
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PATH="$PATH":"[Flutter 解压的路径]/flutter/.pub-cache/bin"
```

- 检查 Flutter 环境。打开终端，输入

```
flutter doctor
```

## 4、iOS 平台设置

macOS 支持在 iOS、Android 和 Web 上开发 Flutter 应用（技术预览版）。现在至少完成一个平台设置步骤，以便能够构建和运行您的第一个 Flutter 应用程序。

&ensp;&ensp;&ensp;安装 Xcode

- 通过 [直接下载](https://developer.apple.com/xcode/) 或者通过 [Mac App Store](https://itunes.apple.com/us/app/xcode/id497799835)来安装最新稳定版 Xcode；

- 配置 Xcode 命令行工具以使用新安装的 Xcode 版本。从命令行中运行以下命令：

```
$ sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
$ sudo xcodebuild -runFirstLaunch
```

- 当你安装了最新版本的 Xcode，大部分情况下，上面的路径都是一样的。但如果你安装了不同版本的 Xcode，你可能要更改一下上述命令中的路径。

- 运行一次 Xcode 或者通过输入命令 `sudo xcodebuild -license` 来确保已经同意 Xcode 的许可协议。

- 配置 iOS 模拟器，终端执行`$ open -a Simulator `。

## 6、选择 Editor

推荐使用 [VS Code](https://code.visualstudio.com/)，下载安装后，在插件市场搜索`flutter`，`dart`和`Flutter Intl`，安装插件。
默认是 python 端的接口地址，如果要修改为 go 端的接口地址，可以在 lib/app/config.dart 文件中修改。

## 7、运行

切换到项目路径，运行`flutter run`。

## 8、参考

- [在 macOS 上安装和配置 Flutter 开发环境](https://flutter.cn/docs/get-started/install/macos)

## 9、鸣谢

- [fun_android_flutter](https://github.com/phoenixsky/fun_android_flutter)提供 provider 的封装
- [flutter_shuqi](https://github.com/huanxsd/flutter_shuqi)提供阅读器
