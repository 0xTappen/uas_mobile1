// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uas_24312092/main.dart';

void main() {
  testWidgets('Login and logout with static account', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Akun: admin / admin'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'admin');
    await tester.enterText(find.byType(TextField).at(1), 'salah');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('Username atau password salah'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(1), 'admin');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(find.text('Selamat datang, admin'), findsOneWidget);

    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsNWidgets(2));
  });
}
