import 'package:fitness_app/frontend/modals/show_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';
import 'package:fitness_app/frontend/states/index.dart';
import 'package:fitness_app/backend/models/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:fitness_app/frontend/modals/show_workout_modal.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    ref.read(postNotifier.notifier).loadFriendsWorkouts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Posts posts = ref.watch(postNotifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStreakBanner(),
            const Divider(),
            const SizedBox(height: 10),
            const Row(children: [
              SizedBox(
                width: 15,
              ),
              Text(
                'Recent Activity',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ]),
            const SizedBox(height: 12),
            FriendsPosts(workouts: posts.friendsWorkouts),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // streak banner with progress and buttons
  Widget _buildStreakBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔥 70',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Streak',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          //  switches to the 'Log Workout'
                          context
                              .findAncestorStateOfType<IndexState>()
                              ?.setState(() {
                            context
                                .findAncestorStateOfType<IndexState>()
                                ?.selectedPage = 1;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(154, 197, 244, 1),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Log Workout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       //  Implement Start Workout logic
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: Colors.grey.shade300,
                    //       padding: const EdgeInsets.symmetric(vertical: 12),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     child: const Text(
                    //       'Start Workout',
                    //       style: TextStyle(color: Colors.black),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          CircularPercentIndicator(
            radius: 70.0,
            lineWidth: 15.0,
            percent: 4 / 5,
            center: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ("${4 / 5 * 100}%"),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Daily Achievements",
                  style: TextStyle(fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            progressColor: const Color.fromRGBO(154, 197, 244, 1),
            backgroundColor: const Color.fromRGBO(154, 197, 244, 0.4),
            animation: true,
          ),
        ],
      ),
    );
  }
}

class FriendsPosts extends ConsumerWidget {
  final List<Map<String, dynamic>> workouts;

  const FriendsPosts({super.key, required this.workouts});

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

  void openProfileModal(BuildContext context, int userID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => ViewingProfilePage(userID: userID),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (workouts.isEmpty) const Text("You're friends haven't posted"),
        for (Map<String, dynamic> workout in workouts) ...[
          Container(
              padding: const EdgeInsets.only(
                  top: 12, right: 15, left: 12, bottom: 5),
              child: Flex(
                  direction: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    InkWell(
                        onTap: () {
                          openProfileModal(context, workout['user_ID']);
                        },
                        child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(
                                    'assets/${workout['user_profile_photo']}.png'),
                                fit: BoxFit.fill,
                              ),
                            ))),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 5,
                            children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 5,
                              children: [
                                InkWell(
                                  onTap: () {
                                    openProfileModal(
                                        context, workout['user_ID']);
                                  },
                                  child: Text(
                                    workout['user_name'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors.black, // Explicitly set color
                                    ),
                                  ),
                                ),
                                Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(workout['workout_date_time']),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700))
                              ]),
                          Text(workout['workout_caption'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w600
                              )),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(spacing: 5, children: [
                                  workout['hasLiked']
                                      ? InkWell(
                                          onTap: () {
                                            ref
                                                .read(postNotifier.notifier)
                                                .unlikeWorkoutPost(
                                                    workout['workout_ID']);
                                          },
                                          child: const Icon(
                                              Icons.favorite_rounded),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            ref
                                                .read(postNotifier.notifier)
                                                .likeWorkoutPost(
                                                    workout['workout_ID']);
                                          },
                                          child: const Icon(
                                              Icons.favorite_border_rounded)),
                                  Text(
                                    workout['total_likes'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                      onTap: () {
                                        openWorkoutModal(
                                            context, workout['workout_ID']);
                                      },
                                      child: const Icon(
                                          Icons.chat_bubble_outline_rounded)),
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
