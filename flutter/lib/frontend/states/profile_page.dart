import 'package:flutter/material.dart';
import 'package:fitness_app/backend/services/db_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool dashBoardMode = true;
  List<Map<String, dynamic>> user = [];

  @override
  void initState() {
    super.initState();

    getUser();
  }

  Future<void> getUser() async {
    const query = 'SELECT * FROM users WHERE user_ID = 1;';

    try {
      final result = await dbService.readQuery(query);

      if (result.isNotEmpty) {
        setState(() {
          user = result
              .map((row) => {
                    'user_id': row[0], // Ensure the correct column is used
                    'user_name': row[1], // Ensure the correct column is used
                  })
              .toList();
        });
      } else {
        setState(() {
          user = []; // Empty list if no user data found
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        user = []; // Empty list on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(children: [
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.cyan
                          // image: DecorationImage(
                          //   image: AssetImage('assets/images/profile.jpg'),
                          //   fit: BoxFit.fill,
                          // ),
                          ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.isNotEmpty ? user[0]['user_name'] : 'Loading...',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Biography",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dashBoardMode = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                      MediaQuery.of(context).size.height * 0.06),
                ),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                      fontSize: 16,
                      color: dashBoardMode
                          ? const Color.fromARGB(255, 182, 181, 181)
                          : Colors.black),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    dashBoardMode = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  fixedSize: Size(MediaQuery.of(context).size.width * 0.5,
                      MediaQuery.of(context).size.height * 0.06),
                ),
                child: Text(
                  'My Posts',
                  style: TextStyle(
                      fontSize: 16,
                      color: dashBoardMode
                          ? Colors.black
                          : const Color.fromARGB(255, 182, 181, 181)),
                ),
              ),
            ]),
            const Divider(),
            SingleChildScrollView(
              child: dashBoardMode ? MyPosts() : Dashboard(),
            )
          ])
        ],
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [Text('Dashboard')],
    );
  }
}

class MyPosts extends StatelessWidget {
  const MyPosts({super.key});

  @override
  Widget build(BuildContext) {
    return const Column(
      children: [Text('posts')],
    );
  }
}
