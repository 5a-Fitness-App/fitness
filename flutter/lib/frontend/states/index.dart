import 'package:fitness_app/frontend/states/log_workout_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/frontend/states/profile_page.dart';
import 'package:fitness_app/frontend/states/home_page.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  IndexState createState() => IndexState();
}

class IndexState extends State<Index> {
  int selectedPage = 0;

  final pages = const [
    HomePage(),
    LogWorkoutPage(),
    ProfilePage(),
  ];

  final pageName = const ['Home', 'Log Workout', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(pageName[selectedPage]),
      ),
      body: pages[selectedPage],
      bottomNavigationBar: Container(
          decoration: const BoxDecoration(boxShadow: [
            BoxShadow(
                color: Color.fromARGB(40, 0, 0, 0),
                spreadRadius: 1.0,
                blurRadius: 5.0,
                offset: Offset(0, 1))
          ]),
          child: BottomNavigationBar(
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box_outlined), label: 'Log'),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
            currentIndex: selectedPage,
            onTap: (index) {
              setState(() {
                selectedPage = index;
              });
            },
          )),
    );
  }
}
