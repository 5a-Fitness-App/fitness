import 'package:fitness_app/frontend/states/index.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/api.dart';

import 'package:flutter/services.dart';

import 'dart:collection';

// type for Weight Units drop down menu
typedef WeightUnits = DropdownMenuEntry<WeightUnitsLabel>;

// Enumeration for selecting weight units with the label text they display
enum WeightUnitsLabel {
  kg('kg'),
  lb('lb');

  const WeightUnitsLabel(this.label);
  final String label;

  // List of dropdown entries for weight units
  static final List<WeightUnits> entries = UnmodifiableListView<WeightUnits>(
    values
        .map<WeightUnits>(
          (WeightUnitsLabel activity) => WeightUnits(
            value: activity,
            label: activity.label,
            enabled: activity.label != 'Grey',
          ),
        )
        .toList(),
  );
}

// Login screen widget with ConsumerStatefulWidget for state management
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  // Form Keys for validation
  final signUpFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();

  // Controllers for sign-in form
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // error messages for signing in
  String? emailError;
  String? passwordError;

  // Controllers for sign-up form
  final userNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  DateTime? selectedDoB;
  final weightController = TextEditingController();
  final weightUnitsController = TextEditingController();
  WeightUnitsLabel? selectedWeightUnit;
  final signUpPasswordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  // error messages for signing up
  String? usernameError;
  String? signUpEmailError; // TODO: implement
  String? signUpPasswordError; // TODO: implement
  String? birthdayError;

  // UI State variables
  bool hidePassword = true;
  bool registrationMode =
      false; //if false shows login form, if true shows registration form

  // Initially selected profile image
  String selectedProfileImage = 'fish';

  // Update the selected profile image
  void _selectImage(String image) {
    setState(() {
      selectedProfileImage = image;
    });
  }

  // Shows date picker for birthday selection
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    setState(() {
      selectedDoB = pickedDate;
    });
  }

  // Helper widget for profile image selection with border
  Widget imageWithBorder(String image, String imageName) {
    bool isSelected = selectedProfileImage == imageName;

    return Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? Colors.blue
                  : Colors.transparent, // Blue border for selected image
              width: 4.0,
            ),
            shape: BoxShape.circle // Rounded corners for the border
            ),
        child: ClipOval(
          child: InkWell(
            onTap: () => _selectImage(imageName),
            child: Image.asset(
              'assets/$image.png', // Image path based on the selected name
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up controllers
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    passwordConfirmController.dispose();
    weightController.dispose();
    weightUnitsController.dispose();
    super.dispose();
  }

  // Handles login form submission
  void login() async {
    setState(() {
      emailError = null; // Reset errors before validating
      passwordError = null;
    });

    try {
      if (signInFormKey.currentState!.validate()) {
        String? errorMessage = await ref
            .read(userNotifier.notifier)
            .login(emailController.text.trim(), passwordController.text.trim());

        // Successful login
        if (errorMessage == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Welcome back, ${emailController.text.trim()}')),
            );

            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const Index();
            }));
          }
        } else {
          // Failed login
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Login failed. Please check your credentials.')),
            );
          }

          setState(() {
            if (errorMessage == 'Email or password is incorrect') {
              emailError = '';
              passwordError =
                  errorMessage; // Show error message in the password field
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }
  }

  // Handles registration form submission

  void registerButton() async {
    try {
      setState(() {
        signUpEmailError = null; // Reset errors before validating
        signUpPasswordError = null;
      });

      if (signUpFormKey.currentState!.validate()) {
        // Validate required fields
        if (selectedDoB == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Please select your date of birth.')),
            );
          }
          return;
        }

        if (selectedWeightUnit == null) {
          if (mounted) {
            selectedWeightUnit = WeightUnitsLabel.kg;
          }
          return;
        }

        String? errorMessage = await register(
            userNameController.text.trim(),
            selectedProfileImage,
            selectedDoB!,
            double.parse(weightController.text.trim()),
            selectedWeightUnit!.label,
            signUpEmailController.text.trim(),
            signUpPasswordController.text.trim());

        if (errorMessage == null) {
          // Successful registration
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Account created for ${signUpEmailController.text.trim()}')),
            );
          }
        } else {
          // Failed registration
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Registration failed: Please try again')),
            );
          }

          if (errorMessage == 'An account with this email already exists') {
            setState(() {
              emailError =
                  errorMessage; // Show error message in the password field
            });
          }
        }
      }
    } catch (e) {
      print(e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unexpected error occurred.')),
        );
      }
    }
  }

  // Builds the sign-in form widget
  Widget buildSignInForm() {
    return Form(
      key: signInFormKey,
      child: Column(
        children: [
          // Email input field
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  errorText: emailError,
                  prefixIcon: const Icon(Icons.mail_outline),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  //if (email notFound)
                  return null;
                },
              )),

          // Password input field
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: passwordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  errorText: passwordError,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              )),
        ],
      ),
    );
  }

  // Builds the sign-up form widget
  Widget buildSignUpForm() {
    return Form(
      key: signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile image selection
          Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: InkWell(
                  onTap: () => _selectImage(selectedProfileImage),
                  child: Image.asset(
                    'assets/$selectedProfileImage.png', // Image path based on the selected name
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              )),

          const SizedBox(height: 15),

          Text(
            'Select a Profile Image',
            style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
          ),

          const SizedBox(height: 10),

          // Profile image options
          Row(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                imageWithBorder('fish', 'fish'),
                imageWithBorder('shark', 'shark'),
                imageWithBorder('crab', 'crab'),
                imageWithBorder('dolphin', 'dolphin')
              ]),

          const SizedBox(height: 30),

          // Username field
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  hintText: 'Enter a username',
                  labelText: 'Username',
                  errorText: usernameError,
                  prefixIcon: const Icon(Icons.person),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._-]+$').hasMatch(value)) {
                    return 'Username can only contain letters, numbers, underscores, periods, and hyphens';
                  }
                  //if (email notFound)
                  return null;
                },
              )),

          // Email field
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: signUpEmailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  errorText: signUpEmailError,
                  prefixIcon: const Icon(Icons.mail_outline),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  //if (email notFound)
                  return null;
                },
              )),

          // Password field
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: signUpPasswordController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  labelText: 'Password',
                  errorText: signUpPasswordError,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              )),

          // Password confirmation field with matching validation
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: passwordConfirmController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password again',
                  labelText: 'Confirm Password',
                  errorText: signUpPasswordError,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                  ),
                  enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 1)),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.grey, width: 2)),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value != signUpPasswordController.text.trim()) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              )),

          // Birthday selection
          Row(
            spacing: 10,
            children: [
              const Text("Enter your birthday: ",
                  style: TextStyle(fontSize: 16)),
              Expanded(
                child: ElevatedButton(
                    onPressed: _selectDate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 230, 230, 230),
                      foregroundColor: Colors.black,
                      minimumSize: const Size(100, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // ← change radius here
                      ),
                    ),
                    child: Text(
                      selectedDoB != null
                          ? '${selectedDoB!.day}/${selectedDoB!.month}/${selectedDoB!.year}'
                          : 'MM/DD/YYYY',
                    )),
              )
            ],
          ),

          const SizedBox(height: 30),

          // Weight input with unit selection
          SizedBox(
              height: 100,
              child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: weightController,
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true), // Numeric keyboard
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*$')),
                      ], // Allow only numbers and a decimal point
                      decoration: InputDecoration(
                        hintText: 'Enter your weight',
                        labelText: 'Weight',
                        errorText: emailError,
                        prefixIcon: const Icon(Icons.monitor_weight_outlined),
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a number';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Invalid number';
                        }
                        return null;
                      },
                    ),
                  ),

                  // Weight unit dropdown
                  DropdownMenu<WeightUnitsLabel>(
                      enableFilter: false,
                      enableSearch: false,
                      width: 125,
                      initialSelection: WeightUnitsLabel.kg,
                      controller: weightUnitsController,
                      dropdownMenuEntries: WeightUnitsLabel.entries,
                      helperText: 'Select weight unit',
                      inputDecorationTheme: InputDecorationTheme(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 230, 230, 230),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.all(10),
                      ),
                      onSelected: (WeightUnitsLabel? weightUnit) {
                        setState(() {
                          selectedWeightUnit = weightUnit;
                        });
                      })
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
          child: Column(
        children: [
          // Header section with logo and gradient background
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromRGBO(177, 240, 246, 1),
                Color.fromRGBO(154, 197, 244, 1),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/Logo.png'),
                    ),
                  ),
                ),
                const Text(
                  'FitFish',
                  style: TextStyle(fontSize: 40),
                ),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          ),

          // Form toggle buttons
          Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(154, 197, 244, 1)),
            child: Flex(
                direction: Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        registrationMode = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.06),
                        backgroundColor: registrationMode
                            ? const Color.fromRGBO(248, 248, 248, 0.5)
                            : const Color.fromRGBO(248, 248, 248, 1),
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)))),
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        registrationMode = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                            MediaQuery.of(context).size.height * 0.06),
                        backgroundColor: registrationMode
                            ? const Color.fromRGBO(248, 248, 248, 1)
                            : const Color.fromRGBO(248, 248, 248, 0.5),
                        shadowColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)))),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ]),
          ),

          // Form content
          Container(
            padding: const EdgeInsets.only(left: 17, right: 17, bottom: 17),
            decoration:
                const BoxDecoration(color: Color.fromRGBO(248, 248, 248, 1)),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  registrationMode
                      ? 'Create a new account'
                      : 'Login with an existing account',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                registrationMode ? buildSignUpForm() : buildSignInForm(),
                ElevatedButton(
                  onPressed: registrationMode ? registerButton : login,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40)),
                  child: Text(
                    registrationMode ? 'Sign Up' : 'Sign In',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
