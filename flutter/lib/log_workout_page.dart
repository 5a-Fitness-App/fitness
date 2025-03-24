import 'package:flutter/material.dart';

class LogWorkoutPage extends StatefulWidget {
  const LogWorkoutPage({super.key});

  @override
  LogWorkoutPageState createState() => LogWorkoutPageState();
}

class LogWorkoutPageState extends State<LogWorkoutPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add_photo_alternate_outlined)),
        ],
      ),
    );
  }
}
