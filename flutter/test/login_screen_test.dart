import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Testing for the Login Screen
void main() {
  // Provider scope for riverpod
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(home: LoginScreen()),
    );
  }

  // Verify the presence of all UI elements
  testWidgets('Login Screen UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify the presence of the the title
    expect(find.text('FitFish'), findsOneWidget);

    // Verify the presence of the email and password text fields
    expect(find.byType(TextFormField), findsNWidgets(2));

    // Verify the presence of 'Sign in' and 'Sign up' buttons
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    // Verify the presence of 'Submit' button
    expect(find.text('Submit'), findsOneWidget);
  });

  // Verify that empty fields show error messages if the user tries to submit,
  testWidgets('Empty fields show errors', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap submit button without entering anything
    await tester.tap(find.text('Submit'));
    await tester.pump();

    // Verify if error messages appear for email and password fields
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  // Verify that Forgot Password button functions
  testWidgets('Forgot Password', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap the 'Forgot Password?' link
    await tester.tap(find.text('Forgot Password?'));
    await tester.pump();

    // Verify if the system asks the user for their email
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  // Verify if Forgot Password sends an email to the user
  testWidgets('Forgot Password email test', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter a valid email address
    final emailField = find.byType(TextFormField).first;
    await tester.enterText(emailField, 'john@example.com');
    await tester.pump();

    // Tap the 'Forgot Password?' link
    await tester.tap(find.text('Forgot Password?'));
    await tester.pump();

    // Verify if the system tells the user it has sent a password reset
    expect(find.text('Password reset sent'), findsOneWidget);
  });

  // Verify if the password visibility field toggles correctly
  testWidgets('Toggling password visibility', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Find the password visibility toggle button
    final passwordToggle = find.byIcon(Icons.visibility);
    expect(passwordToggle, findsOneWidget);

    // Tap the visibility toggle button
    await tester.tap(passwordToggle);
    await tester.pump();

    // Check if the visibility icon changes
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });

  // Verify if the email and password fields are validated correctly
  testWidgets('Email and Password validation', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify if invalid emails and passwords show error messages
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    await tester.enterText(emailField, 'Extremely-Valid_Email.Address');
    await tester.enterText(passwordField, 'FAIL');
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    // Verify if error messages appear for invalid email and password
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Password must be at least 6 characters'), findsOneWidget);
  });
}
