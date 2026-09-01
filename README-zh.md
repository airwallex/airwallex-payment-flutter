# Airwallex Flutter Plugin
[![Platform](https://img.shields.io/badge/platform-flutter-darkgreen)](https://flutter.dev/)
[![Flutter version: 3.24.3](https://img.shields.io/badge/flutter-%3E%3D3.24.3-brightgreen)](https://docs.flutter.dev/)
[![pub package](https://img.shields.io/pub/v/airwallex_payment_flutter.svg)](https://pub.dev/packages/airwallex_payment_flutter)
[![GitHub release](https://img.shields.io/github/v/release/airwallex/airwallex-payment-flutter)](https://github.com/airwallex/airwallex-payment-flutter/releases)
[![license: BSD 3-Clause](https://img.shields.io/badge/license-BSD%203--Clause-lightblue)](https://github.com/airwallex/airwallex-payment-flutter/blob/main/LICENSE)

[EN](./README.md) | 中文

Airwallex 官方 Flutter 插件，用于在 **Android** 和 **iOS** 应用中接入支付。可使用预置原生结账界面，也可通过底层 API 搭配自有 UI。

**运行要求：** Dart ^3.5.3，Flutter >= 3.24.3，iOS 13.0+

### 付款方式
- **卡：** Visa、Mastercard、Amex、Diners Club、JCB、Discover、UnionPay、Maestro。若不使用原生 UI、自行通过 API 收卡，应用须符合 PCI-DSS 规范。
- **电子钱包：** Alipay、AlipayHK、DANA、GCash、Kakao Pay、Touch 'n Go、WeChat Pay 等。
- **Apple Pay**（iOS）
- **Google Pay**（Android）

### 本地化
英语、简体中文、繁体中文、法语、德语、日语、韩语、葡萄牙语（葡萄牙）、葡萄牙语（巴西）、俄语、西班牙语、泰语。

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  airwallex_payment_flutter: ^0.4.0
```

然后执行 `flutter pub get`。

iOS 端同时支持 **CocoaPods**（默认）和 **Swift Package Manager**。如需启用 SPM，请执行一次：

```bash
flutter config --enable-swift-package-manager
```

Android 上 `MainActivity` 必须继承 `FlutterFragmentActivity`（不能使用 `FlutterActivity`）。ProGuard 及其他平台配置见[快速开始](GUIDE-zh.md)。

## 快速上手

1. 在应用启动时初始化 SDK。
2. 在服务端创建 Payment Intent，再在 Flutter 中构建 Session。
3. 拉起原生支付流程（或调用底层 API）。

```dart
import 'package:airwallex_payment_flutter/airwallex.dart';
import 'package:airwallex_payment_flutter/types/environment.dart';

Airwallex.initialize(environment: Environment.demo);

final result = await Airwallex().presentEntirePaymentFlow(session);
```

完整集成步骤、Session 类型、returnUrl、Apple Pay / Google Pay 与主题：请参阅 **[快速开始](GUIDE-zh.md)**。

示例工程见 [`example/`](example/)。

## 截图
<p align="left">
<img src="https://github.com/user-attachments/assets/babf2af3-d59b-49fc-8b86-26e85df28a0c" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/d228ed51-2405-4322-be08-b1946801e076" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/c86b7f3f-d2bc-4326-b82e-145f52d35c72" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/938e6101-edb2-4fcf-89fa-07936e4af5a9" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/5556a6af-882d-4474-915e-2c9d5953aaa8" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/eb6f0b38-d88b-4c27-b843-9948bc25c5a0" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/1de983a9-b062-4108-82f5-917e0fc0fb57" width="200" hspace="10">
</p>

## 反馈

- 一般问题与反馈：在 GitHub [Issues](https://github.com/airwallex/airwallex-payment-flutter/issues) 中提交。
- 集成支持：[pa_mobile_sdk@airwallex.com](mailto:pa_mobile_sdk@airwallex.com)

## 更新日志

见 [CHANGELOG.md](CHANGELOG.md)。
