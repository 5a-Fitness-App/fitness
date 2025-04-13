import 'package:fitness_app/functional_backend/api.dart';
import 'package:fitness_app/functional_backend/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/models/user.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/frontend/states/my_workout.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  bool dashBoardMode = true;
  late Future<List<Map<String, dynamic>>> userWorkouts;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final userID = ref.watch(userNotifier).userID ?? 0;
      userWorkouts = getUserWorkout(userID);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userNotifier);

    return SingleChildScrollView(
        child: Column(children: [
      Container(
        padding: const EdgeInsets.all(20),
        child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // color: Color.fromARGB(255, 167, 227, 255)
                        image: DecorationImage(
                          image:
                              AssetImage('assets/${user.userProfilePhoto}.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Flex(
                    direction: Axis.vertical,
                    spacing: 3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.userName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<int>(
                        future:
                            getFriendCount(ref.watch(userNotifier).userID ?? 0),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text('${snapshot.data} friends');
                          }
                        },
                      ),
                    ],
                  )),
                ],
              ),
              Text(
                user.userBio ?? '',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ]),
      ),
      Flex(
        direction: Axis.horizontal,
        children: [
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.black,
                  side: const BorderSide(
                      color: Colors.black, style: BorderStyle.solid)),
              child: const Text('Edit profile'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add friends',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
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
      FutureBuilder<List<Map<String, dynamic>>>(
        future: userWorkouts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No activities found.'));
          } else {
            return SingleChildScrollView(
              child: dashBoardMode
                  ? MyPosts(workouts: snapshot.data!)
                  : const Dashboard(),
            );
          }
        },
      )
    ]));
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      // TODO: implement acheivements
      children: [Text('Dashboard')],
    );
  }
}

class MyPosts extends StatelessWidget {
  final List<Map<String, dynamic>> workouts;

  const MyPosts({super.key, required this.workouts});

  void openWorkoutModal(BuildContext context, int workoutID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => MyWorkoutPage(workoutID: workoutID),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (workouts.isEmpty) const Text('Log a workout!'),
        for (Map<String, dynamic> workout in workouts) ...[
          Container(
              padding: const EdgeInsets.only(
                  top: 12, right: 15, left: 12, bottom: 5),
              child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/${workout['user_profile_photo']}.png'),
                            fit: BoxFit.fill,
                          ),
                        )),
                    Expanded(
                        child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 5,
                              children: [
                                Flex(
                                    direction: Axis.horizontal,
                                    spacing: 5,
                                    children: [
                                      Text(
                                        workout['user_name'] ?? '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          DateFormat('dd MMMM yyyy').format(
                                              workout['workout_date_time']),
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.grey.shade700))
                                    ]),
                                Text(
                                    workout['workout_public']
                                        ? 'Public'
                                        : 'Private',
                                    style:
                                        TextStyle(color: Colors.grey.shade700))
                              ]),
                          Text(workout['workout_caption'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w600
                              )),
                          Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                    onPressed: () {
                                      openWorkoutModal(
                                          context, workout['workout_ID'] ?? 0);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black),
                                    child: const Text(
                                      'View Workout',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                              ])
                        ]))
                  ])),
          const Divider()
        ]
      ],
    );
  }
}
