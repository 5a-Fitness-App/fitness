import 'package:fitness_app/backend/models/workout_draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/modals/log_workout_modal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(home: LogWorkoutPage()),
    );
  }

  // Verify the presence of all UI elements on Log Workout Page
  testWidgets('Log Workout Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Expect to find text saying Cancel
    expect(find.text('Cancel'), findsOneWidget);

    // Expect to find button saying Post
    expect(find.widgetWithText(ElevatedButton, 'Post'), findsOneWidget);

    // Expect to find text saying Write a caption...
    expect(find.text('Write a caption...'), findsOneWidget);

    // Expect to find button saying Add Activity
    expect(find.widgetWithText(ElevatedButton, 'Add Activity'), findsOneWidget);

    // Expect to find exercise dropdown menu
    expect(find.byType(DropdownMenu<ExerciseTypeLabel>), findsOneWidget);
  });

  // User can add an activity
  testWidgets('User can add an activity', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap Add Activity button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Activity'));
    await tester.pumpAndSettle();

    // Expect to find elements on the activity
    expect(find.text('Running'), findsOneWidget);
  });

  // Verify the presence of all UI elements in an activity
  testWidgets('Activity UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap Add Activity button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Activity'));
    await tester.pumpAndSettle();

    // Expect to find text saying Running
    expect(find.text('Running'), findsOneWidget);

    // Expect to find text saying Time
    expect(find.text('Time'), findsOneWidget);

    // Expect to find text form fields for hours, minutes and seconds
    expect(find.widgetWithText(TextFormField, 'HH'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'MM'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'SS'), findsOneWidget);

    // Expect to find text for field for Distance
    expect(find.widgetWithText(TextFormField, 'Distance'), findsOneWidget);

    // Expect to find distance dropdown menu
    expect(find.byType(DropdownMenu<DistanceUnitsLabel>), findsOneWidget);

    // Expect to find text saying Select weight unit
    expect(find.text('Select weight unit'), findsOneWidget);

    // Expect to find text saying Write some notes...
    expect(find.text('Write some notes...'), findsOneWidget);

    // Expect to find button saying Delete
    expect(find.widgetWithText(ElevatedButton, 'Delete'), findsOneWidget);
  });
}
