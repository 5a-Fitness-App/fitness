import 'package:fitness_app/frontend/states/index.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/functional_backend/provider/user_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/api.dart';

import 'package:flutter/services.dart';

import 'dart:collection';

typedef WeightUnits = DropdownMenuEntry<WeightUnitsLabel>;

enum WeightUnitsLabel {
  kg('kg'),
  lb('lb');

  const WeightUnitsLabel(this.label);
  final String label;

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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {
  final signUpFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();

  // Signing in controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Signing up controllers
  final userNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  DateTime? selectedDoB;
  final weightController = TextEditingController();
  final weightUnitsController = TextEditingController();
  WeightUnitsLabel? selectedWeightUnit;
  final signUpPasswordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  String? emailError;
  String? passwordError;

  String? usernameError;

  bool hidePassword = true;
  bool registrationMode =
      false; //if false shows login form, if true shows registration form

  // Initially selected profile image
  String selectedProfileImage = 'fish';

  // Method to update the selected profile image
  void selectImage(String image) {
    setState(() {
      selectedProfileImage = image;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2021, 7, 25),
      firstDate: DateTime(1900),
      lastDate: DateTime(2025),
    );

    setState(() {
      selectedDoB = pickedDate;
    });
  }

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
            onTap: () => selectImage(imageName),
            child: Image.asset(
              'assets/$image.png', // Image path based on the selected name
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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

  void registerButton() async {
    setState(() {
      emailError = null; // Reset errors before validating
      passwordError = null;
    });

    try {
      String? errorMessage = await register(
          userNameController.text.trim(),
          selectedProfileImage,
          selectedDoB!,
          double.parse(weightController.text.trim()),
          selectedWeightUnit!.label,
          signUpEmailController.text.trim(),
          signUpPasswordController.text.trim());

      if (errorMessage == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Account created for ${emailController.text.trim()}')),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: Please try again')),
          );
        }

        if (errorMessage == 'An account with this email already exists') {
          setState(() {
            emailError =
                errorMessage; // Show error message in the password field
          });
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

  Widget buildSignInForm() {
    return Form(
      key: signInFormKey,
      child: Column(
        children: [
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

  Widget buildSignUpForm() {
    return Form(
      key: signUpFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            'Select a Profile Image: $selectedProfileImage',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          Flex(
              direction: Axis.horizontal,
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                imageWithBorder('fish', 'fish'),
                imageWithBorder('shark', 'shark'),
                imageWithBorder('crab', 'crab'),
                imageWithBorder('dolphin', 'dolphin')
              ]),
          const SizedBox(height: 30),
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
          Flex(
            direction: Axis.horizontal,
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
                          : 'No date selected',
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: signUpEmailController,
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
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: signUpPasswordController,
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
          SizedBox(
              height: 100,
              child: TextFormField(
                controller: passwordConfirmController,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password again',
                  labelText: 'Confirm Password',
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
                  if (value == null ||
                      value.isEmpty ||
                      value != signUpPasswordController.text.trim()) {
                    return "Passwords don't match";
                  }
                  return null;
                },
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
            child: Flex(
              direction: Axis.horizontal,
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
          Container(
            decoration:
                const BoxDecoration(color: Color.fromRGBO(154, 197, 244, 1)),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
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
          Container(
            padding: const EdgeInsets.all(10),
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
                    fontSize: 20,
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                registrationMode ? buildSignUpForm() : buildSignInForm(),
                ElevatedButton(
                  onPressed: registrationMode ? registerButton : login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    fixedSize: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height * 0.06),
                    backgroundColor: const Color.fromRGBO(154, 197, 244, 1),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
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
