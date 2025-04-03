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
  int pageIndex = 0;

  final pages = const [
    HomePage(),
    ProfilePage(),
  ];

  final pageName = const ['Home', 'Log Workout', 'Profile'];

  void openLogWorkoutModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) =>
          const LogWorkoutPage(), // Use your LogWorkoutPage as a modal
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(pageName[selectedPage]),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 4,
        shadowColor: const Color.fromARGB(70, 0, 0, 0),
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
            currentIndex: pageIndex,
            onTap: (index) {
              if (index == 0) {
                setState(() {
                  selectedPage = 0;
                  pageIndex = 0;
                });
              } else if (index == 2) {
                setState(() {
                  selectedPage = 1;
                  pageIndex = 2;
                });
              } else if (index == 1) {
                openLogWorkoutModal();
              }
            },
          )),
    );
  }
}
