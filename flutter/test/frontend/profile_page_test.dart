import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/models/user.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';
import 'package:fitness_app/backend/models/post.dart';

// Mock User for testing
class MockUserNotifier extends UserNotifier {
  MockUserNotifier(super.ref) {
    state = User(
        userID: 1,
        userName: 'testUsername',
        userProfilePhoto: 'fish',
        userBio: 'testBiography',
        userDOB: DateTime(2000, 01, 01),
        userWeight: 0,
        userUnits: 'kg',
        accountCreationDate: DateTime.now(),
        userEmail: 'test@email.com',
        friendCount: 2);
  }
}

// Mock Post for testing
class MockPostNotifierPopulated extends PostNotifier {
  MockPostNotifierPopulated(super.ref) {
    state = Posts(userWorkouts: [
      {
        'id': 1,
        'workout_caption': 'Test Workout',
        'workout_date_time': DateTime.now(),
        'user_profile_photo': 'fish',
        'workout_ID': 1,
        'hasLiked': false,
        'workout_public': true
      },
    ], friendsWorkouts: []);
  }
}

// Empty Mock Posts for testing
class MockPostNotifierEmpty extends PostNotifier {
  MockPostNotifierEmpty(super.ref) {
    state = Posts(userWorkouts: [], friendsWorkouts: []);
  }
}

void main() {
  // Create widget for testing
  Widget createWidgetUnderTest({List<Override> overrides = const []}) {
    return ProviderScope(
      overrides: overrides,
      child: const MaterialApp(home: ProfilePage()),
    );
  }

  // Verify the presence of all UI elements
  testWidgets('Profile Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userNotifier.overrideWith((ref) => MockUserNotifier(ref)),
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap on My Posts
    await tester.tap(find.text('My Posts'));
    await tester.pumpAndSettle();

    // Verify username, friends and biography are visible
    expect(find.text('testUsername'), findsOneWidget);
    expect(find.text('2 friends'), findsOneWidget);
    expect(find.text('testBiography'), findsOneWidget);

    // Verify Dashboard and My Posts buttons are visible
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('My Posts'), findsOneWidget);

    // Verify the test workout is visible
    expect(find.text('Test Workout'), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsWidgets);
    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsWidgets);

    // Verify view workout buttons is visible
    expect(find.text('View Workout'), findsOneWidget);
  });

  // Verify user can switch between Dashboard and My Posts
  testWidgets('User can switch between Dashboard and My Posts',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userNotifier.overrideWith((ref) => MockUserNotifier(ref)),
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap on My Posts button
    await tester.tap(find.text('My Posts'));
    await tester.pumpAndSettle();

    // Verify if My Posts is displayed
    expect(find.text('Test Workout'), findsOneWidget);

    // Tap on Dashboard button
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    // Verify if Dashboard is displayed
    // expect(find.text('something only in dashboard'),findsOneWidget);
  });

  // Verify no posts alerts the user
  testWidgets('Display message when user has no posts',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userNotifier.overrideWith((ref) => MockUserNotifier(ref)),
          postNotifier.overrideWith((ref) => MockPostNotifierEmpty(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap My Posts
    await tester.tap(find.text('My Posts'));
    await tester.pumpAndSettle();

    // Expect to find message regarding not posting
    expect(find.text("You haven't posted"), findsOneWidget);
  });

  // Verify that pressing view workout takes the user to the workout
  testWidgets('View Workout button takes user to view their workout',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userNotifier.overrideWith((ref) => MockUserNotifier(ref)),
          postNotifier.overrideWith((ref) => MockPostNotifierPopulated(ref)),
        ],
        child: createWidgetUnderTest(),
      ),
    );

    await tester.pumpAndSettle();

    // Tap My Posts
    await tester.tap(find.text('My Posts'));
    await tester.pumpAndSettle();

    // Tap view workout
    await tester.tap(find.widgetWithText(ElevatedButton, 'View Workout'));
    await tester.pumpAndSettle();

    // Find an element in the workout
    expect(find.text('Comments'), findsOneWidget);
  });
}
