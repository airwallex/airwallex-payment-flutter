# Airwallex Flutter Plugin
[![Platform](https://img.shields.io/badge/platform-flutter-darkgreen)](https://flutter.dev/)
[![Flutter version: 3.24.3](https://img.shields.io/badge/flutter-3.24.3-brightgreen)](https://medium.com/flutter/flutter-3-24-dart-3-5-204b7d20c45d)
[![GitHub release](https://img.shields.io/github/v/release/airwallex/airwallex-payment-flutter)](https://github.com/airwallex/airwallex-payment-flutter/releases)
[![license: BSD 3-Clause](https://img.shields.io/badge/license-BSD%203--Clause-lightblue)](https://github.com/airwallex/airwallex-payment-flutter/blob/main/LICENSE)

[EN](./README.md) | 中文

Airwallex Flutter Plugin可以很方便地在你的Flutter应用中添加支付功能。
目前，Airwallex Flutter Plugin已支持Android和iOS两个平台。
支持的付款方式：
- 卡：`Visa`, `Mastercard`, `Amex`, `Dinners Club`, `JCB`, `Discover`, `Union Pay`. 如果你想通过Airwallex API集成而不使用我们的原生UI，那么你的应用必须符合PCI-DSS 规范。 
- 电子钱包：`Alipay`, `AlipayHK`, `DANA`, `GCash`, `Kakao Pay`, `Touch ‘n Go`, `WeChat Pay`等.
- Apple Pay
- Google Pay

支持的本地化语言：
英语、简体中文、繁体中文、法语、德语、日语、韩语、葡萄牙语（葡萄牙）、葡萄牙语（巴西）、俄语、西班牙语、泰语。

## 添加依赖
已经上传到 [pub.dev](https://pub.dev/packages/airwallex_payment_flutter), 你只需要添加Plugin依赖项。

在 `pubspec.yaml`中添加以下依赖
```yaml
dependencies:
    airwallex_payment_flutter: 0.1.5
```

## 快速上手
请参考：[快速开始](GUIDE-zh.md)

## 反馈
感谢使用Airwallex Flutter Plugin，并欢迎您提供反馈。 以下是几种联系方式：

* 对于一般适用的问题和反馈，可以直接在[`Issues`](https://github.com/airwallex/airwallex-payment-flutter/issues)中提交问题。
* [pa_mobile_sdk@airwallex.com](mailto:pa_mobile_sdk@airwallex.com) - 也可以发送问题到这个邮箱，我们会尽快提供帮助。

## 更新日志
项目中所有版本的更新都可以在[日志更新文档](CHANGELOG.md)中查看.
