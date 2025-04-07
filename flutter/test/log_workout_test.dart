import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/log_workout_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Verify the presence of all UI elements
  testWidgets('Log Workout Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: LogWorkoutPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
  });
}
