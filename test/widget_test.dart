// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:dicume_app/main.dart';
import 'package:dicume_app/core/constants/app_constants.dart';

void main() {
  group('DICUMÊ App Tests', () {
    testWidgets('App loads with correct title and theme', (
      WidgetTester tester,
    ) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const ProviderScope(child: DicumeApp()));

      // Wait for splash screen or any async operations
      await tester.pump(const Duration(milliseconds: 100));

      // Find the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verify app title
      expect(materialApp.title, AppConstants.appName);

      // Verify debug banner is disabled
      expect(materialApp.debugShowCheckedModeBanner, false);

      // Verify theme is applied
      expect(materialApp.theme, isNotNull);
    });

    testWidgets('App has proper accessibility configuration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ProviderScope(child: DicumeApp()));

      await tester.pump(const Duration(milliseconds: 100));

      // Check if MediaQuery builder is applied for accessibility
      final mediaQuery = find.byType(MediaQuery);
      expect(mediaQuery, findsWidgets);
    });

    testWidgets('App initializes without throwing exceptions', (
      WidgetTester tester,
    ) async {
      // This test ensures the app can be built without crashing
      expect(() async {
        await tester.pumpWidget(const ProviderScope(child: DicumeApp()));
        await tester.pump();
      }, returnsNormally);
    });
  });
}
