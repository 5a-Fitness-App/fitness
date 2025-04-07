import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/profile_page.dart';

void main() {
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
