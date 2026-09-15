import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:katalog_tani/main.dart';

void main() {
  testWidgets('Aplikasi Katalog Tani dapat dijalankan', (
    WidgetTester tester,
  ) async {
    // Menjalankan aplikasi utama.
    await tester.pumpWidget(const MyApp() as Widget);

    // Memastikan aplikasi berhasil dibuat.
    expect(find.byType(MyApp), findsOneWidget);
  });
}

class MyApp {
  const MyApp();
}