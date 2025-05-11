import 'package:fitness_app/frontend/modals/log_workout_modal.dart';
import 'package:fitness_app/frontend/states/login_screen.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/frontend/states/profile_page.dart';
import 'package:fitness_app/frontend/states/home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Widget serves as the main container for the app's core pages,
// handles navigation between the home and profile screens
// provides access to settings drawer for deleting user's account and logging out
class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  IndexState createState() => IndexState();
}

// State for the Index widget
// Manages the currently displayed page and the bottom navigation bar's state
class IndexState extends ConsumerState<Index> {
  // The index of the currently selected page
  int selectedPage = 0;
  // The index of the currently selected item in the bottom navigation bar
  int pageIndex = 0;

  // List of widget representing the main pages of the app
  final pages = const [
    HomePage(),
    ProfilePage(),
  ];

  // List of names corresponding to pages, used for the app bar title
  final pageName = const ['Home', 'Profile'];

  // Opens a modal bottom sheet that allows the user to log a new workout
  void openLogWorkoutModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => const LogWorkoutPage(),
    );
  }

  // Logs the current user out of the application
  // Navigates back to the login page
  void logout() {
    // Inform the user notifier to perform the logout operation
    ref.read(userNotifier.notifier).logOut();

    // Navigates to the login screen
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  // Deletes the currently logged-in user's account
  // Navigates back to the login page
  void deleteAccount() {
    // Inform user notfiier to perform the account deletion operation
    ref.read(userNotifier.notifier).deleteUserAccount();

    // Navigates to the login screen
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // The end drawer for accessing settings
      endDrawer: Drawer(
        child: TextButton(
            onPressed: () {},
            child: ListView(
              children: [
                // Settings header
                const DrawerHeader(child: Text('Settings')),

                // Logout
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('Log out'),
                  onTap: logout,
                ),

                // Delete
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete Account'),
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  onTap: deleteAccount,
                ),
              ],
            )),
      ),

      // App bar at the top of the screen
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,

        // Displays the title of the currently selected page
        title: Text(pageName[selectedPage]),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 4,
        shadowColor: const Color.fromARGB(70, 0, 0, 0),
      ),

      // The body of the scaffold, displaying the currently selected page
      body: pages[selectedPage],

      // The bottom navigation bar for switching between Home and Profile Page
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
              // Handle navigation based on the taped bottom mavigation item
              if (index == 0) {
                setState(() {
                  // Load friend's workouts when navigating to the Home page
                  ref.read(postNotifier.notifier).loadFriendsWorkouts();
                  selectedPage = 0;
                  pageIndex = 0;
                });
              } else if (index == 2) {
                setState(() {
                  // Load the user's own workouts when navigating to the Profile page
                  ref.read(postNotifier.notifier).loadUserWorkouts();
                  selectedPage = 1;
                  pageIndex = 2;
                });
              } else if (index == 1) {
                // Open the log workout modal when the 'Log' button is tapped
                openLogWorkoutModal();
              }
            },
          )),
    );
  }
}
