import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:airwallex_payment_flutter_example/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const airwallexChannel =
      MethodChannel('airwallex_payment_flutter', JSONMethodCodec());
  const hostLocaleChannel = MethodChannel('example_host_locale');
  MethodCall? lastHostLocaleMethodCall;

  setUp(() {
    SharedPreferences.setMockInitialValues({
      'app_lang': 'zh',
      'environment': 'demo',
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(airwallexChannel,
            (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'initialize':
          return null;
        default:
          return null;
      }
    });

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(hostLocaleChannel,
            (MethodCall methodCall) async {
      lastHostLocaleMethodCall = methodCall;
      return methodCall.arguments;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(airwallexChannel, null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(hostLocaleChannel, null);
    lastHostLocaleMethodCall = null;
  });

  testWidgets('loads saved Chinese locale and syncs host language', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Airwallex 示例'), findsOneWidget);
    expect(find.text('语言演示'), findsOneWidget);
    expect(find.text('当前宿主语言标签：zh-Hans'), findsOneWidget);
    expect(lastHostLocaleMethodCall?.method, 'setLanguage');
    expect(lastHostLocaleMethodCall?.arguments, {
      'languageTag': 'zh-Hans',
    });
  });
}
