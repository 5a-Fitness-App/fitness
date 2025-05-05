import 'package:fitness_app/backend/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/frontend/modals/show_workout_modal.dart';

class ViewingProfilePage extends ConsumerStatefulWidget {
  final int userID;

  const ViewingProfilePage({super.key, required this.userID});

  @override
  ViewingProfilePageState createState() => ViewingProfilePageState();
}

class ViewingProfilePageState extends ConsumerState<ViewingProfilePage> {
  late Future<Map<String, dynamic>> profile;

  @override
  void initState() {
    super.initState();
    profile = getProfileDetails(widget.userID);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: SingleChildScrollView(
              child: Column(children: [
                FutureBuilder<Map<String, dynamic>>(
                    future: profile,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No activities found.'));
                      } else {
                        return Column(children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 20, bottom: 5, left: 3, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                                Text(
                                  snapshot.data!['user_name'],
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
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
                                              image: AssetImage(
                                                  'assets/${snapshot.data!['user_profile_photo']}.png'),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!['user_name'],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          FutureBuilder<int>(
                                            future: getFriendCount(snapshot
                                                    .data![
                                                'user_ID']), // The future you're waiting on
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Text(
                                                    'Loading...'); // Show a loading indicator or message while waiting
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}'); // Handle errors if any
                                              } else if (snapshot.hasData) {
                                                return Text(
                                                  '${snapshot.data} friends',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                ); // Show the result when data is available
                                              } else {
                                                return const Text(
                                                    'No data'); // Handle case where no data is returned
                                              }
                                            },
                                          )
                                        ],
                                      )),
                                    ],
                                  ),
                                  Text(
                                    snapshot.data!['user_bio'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ]),
                          )
                        ]);
                      }
                    }),
                const Divider(),
                FutureBuilder<List<Map<String, dynamic>>>(
                    future: getUserWorkouts(widget.userID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text('No activities found.'));
                      } else {
                        return SingleChildScrollView(
                            child: ProfilePosts(workouts: snapshot.data!));
                      }
                    })
              ]),
            )));
  }
}

class ProfilePosts extends StatelessWidget {
  final List<Map<String, dynamic>> workouts;

  const ProfilePosts({super.key, required this.workouts});

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
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              spacing: 5,
                              children: [
                                Row(spacing: 5, children: [
                                  Text(
                                    workout['user_name'] ?? '',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      DateFormat('dd MMMM yyyy')
                                          .format(workout['workout_date_time']),
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
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flex(
                                    direction: Axis.horizontal,
                                    spacing: 5,
                                    children: [
                                      const Icon(
                                          Icons.favorite_outline_rounded),
                                      Text(
                                        workout['total_likes'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                          Icons.chat_bubble_outline_rounded),
                                      Text(
                                        workout['total_comments'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
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
