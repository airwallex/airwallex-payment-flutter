# AGENTS.md

This file provides guidance for AI coding agents working in this repository.

## Project Overview

This is a Flutter plugin for Airwallex payment integration, supporting both Android and iOS platforms. The plugin wraps native Airwallex SDKs (Android SDK v6.10.0, iOS SDK v~6.6.0) and exposes payment functionality through Flutter's platform channels using method channels with JSON codec.

**Requirements:** Dart ^3.5.3, Flutter >=3.24.3

## Build and Development Commands

### Flutter Commands
```bash
# Install dependencies
flutter pub get

# Run code generation for JSON serialization
flutter pub run build_runner build

# Run linting
flutter analyze

# Run tests
flutter test

# Run example app (requires connected device/emulator)
cd example && flutter run
```

### Android-Specific
- **Important**: MainActivity must extend `FlutterFragmentActivity` (not `FlutterActivity`) to avoid UI issues
- For R8 obfuscation issues in release builds, add to `android/app/proguard-rules.pro`:
  ```
  -keep class org.xmlpull.v1.XmlPullParser { *; }
  -keep interface org.xmlpull.v1.XmlPullParser { *; }
  ```

### iOS-Specific
- Minimum deployment target: iOS 13.0
- Swift version: 5.0
- Run `pod install` in `example/ios` when working with example app

## Architecture

### Plugin Architecture
The plugin follows Flutter's standard platform channel pattern with three layers:

1. **Dart API Layer** ([lib/airwallex.dart](lib/airwallex.dart)):
   - Main public API exposed to Flutter developers
   - Methods: `initialize()`, `presentEntirePaymentFlow()`, `presentCardPaymentFlow()`, `payWithCardDetails()`, `payWithConsent()`, `startGooglePay()`, `startApplePay()`, `setTintColor()`

2. **Platform Interface Layer** ([lib/airwallex_payment_flutter_platform_interface.dart](lib/airwallex_payment_flutter_platform_interface.dart)):
   - Abstract interface defining platform methods
   - Default implementation via method channel in [lib/airwallex_payment_flutter_method_channel.dart](lib/airwallex_payment_flutter_method_channel.dart)

3. **Native Implementation**:
   - **Android**: [android/src/main/kotlin/com/example/airwallex_payment_flutter/](android/src/main/kotlin/com/example/airwallex_payment_flutter/)
     - Main plugin: `AirwallexPaymentFlutterPlugin.kt`
     - Core logic: `AirwallexPaymentSdkModule.kt`
     - Parser utilities: `AirwallexPaymentSessionParser.kt`, `AirwallexRecurringSessionParser.kt`, `AirwallexRecurringWithIntentSessionParser.kt`, `AirwallexCardParser.kt`, etc.
   - **iOS**: [ios/airwallex_payment_flutter/Sources/airwallex_payment_flutter/](ios/airwallex_payment_flutter/Sources/airwallex_payment_flutter/)
     - Main plugin: `AirwallexPaymentFlutterPlugin.swift`
     - SDK wrapper: `AirwallexSdk.swift`
     - Session builder: `AirwallexSdk+Session.swift`
     - Extension files for type conversion (`AWXCard+Extensions.swift`, etc.)

### Payment Session Types
Three payment session types defined in [lib/types/payment_session.dart](lib/types/payment_session.dart):

1. **OneOffSession**: Single payment with `paymentIntentId`
2. **RecurringSession**: Recurring payments without initial intent
3. **RecurringWithIntentSession**: Recurring with initial payment intent

All sessions extend `BaseSession` and use `json_serializable` for serialization.

### JSON Serialization
- Uses `json_annotation` and `json_serializable` packages
- Generated files have `.g.dart` suffix
- Regenerate with: `flutter pub run build_runner build`
- Type classes: `Card`, `CardBrand`, `PaymentConsent`, `PaymentResult`, `PaymentSheetConfiguration`, `Shipping`, `GooglePayOptions`, `ApplePayOptions`, `Billing`, `Environment`

### Communication Flow
```
Flutter App
    ↓ (Dart types)
Airwallex class (lib/airwallex.dart)
    ↓ (Method channel with JSONMethodCodec)
Native Plugin (Kotlin/Swift)
    ↓ (Native SDK APIs)
Airwallex Native SDK (Android/iOS)
```

## Key Integration Points

### Environment Configuration
Set environment during initialization:
- `staging` or `demo`: For testing
- `production`: For production use

```dart
Airwallex.initialize(environment: Environment.demo);
```

### Return URL Configuration
Required for third-party payment redirects:
- **Android**: Configure intent filter in AndroidManifest.xml with scheme `airwallexcheckout` and host `${applicationId}`
- **iOS**: Configure custom URL scheme in Info.plist

Example: `airwallexcheckout://com.example.airwallex_payment_flutter_example`

### Payment Methods
Supported payment methods:
- Cards: Visa, Mastercard, Amex, Diners Club, JCB, Discover, Union Pay
- E-Wallets: Alipay, AlipayHK, DANA, GCash, Kakao Pay, Touch 'n Go, WeChat Pay
- Apple Pay (iOS only, requires proper merchant identifier setup)
- Google Pay (Android only, with `GooglePayOptions`)

### Theme Customization
- **Android**: Override `airwallex_tint_color` in `res/values/colors.xml`
- **iOS**: Use `Airwallex.setTintColor(Colors.red)` in Dart

## Development Notes

### Version Management
- Plugin version: Managed in `pubspec.yaml` (currently 0.3.1)
- Android SDK version: Controlled by `airwallex_version` in [android/build.gradle](android/build.gradle)
- iOS SDK version: Controlled by `airwallex_version` in [ios/airwallex_payment_flutter.podspec](ios/airwallex_payment_flutter.podspec)

### Example App
Located in [example/](example/):
- Demonstrates all integration patterns (UI components and low-level APIs)
- API client implementation in `example/lib/api/`
- Session creators in `example/lib/util/session_creator.dart`

### Testing
- Unit tests: Run `flutter test`
- Android unit tests: `android/src/test/` (e.g. `AirwallexSupportedBrandsParserTest.kt`)
- Integration tests: Available in `example/integration_test/`
- Test card numbers: See GUIDE.md or https://cardinaldocs.atlassian.net/wiki/spaces/CCen/pages/903577725/EMV+3DS+Test+Cases

### Logging
Initialize with logging enabled for debugging:
```dart
Airwallex.initialize(
  environment: Environment.demo,
  enableLogging: true,
  saveLogToLocal: false
);
```

### Agent Documentation
- `AGENTS.md` is the canonical, committed agent guide for this repo.
- `CLAUDE.md` is gitignored for optional local use (e.g. symlink to `AGENTS.md` for Claude Code). Do not maintain duplicate copies.
