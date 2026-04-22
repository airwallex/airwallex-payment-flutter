import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:airwallex_payment_flutter_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('airwallex_payment_flutter', JSONMethodCodec());

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'app_lang': 'zh',
      'environment': 'demo',
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'initialize':
            case 'setLocale':
              return null;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('loads saved Chinese locale in the example app', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Airwallex 示例'), findsOneWidget);
    expect(find.text('语言演示'), findsOneWidget);
    expect(find.text('当前同步给 Airwallex 的 locale：zh-Hans'), findsOneWidget);
  });
}
