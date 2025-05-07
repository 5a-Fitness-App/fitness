import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/home_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(home: HomePage()),
    );
  }

  // Verify the presence of all UI elements
  testWidgets('Home Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Verify workout buttons are visible
    expect(find.text('Log Workout'), findsOneWidget);

    // Verify streak elements are visible
    expect(find.text('Streak'), findsOneWidget);
    expect(find.textContaining('🔥'), findsOneWidget);

    // Verify daily achievements are visible
    expect(find.text('Daily Achievements'), findsOneWidget);
    expect(find.byType(CircularPercentIndicator), findsOneWidget);

    // Verify recent activity is visible
    expect(find.text('Recent Activity'), findsOneWidget);

    // Verify posts are visible, waiting for backend to be implemented
    expect(find.text('View Workout'), findsWidgets);

    // Verify comments and likes are visible
    expect(find.textContaining('❤️'), findsWidgets);
    expect(find.textContaining('💬'), findsWidgets);

    // Verify view more workouts button is visible
    //expect(find.text('View More Workouts'), findsOneWidget);
  });

  // Verify that the Log Workout button takes the user to the log workout page
  testWidgets('Log Workout button takes user to log_workout_page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap log workout button
    final logWorkoutButton = find.text('Log Workout');
    expect(logWorkoutButton, findsOneWidget);
    await tester.tap(logWorkoutButton);
    await tester.pump();

    // Verify the user is taken to the log workout page
    expect(find.text('Post'), findsOneWidget);
  });

  // Verify that the View Workout button takes the user to view the workout
  testWidgets('View Workout button takes user to view the workout',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap log workout button
    final viewWorkoutButton = find.text('View Workout');
    expect(viewWorkoutButton, findsOneWidget);
    await tester.tap(viewWorkoutButton);
    await tester.pump();

    // Verify that the user is taken to a workout
    expect(find.text('Comments'), findsOneWidget);
  });
}
