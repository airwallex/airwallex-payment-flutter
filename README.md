# Airwallex Flutter Plugin
[![Platform](https://img.shields.io/badge/platform-flutter-darkgreen)](https://flutter.dev/)
[![Flutter version: 3.24.3](https://img.shields.io/badge/flutter-%3E%3D3.24.3-brightgreen)](https://docs.flutter.dev/)
[![pub package](https://img.shields.io/pub/v/airwallex_payment_flutter.svg)](https://pub.dev/packages/airwallex_payment_flutter)
[![GitHub release](https://img.shields.io/github/v/release/airwallex/airwallex-payment-flutter)](https://github.com/airwallex/airwallex-payment-flutter/releases)
[![license: BSD 3-Clause](https://img.shields.io/badge/license-BSD%203--Clause-lightblue)](https://github.com/airwallex/airwallex-payment-flutter/blob/main/LICENSE)

EN | [中文](README-zh.md)

Official Airwallex plugin for accepting payments in Flutter apps on **Android** and **iOS**. Use the pre-built native checkout UI, or call lower-level APIs with your own screens.

**Requirements:** Dart ^3.5.3, Flutter >= 3.24.3, iOS 13.0+

### Payment methods
- **Cards:** Visa, Mastercard, Amex, Diners Club, JCB, Discover, UnionPay, Maestro. Integrating card payments without the native UI requires your app to be PCI-DSS compliant.
- **E-wallets:** Alipay, AlipayHK, DANA, GCash, Kakao Pay, Touch 'n Go, WeChat Pay, and others.
- **Apple Pay** (iOS)
- **Google Pay** (Android)

### Localizations
English, Chinese Simplified, Chinese Traditional, French, German, Japanese, Korean, Portuguese (Portugal), Portuguese (Brazil), Russian, Spanish, Thai.

## Installation

Add the dependency in `pubspec.yaml`:

```yaml
dependencies:
  airwallex_payment_flutter: ^0.4.0
```

Then run `flutter pub get`.

On iOS, the plugin supports **CocoaPods** (default) and **Swift Package Manager**. To use SPM, enable it once for your Flutter installation:

```bash
flutter config --enable-swift-package-manager
```

On Android, `MainActivity` must extend `FlutterFragmentActivity` (not `FlutterActivity`). See the [Quick Start](GUIDE.md#android) for ProGuard notes and other platform setup.

## Getting started

1. Initialize the SDK once at app startup.
2. Create a payment intent on your server, then build a session in Flutter.
3. Present the native payment flow (or call a low-level API).

```dart
import 'package:airwallex_payment_flutter/airwallex.dart';
import 'package:airwallex_payment_flutter/types/environment.dart';

Airwallex.initialize(environment: Environment.demo);

final result = await Airwallex().presentEntirePaymentFlow(session);
```

Full integration steps, session types, return URLs, Apple Pay / Google Pay, and theming: **[Quick Start](GUIDE.md)**.

A working sample is in [`example/`](example/).

## Screenshots
<p align="left">
<img src="https://github.com/user-attachments/assets/babf2af3-d59b-49fc-8b86-26e85df28a0c" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/d228ed51-2405-4322-be08-b1946801e076" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/c86b7f3f-d2bc-4326-b82e-145f52d35c72" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/938e6101-edb2-4fcf-89fa-07936e4af5a9" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/5556a6af-882d-4474-915e-2c9d5953aaa8" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/eb6f0b38-d88b-4c27-b843-9948bc25c5a0" width="200" hspace="10">
<img src="https://github.com/user-attachments/assets/1de983a9-b062-4108-82f5-917e0fc0fb57" width="200" hspace="10">
</p>

## Feedback

- General issues and feedback: open a GitHub [Issue](https://github.com/airwallex/airwallex-payment-flutter/issues).
- Integration support: [pa_mobile_sdk@airwallex.com](mailto:pa_mobile_sdk@airwallex.com)

## Changelog

See [CHANGELOG.md](CHANGELOG.md).
