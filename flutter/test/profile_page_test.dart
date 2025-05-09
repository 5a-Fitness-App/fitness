import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/models/user.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';

void main() {
  // Create mock user
  final mockUser = User(
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

  // Create widget for testing
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      //  overrides: [
      //  userNotifier.overrideWith((ref) => mockUser),
      //      postNotifier.overrideWith((ref) => mockPosts),
      // ],
      child: MaterialApp(home: ProfilePage()),
    );
  }

  // Verify the presence of all UI elements
  testWidgets('Profile Page UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Verify username and biography are visible, for time being while not connected to backend
    expect(find.text('UserName'), findsOneWidget);
    expect(find.text('Biography'), findsOneWidget);

    // Verify profile picture is visible, still needs to be added

    // Verify Dashboard and My Posts buttons are visible
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('My Posts'), findsOneWidget);
  });

  // Verify user can switch between Dashboard and My Posts
  testWidgets('User can switch between Dashboard and My Posts',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfilePage()));

    // Give time for the UI to load
    await tester.pumpAndSettle();

    // Tap on My Posts button
    await tester.tap(find.text('My Posts'));
    await tester.pumpAndSettle();

    // Tap on Dashboard button
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();
  });
}
