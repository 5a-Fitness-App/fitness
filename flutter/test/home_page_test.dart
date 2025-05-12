import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fitness_app/backend/models/post.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';

// Class to create empty mock with no posts
class MockPostNotifierEmpty extends PostNotifier {
  MockPostNotifierEmpty(super.ref) {
    state = Posts(userWorkouts: [], friendsWorkouts: []);
  }
}

// Class to create populated mock with a friend's post
class MockPostNotifierPopulated extends PostNotifier {
  MockPostNotifierPopulated(super.ref) {
    state = Posts(
      userWorkouts: [],
      friendsWorkouts: [
        {
          'id': 1,
          'workout_caption': 'Test Workout',
          'workout_date_time': DateTime.now(),
          'user_profile_photo': 'fish',
          'workout_ID': 1,
          'hasLiked': false
        },
      ],
    );
  }
}

void main() {
  Widget createWidgetUnderTest() {
    return const MaterialApp(home: HomePage());
  }

  // Verify the presence of all UI elements
  testWidgets('Home Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

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

    // Verify posts are visible
    expect(find.text('View Workout'), findsWidgets);

    // Verify likes and comments are visible
    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsWidgets);
  });

  // Verify that the Log Workout button takes the user to the log workout page
  testWidgets('Log Workout button takes user to log_workout_page',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap log workout button
    await tester.tap(find.text('Log Workout'));
    await tester.pump();

    // Verify the user is taken to the log workout page
    expect(find.text('Post'), findsOneWidget);
  });

  // Verify that the View Workout button takes the user to view the workout
  testWidgets('View workout button takes user to view the workout',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap log workout button
    await tester.tap(find.text('View Workout'));
    await tester.pump();

    // Verify that the user is taken to a workout
    expect(find.text('Comments'), findsOneWidget);
  });

  // Verify that when no posts are available, a message is displayed
  testWidgets('Display message when no posts are available',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postNotifier.overrideWith((ref) => MockPostNotifierEmpty(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    await tester.pumpAndSettle();

    // Check if a message is displayed indicating no posts are available
    expect(find.text("You're friends haven't posted"), findsOneWidget);
  });

  // Verify that when posts are available they are displayed
  testWidgets('Display Posts when available', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    await tester.pumpAndSettle();

    // Check if 'Test Workout' post is displayed
    expect(find.text('Test Workout'), findsOneWidget);
  });
}
