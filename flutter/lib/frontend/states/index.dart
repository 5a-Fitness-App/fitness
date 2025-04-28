import 'package:fitness_app/frontend/states/log_workout_page.dart';
import 'package:fitness_app/frontend/states/login_screen.dart';
import 'package:fitness_app/functional_backend/provider/post_provider.dart';
import 'package:fitness_app/functional_backend/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/frontend/states/profile_page.dart';
import 'package:fitness_app/frontend/states/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  IndexState createState() => IndexState();
}

class IndexState extends ConsumerState<Index> {
  int selectedPage = 0;
  int pageIndex = 0;

  final pages = const [
    HomePage(),
    ProfilePage(),
  ];

  final pageName = const ['Home', 'Profile'];

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

  void logout() {
    ref.read(userNotifier.notifier).logOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: Drawer(
        child: TextButton(
            onPressed: () {},
            child: ListView(
              children: [
                const DrawerHeader(
                  child: Text('Settings'),
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: logout,
                ),
              ],
            )),
      ),
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
            unselectedItemColor: Colors.grey.shade500,
            selectedItemColor: Colors.black,
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
                  ref.read(postNotifier.notifier).loadFriendsWorkouts();
                  selectedPage = 0;
                  pageIndex = 0;
                });
              } else if (index == 2) {
                setState(() {
                  ref.read(postNotifier.notifier).loadUserWorkouts();
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
