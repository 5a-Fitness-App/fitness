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
      userName: 'test',
      userProfilePhoto: 'fish',
      userBio: 'testBiography',
      userDOB: DateTime(2000, 01, 01),
      userWeight: 0,
      userUnits: 'kg',
      accountCreationDate: DateTime.now(),
      userEmail: 'test@email.com',
      friendCount: 2,
    );
  }
}

// Mock Post for testing
class MockPostNotifier extends PostNotifier {
  MockPostNotifier(super.ref) {
    state = Posts(userWorkouts: [
      {
        'id': 1,
        'workoutName': 'Test Workout',
        'workout_ID': 1,
        'hasLiked': false,
      }
    ], friendsWorkouts: []);
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
      createWidgetUnderTest(overrides: [
        userNotifier.overrideWith((ref) => MockUserNotifier(ref)),
        postNotifier.overrideWith((ref) => MockPostNotifier(ref)),
      ]),
    );

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Verify username and biography are visible
    expect(find.text('test'), findsOneWidget);
    expect(find.text('testBiography'), findsOneWidget);

    // Verify Dashboard and My Posts buttons are visible
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('My Posts'), findsOneWidget);
  });

  // Verify user can switch between Dashboard and My Posts
  testWidgets('User can switch between Dashboard and My Posts',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      createWidgetUnderTest(overrides: [
        userNotifier.overrideWith((ref) => MockUserNotifier(ref)),
        postNotifier.overrideWith((ref) => MockPostNotifier(ref)),
      ]),
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
    // expect(something only in dashboard)
  });
}
