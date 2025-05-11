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

// Widget to display the user's profile page
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

// State for the ProfilePage widget
class ProfilePageState extends ConsumerState<ProfilePage> {
  // Controls whether to display the dashboard or the user's posts
  bool dashBoardMode = true;

  // Opens a modal bottom sheet to display the friends of the logged in user
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
    // Watch the user provider to get the current user's data
    User user = ref.watch(userNotifier);

    // Watch the post provider to get the user's posts data
    Posts posts = ref.watch(postNotifier);

    return SingleChildScrollView(
        child: Column(children: [
      // Container for the user's profile information
      Container(
        padding: const EdgeInsets.all(20),
        child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 15,
            children: [
              // Row containing the profile picture and user details
              Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // User's profile photo
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                'assets/${user.userProfilePhoto}.png'),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Display the username and the user's friend count
                    Expanded(
                        child: Column(
                            spacing: 3,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          // Username
                          Text(
                            user.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // Friend count
                          InkWell(
                              onTap: () {
                                openFriendModal(context, user.userID ?? 0);
                              },
                              child: Text('${user.friendCount} friends'))
                        ]))
                  ]),

              // User Biography
              Text(
                user.userBio ?? '',
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ]),
      ),

      // Toggle buttons to swtich between viewing the user's dashboard and viewing the user's posts
      Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        ElevatedButton(
          // Button to navigate to the dashboard
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

        // Button to navigate to the user's posts
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

      // Conditional rendering of either MyPosts or Dashboard based on the state.
      SingleChildScrollView(
        child: dashBoardMode
            ? MyPosts(workouts: posts.userWorkouts)
            : const Dashboard(),
      )
    ]));
  }
}

// placeholder widget for the user's dashboard
class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      // TODO: implement acheivements
      // Acheivements are unimplemented, but would be displayed here in the dashbaord
      children: [Text('Dashboard')],
    );
  }
}

// Widget to display the user's workout posts
class MyPosts extends ConsumerWidget {
  // The list of workout data to display
  final List<Map<String, dynamic>> workouts;

  const MyPosts({super.key, required this.workouts});

  // Open a modal bottom sheet to display the details of a specific workout
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
        // If the user has never posted a workout and there is no data
        if (workouts.isEmpty) const Text("You haven't posted"),

        // Iterate through the lists of workouts and display each one
        for (Map<String, dynamic> workout in workouts) ...[
          Container(
              padding: const EdgeInsets.only(
                  top: 12, right: 15, left: 12, bottom: 5),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    // Profile Image
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

                    // Display username and the date the workout was posted
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

                                // Date posted
                                Text(
                                    DateFormat('dd MMMM yyyy')
                                        .format(workout['workout_date_time']),
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700)),
                                const Spacer(),

                                // Whether others can see the workout (public) or not (private)
                                Text(
                                    workout['workout_public']
                                        ? 'Public'
                                        : 'Private',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey.shade700))
                              ]),

                          // Workout caption
                          Text(workout['workout_caption'] ?? '',
                              style: const TextStyle(
                                fontSize: 18,
                                //fontWeight: FontWeight.w600
                              )),

                          // Likes, Comments and button to open workout modal
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Likes and comments on the left side
                                Row(spacing: 5, children: [
                                  // Conditional rendering of liked/unliked icon.
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

                                  // Display like count
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

                                // Button on the right
                                // Button to open workout modal
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
