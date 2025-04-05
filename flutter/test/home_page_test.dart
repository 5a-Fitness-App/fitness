import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/home_page.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

void main() {
  //Verify the presence of all UI elements
  testWidgets('Home Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Verify workout buttons are visible
    expect(find.text('Log Workout'), findsOneWidget);
    expect(find.text('Start Workout'), findsOneWidget);

    // Verify streak elements are visible
    expect(find.text('Streak'), findsOneWidget);
    expect(find.textContaining('🔥'), findsOneWidget);

    // Verify daily achievements are visible
    expect(find.text('Daily Achievements'), findsOneWidget);
    expect(find.byType(CircularPercentIndicator), findsOneWidget);

    // Verify recent activity is visible
    expect(find.text('Recent Activity'), findsOneWidget);

    // Verify posts are visible, waiting for backend to be implemented
    //expect();

    // Verify comments and likes are visible
    expect(find.textContaining('❤️'), findsWidgets);
    expect(find.textContaining('💬'), findsWidgets);

    // Verify view workout button is visible
    expect(find.text('View Workout'), findsWidgets);

    // Verify view more workouts button is visible
    expect(find.text('View More Workouts'), findsOneWidget);
  });

  // Verify that the Log Workout button takes the user to the log workout page, waiting for backend to be implemented before attempting
  testWidgets('Log Workout button takes user to log_workout_page',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Currently checks if pressing the log workout button works, needs to eventually be changed to take the user to log workout
    final logWorkoutButton = find.text('Log Workout');
    expect(logWorkoutButton, findsOneWidget);
    await tester.tap(logWorkoutButton);
    await tester.pump();
  });
}
