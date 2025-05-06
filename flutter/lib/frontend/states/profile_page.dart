import 'package:fitness_app/frontend/modals/show_friend_modal.dart';
import 'package:fitness_app/backend/api.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/models/user.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/frontend/modals/show_workout_modal.dart';
import 'package:fitness_app/backend/models/post.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends ConsumerState<ProfilePage> {
  bool dashBoardMode = true;

  void openFriendModal(BuildContext context, int userID) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) => FriendsPage(userID: userID),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userNotifier);
    Posts posts = ref.watch(postNotifier);

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
                      InkWell(
                          onTap: () {
                            openFriendModal(context, user.userID ?? 0);
                          },
                          child: Text(
                              '${user.friendCount} friends')) // Show the result when data is available
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
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        ElevatedButton(
          onPressed: dashBoardMode
              ? () {
                  setState(() {
                    dashBoardMode = false;
                  });
                }
              : null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.transparent,
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
          onPressed: dashBoardMode
              ? null
              : () {
                  setState(() {
                    dashBoardMode = true;
                  });
                },
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: Colors.transparent,
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
        child: dashBoardMode
            ? MyPosts(workouts: posts.userWorkouts)
            : const Dashboard(),
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

class MyPosts extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (workouts.isEmpty) const Text("You haven't posted"),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 5,
                              children: [
                                Text(
                                  workout['user_name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black, // Explicitly set color
                                  ),
                                ),
                                Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(workout['workout_date_time']),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700)),
                                const Spacer(),
                                Text(
                                    workout['workout_public']
                                        ? 'Public'
                                        : 'Private',
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
