# Airwallex Flutter Plugin
Airwallex Flutter Plugin是一种灵活的工具，可让您将付款方式集成到您的Flutter应用中。 它还包括一个预构建的UI，使您可以灵活地选择使用其中的任何部分，同时用自己的UI替换其余部分。

本节将指导您完成集成Airwallex Flutter Plugin的过程。 我们假设您是一名Flutter开发人员，并且熟悉Flutter插件的集成和使用。

我们的Demo开源在 [Github](https://github.com/airwallex/airwallex-payment-flutter)，可以帮助你更好地了解如何在你的Flutter项目中集成Airwallex Flutter Plugin。

## Contents
* [Overview](#Overview)
    * [Airwallex API](#airwallex-api)
    * [Airwallex Native UI](#airwallex-native-ui)
* [添加依赖](#添加依赖)
* [环境配置](#环境配置)
    * [Android配置](#Android配置)
    * [iOS配置](#iOS配置)
* [创建PaymentIntent](#创建PaymentIntent)
* [创建PaymentSession](#创建PaymentSession)
    * [创建一个OneOffSession对象](#创建一个OneOffSession对象)
    * [创建一个RecurringSession对象](#创建一个RecurringSession对象)
    * [创建一个RecurringWithIntentSession对象](#创建一个RecurringWithIntentSession对象)
* [UI集成](#UI集成)
    * [支付列表页面](#支付列表页面)
    * [卡支付页面](#卡支付页面)
    * [自定义主题](#自定义主题)
* [低层API集成](#低层API集成)
    * [用卡和账单详情确认支付](#用卡和账单详情确认支付)
* [Plugin Example](#plugin-example)
* [测试卡号](#测试卡号)
* [贡献](#贡献)

## Overview
### Airwallex API

Airwallex Flutter Plugin是一种灵活的工具，可让您将付款方式集成到您的Flutter中。

支持的付款方式：
- Cards: [`Visa, Mastercard`](#cards). If you want to integrate Airwallex API without our Native UI for card payments, then your website is required to be PCI-DSS compliant. 
- E-Wallets: [`Alipay`](#alipay), [`AlipayHK`](#alipayhk), [`DANA`](#dana), [`GCash`](#gcash), [`Kakao Pay`](#kakao-pay), [`Touch ‘n Go`](#touch-n-go), [`WeChat Pay`](#wechat-pay)

### Airwallex Native UI
Airwallex Native UI 是一个预构建的UI，可让您自定义UI颜色并适合您的App主题。 您可以单独使用这些组件，也可以将我们的预构建UI打包到一个流程中以显示您的付款。

## 添加依赖
在 `pubspec.yaml`中添加以下依赖
```yaml
dependencies:
  airwallex_payment_flutter: 0.0.1
```

## 环境配置
Airwallex Flutter Plugin允许设置三种环境, 分别是`staging`, `demo`和`production`。
如果您处于测试阶段，建议将环境设置为`staging`或`demo`来进行功能调试。如果您处于生产阶段，则必须设置`production`。
对于不同的平台，设置环境的方式有所不同。

#### Android配置：
对于Android平台而言，默认情况下，release包会使用`production`环境，debug包会使用`demo`环境。
如果您需要更改环境，则需要在打包阶段手动指定环境，具体命令如下：
```
flutter build apk --debug -Penv=demo
```
这个指令仅生成一个指定环境的apk，您需要手动将其安装到设备上。

#### iOS配置：


## 创建PaymentIntent
在发起支付前, 你必须在服务端创建一个`PaymentIntent`对象，并返回到客户端.

> 请按照以下步骤在商家服务器上创建PaymentIntent
>1. 首先，您需要获取访问令牌以允许您访问Airwallex API端点。 使用您的唯一Client ID 和 API KEY (这些可以在 [Account settings > API keys](https://www.airwallex.com/app/settings/api) 中生成). 成功之后，你可以得到一个access token。
>
>2. 创建 customer(可选的) 允许您保存customer的详细信息, 可以在customer上绑定付款方式，以便在customer在支付时快速检索支持的付款方式 [`/api/v1/pa/customers/create`](https://www.airwallex.com/docs/api#/Payment_Acceptance/Customers/_api_v1_pa_customers_create/post)
>
>3. 最终, 你可以通过 [`/api/v1/pa/payment_intents/create`](https://www.airwallex.com/docs/api#/Payment_Acceptance/Payment_Intents/_api_v1_pa_payment_intents_create/post) 来创建一个`PaymentIntent`对象，然后返回到你的客户端
>
>4. 在返回结果中，将包含client_secret，您需要将其存储以备后用。

创建付款意向后，您需要将PaymentIntent中的部分数据传递给Airwallex Flutter Plugin，并使购物者能够使用选定的付款方式完成付款

## 创建PaymentSession
无论您选择调用我们的预构建UI组件还是使用低层API，您都需要在调用之前创建一个`PaymentSession`对象。 该对象包含有关付款的所有必要信息。

### 创建一个OneOffSession对象
GooglePayOptions 和 Shipping 都是可选的， 您可以根据自己的需要选择是否传递这些参数。
```dart
import 'package:airwallex_payment_flutter/types/payment_session.dart';
import 'package:airwallex_payment_flutter/types/shipping.dart';
import 'package:airwallex_payment_flutter/types/google_pay_options.dart';

static Map<String, dynamic> createOneOffSession(Map<String, dynamic> paymentIntent) {
  //get paymentIntent from your server, or you can only get paymentIntentId, clientSecret, amount, currency from your server
  final String paymentIntentId = paymentIntent['id'];
  final String clientSecret = paymentIntent['client_secret'];
  final int amount = paymentIntent['amount'];
  final String currency = paymentIntent['currency'];

  final paramMap = OneOffSession(
    paymentIntentId: paymentIntentId,
    amount: amount,
    currency: currency,
    customerId: '',
    // shipping: createShipping(),
    isBillingRequired: true,
    isEmailRequired: false,
    countryCode: 'UK',
    returnUrl: 'airwallexcheckout://com.example.airwallex_payment_flutter_example',
    googlePayOptions: GooglePayOptions(
    billingAddressRequired: true,
    billingAddressParameters: BillingAddressParameters(format: Format.FULL),
    ),
    autoCapture: true,
    hidePaymentConsents: false,
    ).toMap();
    paramMap['clientSecret'] = clientSecret;
  return paramMap;
}
```
#### 配置GooglePayOptions
Airwallex Flutter Plugin可以通过以下步骤允许商户给顾客提供Google Pay作为支付方式：
- 确认Google Pay在您的Airwallex账号上已开通
- 您可以自定义Google Pay选项来限制或提供额外的付款参数。请参考`GooglePayOptions`类中的更多信息。
```dart
final googlePayOptions = GooglePayOptions(
  billingAddressRequired: true,
  billingAddressParameters: BillingAddressParameters(format: Format.FULL),
)
```
- 我们现在暂时只支持AMEX、DISCOVER、JCB、Visa和MasterCard来进行Google Pay支付，用户在通过Google Pay付款时只能选择这几种卡。
> 请注意我们的Google Pay模块目前只支持`OneOffSession`。我们会在以后添加对recurring payment sessions的支持。

#### 配置returnUrl
注意，如果您希望使用重定向调用第三方支付，则必须提供returnUrl来决定支付结束后跳转的页面
#####Android：
```
    <intent-filter>
        ...
        <data
            android:host="${applicationId}"
            android:scheme="airwallexcheckout" />
    </intent-filter>
```
#####iOS：

### 创建一个RecurringSession对象
当前版本暂时不支持传递RecurringSessions对象，但相关功能会在接下来的版本中支持

### 创建一个RecurringWithIntentSession对象
当前版本暂时不支持传递RecurringWithIntentSession对象，但相关功能会在接下来的版本中支持

## UI集成
### 支付列表页面
- 使用 `presentEntirePaymentFlow` 调起支付列表页面，来完成整个支付流程
```dart
   final result = await platform.invokeMethod('presentEntirePaymentFlow', paymentSession);
```
### 卡支付页面
- 使用 `presentCardPaymentFlow` 调起卡支付页面，来完成整个支付流程
```kotlin
   final result = await platform.invokeMethod('presentCardPaymentFlow', paymentSession);
```
### 自定义主题
#### Android：
您可以在应用程序中覆盖这些颜色值, 用来适配您的应用风格。 https://developer.android.com/guide/topics/ui/look-and-feel/themes#CustomizeTheme
在`res/values/colors.xml`中添加以下颜色值
```
    <color name="airwallex_tint_color">@color/airwallex_color_red</color>
```
#### iOS：

## 低层API集成
### 用卡和账单详情确认支付
创建Card对象，然后调用`startPayWithCardDetails`方法来完成支付
```dart
import 'package:airwallex_payment_flutter/types/card.dart';

static Map<String, dynamic> createDemoCard() {
    final card = Card(
      number: "4012000300001003",
      name: "John Citizen",
      expiryMonth: "12",
      expiryYear: "2029",
      cvc: "737"
    );

    return card.toMap();
  }
```
```dart
final params = {
        ...paymentSession,
        ...cardParams,
      };
final result = await platform.invokeMethod('startPayWithCardDetails', params);
```

## Plugin Example
该示例应用程序演示了如何使用其内置的UI组件与 Airwallex Flutter Plugin集成，以管理结帐流程，包括指定送货地址和选择付款方式。

## 测试卡号
https://cardinaldocs.atlassian.net/wiki/spaces/CCen/pages/903577725/EMV+3DS+Test+Cases

## 贡献
我们欢迎任何形式的贡献，包括新功能，错误修复和文档改进。最简单的方式就是创建pull request - 我们会尽快回复。 如果你发现任何错误或有任何疑问，也可以提交Issues。
