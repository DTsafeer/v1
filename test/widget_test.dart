import 'package:flutter_test/flutter_test.dart';
import 'package:v1/main.dart';

void main() {
  testWidgets('App load test', (WidgetTester tester) async {
    // تشغيل التطبيق بالاسم الجديد SystemCafeApp
    await tester.pumpWidget(const SystemCafeApp());
  });
}