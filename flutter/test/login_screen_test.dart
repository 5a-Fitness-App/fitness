import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_app/frontend/states/login_screen.dart';

// Testing for the Login Screen
void main() {
  // Verify the presence of all UI elements
  testWidgets('Login Screen UI elements are displayed',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

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
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap submit button without entering anything
    await tester.tap(find.text('Submit'));
    await tester.pump();

    // Verify if error messages appear for email and password fields
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  // Verify that Forgot Password button functions
  testWidgets('Forgot Password', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Tap the 'Forgot Password?' link
    await tester.tap(find.text('Forgot Password?'));
    await tester.pump();

    // Verify if the system asks the user for their email
    expect(find.text('Please enter your email'), findsOneWidget);
  });

  // Verify if Forgot Password sends an email to the user
  testWidgets('Forgot Password email test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

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
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    // Find the password visibility toggle button
    final passwordToggle = find.byIcon(Icons.visibility);
    expect(passwordToggle, findsOneWidget);

    // Tap the visibility toggle button
    await tester.tap(passwordToggle);
    await tester.pump();

    // Check if the visibility icon changes
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });
}
