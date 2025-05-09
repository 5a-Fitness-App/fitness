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

  // Verify the presence of all UI elements on Sign in screen
  testWidgets('Sign in UI elements are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify the presence of the the title
    expect(find.text('FitFish'), findsOneWidget);

    // Verify the presence of the 'Login with an existing account' text
    expect(find.text('Login with an existing account'), findsOneWidget);

    // Verify the presence of the email and password text fields
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

    // Verify the presence of 'Sign in' and 'Sign up' buttons
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Sign up'), findsOneWidget);

    // Verify the presence of 'Sign In' button
    expect(find.text('Sign In'), findsOneWidget);
  });

  // Verify that the user can interact with text fields
  testWidgets('User can interact with text fields',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter text into the email text field
    await tester.enterText(
        find.widgetWithText(TextFormField, ('Email')), 'email@example.com');
    await tester.pumpAndSettle();

    // Verify if the email text field is focused
    expect(find.text('email@example.com'), findsOneWidget);
  });

  // Verify that empty fields show error messages if the user tries to submit,
  testWidgets('Empty fields show errors', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap Sign In button without entering anything
    await tester.tap(find.text('Sign In'));
    await tester.pump();

    // Verify if error messages appear for email and password fields
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
  });

  // Verify if the password visibility field toggles correctly
  testWidgets('User can toggle password visibility',
      (WidgetTester tester) async {
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

  // Verify if the email and password fields are validated correctly on log in screen
  testWidgets('Email and Password validation', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify if invalid emails and passwords show error messages
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    // Enter invalid email and password
    await tester.enterText(emailField, 'invalidEmail.Address');
    await tester.enterText(passwordField, 'fail');
    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify if error messages appear for invalid email and password
    expect(find.textContaining('Home'), findsNothing);
  });

  // Verify that the user can sign in successfully
  testWidgets('User can sign in and be redirected to home page',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Enter valid email and password
    await tester.enterText(
        find.widgetWithText(TextFormField, ('Email')), 'aqua_fish@example.com');
    await tester.enterText(
        find.widgetWithText(TextFormField, ('Password')), 'hashedpassword1');

    // Tap the Sign In button
    final signInButton = find.widgetWithText(ElevatedButton, 'Sign In');
    expect(signInButton, findsOneWidget);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify if user is taken to the home page
    expect(find.byKey(const Key('homePage')), findsOneWidget);
  });

  // Verify that the user can switch to the Sign Up screen
  testWidgets('User can switch to the Sign Up Screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Tap Sign up button
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Verify the presence of Sign Up elements
    expect(find.text('Create a new account'), findsOneWidget);
  });

  // Verify the presence of all UI elements on Sign Up screen
  testWidgets('Sign up UI elements are displayed', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Switch to Sign up screen
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Verify the presence of the the 'Create a new account' text
    expect(find.text('Create a new account'), findsOneWidget);

    // Verify the presence of the 'Select a Profile Image' text
    expect(find.text('Select a Profile Image'), findsOneWidget);

    // Verify the presence of all images on screen
    expect(find.byType(Image), findsNWidgets(5));

    // Verify the presence of the username, email, password and confirm password text fields
    expect(find.widgetWithText(TextFormField, 'Username'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
    expect(
        find.widgetWithText(TextFormField, 'Confirm Password'), findsOneWidget);

    // Verify the presence of the birthday selections
    expect(find.text('Enter your birthday: '), findsOneWidget);
    expect(find.byType(ElevatedButton), findsWidgets);

    // Verify the presence of the weight field and dropdown menu
    expect(find.widgetWithText(TextFormField, 'Weight'), findsOneWidget);
    expect(find.byType(DropdownMenu), findsOneWidget);

    // Verify the presence of the Sign Up button
    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });

  // Check that Password and Confirm Password fields match
  testWidgets('Password and Confirm Password match',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Switch to Sign up screen
    await tester.tap(find.text('Sign up'));
    await tester.pumpAndSettle();

    // Enter 2 different passwords into Password and Confirm Password fields
    await tester.enterText(
        find.widgetWithText(TextFormField, ('Password')), 'password');
    await tester.enterText(
        find.widgetWithText(TextFormField, ('Confirm Password')),
        'invalidPassword');

    // Press Sign Up button
    final signUpButton = find.widgetWithText(ElevatedButton, 'Sign Up');
    await tester.tap(signUpButton);
    await tester.pumpAndSettle();

    // Verify if error message appears for mismatched passwords
    expect(find.text("Passwords don't match"), findsOneWidget);
  });
}
