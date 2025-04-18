import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_app/frontend/states/login_screen.dart';

import 'package:fitness_app/functional_backend/services/db_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await dbService.init();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            useMaterial3: false,
            dividerTheme: const DividerThemeData(
              thickness: 1,
              color: Color.fromARGB(255, 230, 230, 230),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
              elevation: const WidgetStatePropertyAll(0),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              )),
            ))),
        home: Builder(builder: (context) => const LoginScreen()));
  }
}

// TODO: get friend requests 
// TODO: settings drawer menu
// TODO: get profile photos
// TODO: process date and time from database