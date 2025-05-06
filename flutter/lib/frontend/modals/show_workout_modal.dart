import 'package:fitness_app/backend/api.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:fitness_app/backend/provider/post_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fitness_app/backend/models/user.dart';
import 'package:fitness_app/frontend/modals/show_profile_modal.dart';

enum MenuAction {
  togglePublic, // Represents "Edit" action
  delete, // Represents "Delete" action
}

class MyWorkoutPage extends ConsumerStatefulWidget {
  final int workoutID;

  const MyWorkoutPage({super.key, required this.workoutID});

  @override
  MyWorkoutPageState createState() => MyWorkoutPageState();
}

class MyWorkoutPageState extends ConsumerState<MyWorkoutPage> {
  late Future<List<Map<String, dynamic>>> activities;
  late Future<Map<String, dynamic>> workoutDetails;
  late Future<List<Map<String, dynamic>>> comments;
  final commentKey = GlobalKey<FormState>();
  TextEditingController commentController = TextEditingController();
  bool isCommenting = false;
  String? selectedOption; // Initially null (no selection)
  final List<String> dropdownOptions = ["Option 1", "Option 2"];

  @override
  void initState() {
    super.initState();
    activities = getWorkoutActivities(widget.workoutID);
    workoutDetails = getWorkoutDetails(widget.workoutID);
    comments = getWorkoutComments(widget.workoutID);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  void updateComments() {
    setState(() {
      comments = getWorkoutComments(widget.workoutID);
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = ref.watch(userNotifier);

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.only(top: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              FutureBuilder<Map<String, dynamic>>(
                  future: workoutDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 5, left: 3, right: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ]),
                      );
                      // const Center(child: Text('No activities found.'));
                    } else {
                      return Column(children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, bottom: 5, left: 3, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                              ),
                              if (snapshot.data!['user_ID'] == user.userID)
                                PopupMenuButton<MenuAction>(
                                  icon: const Icon(Icons.more_vert), // "⋮" icon
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: MenuAction.togglePublic,
                                      child: Text("Change publicity status"),
                                    ),
                                    const PopupMenuItem(
                                      value: MenuAction.delete,
                                      child: Text("Delete"),
                                    ),
                                  ],
                                  onSelected: (value) async {
                                    if (value == MenuAction.togglePublic) {
                                      await toggleWorkoutPublic(
                                          snapshot.data!['workout_ID']);
                                      ref
                                          .read(postNotifier.notifier)
                                          .loadUserWorkouts();
                                      ref
                                          .read(postNotifier.notifier)
                                          .loadUserWorkouts();
                                    } else if (value == MenuAction.delete) {
                                      await deleteWorkout(
                                          snapshot.data!['workout_ID']);
                                      ref
                                          .read(postNotifier.notifier)
                                          .loadUserWorkouts();
                                      ref
                                          .read(postNotifier.notifier)
                                          .loadFriendsWorkouts();

                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              // IconButton(
                              //     onPressed: () {
                              //       deleteWorkout(
                              //           snapshot.data!['workout_ID']);
                              //       ref
                              //           .read(postNotifier.notifier)
                              //           .loadUserWorkouts();
                              //       ref
                              //           .read(postNotifier.notifier)
                              //           .loadFriendsWorkouts();

                              //       Navigator.pop(context);
                              //     },
                              //     icon: const Icon(Icons.more_horiz)),
                            ],
                          ),
                        ),
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
                                        color: Colors.blue,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${snapshot.data!['user_profile_photo']}.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 5,
                                          children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            spacing: 7,
                                            children: [
                                              Flex(
                                                  direction: Axis.vertical,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data!['user_name'],
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                        snapshot.data![
                                                            'workout_caption'],
                                                        style: const TextStyle(
                                                            fontSize: 16))
                                                  ])
                                            ])
                                      ]))
                                ]))
                      ]);
                    }
                  }),
              const Divider(),
              Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: activities,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No activities found.'));
                        } else {
                          List<Map<String, dynamic>> activities =
                              snapshot.data!;
                          return Column(
                            spacing: 20,
                            children: [
                              const SizedBox(),
                              for (Map<String, dynamic> activity in activities)
                                ActivityWidget(activity: activity),
                              const SizedBox()
                            ],
                          );
                        }
                      },
                    ),
                    const Divider(),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.all(10),
                      child: const Text('Comments',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20)),
                    ),
                    Form(
                        key: commentKey,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                                spacing: 15,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 35,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.blue,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/${user.userProfilePhoto}.png'),
                                          fit: BoxFit.fill,
                                        ),
                                      )),
                                  Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                        TextFormField(
                                          controller: commentController,
                                          minLines: 1,
                                          maxLines: 3,
                                          onChanged: (value) {
                                            setState(() {
                                              isCommenting =
                                                  value.trim().isNotEmpty;
                                            });
                                          },
                                          decoration: const InputDecoration(
                                              hintText: 'Add a comment...',
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black,
                                                          width: 2))),
                                        ),
                                        if (isCommenting) ...[
                                          const SizedBox(height: 5),
                                          ElevatedButton(
                                              onPressed: () async {
                                                if (commentKey.currentState!
                                                    .validate()) {
                                                  try {
                                                    // Submit the comment
                                                    await addComment(
                                                      widget.workoutID,
                                                      user.userID ?? 0,
                                                      commentController.text
                                                          .trim(),
                                                    );

                                                    // Clear the form
                                                    commentController.clear();
                                                    setState(() =>
                                                        isCommenting = false);

                                                    // Refresh comments list
                                                    setState(() {
                                                      comments =
                                                          getWorkoutComments(
                                                              widget.workoutID);
                                                    });

                                                    // Optional: Show success message
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Comment added!')),
                                                    );
                                                  } catch (e) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Failed to add comment: $e')),
                                                    );
                                                  }
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.black,
                                                foregroundColor: Colors.white,
                                              ),
                                              child: const Text(
                                                'Comment',
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ))
                                        ]
                                      ]))
                                ]))),
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: comments,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No comments found.'));
                        } else {
                          List<Map<String, dynamic>> comments = snapshot.data!;
                          return Column(
                            children: [
                              for (Map<String, dynamic> comment in comments)
                                CommentWidget(
                                    comment: comment,
                                    user: user,
                                    onDeleteComment: updateComments),
                              const SizedBox(height: 50)
                            ],
                          );
                        }
                      },
                    ),
                  ]))),
            ])));
  }
}

class ActivityWidget extends StatelessWidget {
  final Map<String, dynamic> activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width - 20,
        padding:
            const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 15),
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 230, 230, 230)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Flex(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(activity['exercise_name'],
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(activity['exercise_target']),
              if (activity['metrics'].containsKey('sets'))
                Text('sets: ${activity['metrics']['sets']}'),
              if (activity['metrics'].containsKey('reps'))
                Text('reps: ${activity['metrics']['reps']}'),
              if (activity['metrics'].containsKey('weight'))
                Text(
                    'weight: ${activity['metrics']['weight']}${activity['metrics']['unit']}'),
              if (activity['metrics'].containsKey('distance'))
                Text(
                    'distance: ${activity['metrics']['distance']}${activity['metrics']['unit']}'),
              if (activity['metrics'].containsKey('incline'))
                Text('incline: ${activity['metrics']['incline']}'),
              if (activity['metrics'].containsKey('time'))
                Text('time: ${activity['metrics']['time']}'),
              Text(activity['notes'] ?? ''),
            ]));
  }
}

class CommentWidget extends StatelessWidget {
  final Map<String, dynamic> comment;
  final User user;

  final VoidCallback onDeleteComment;

  const CommentWidget(
      {super.key,
      required this.comment,
      required this.user,
      required this.onDeleteComment});

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
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.only(top: 12, right: 15, left: 12, bottom: 5),
        child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              InkWell(
                  onTap: () {
                    openProfileModal(context, comment['user_ID']);
                  },
                  child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/${comment['user_profile_photo']}.png'),
                          fit: BoxFit.fill,
                        ),
                      ))),
              Expanded(
                  child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 5,
                      children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 5,
                        children: [
                          InkWell(
                            onTap: () {
                              try {
                                openProfileModal(context, comment['user_ID']);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Text(
                              comment['user_name'] ?? '',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Explicitly set color
                              ),
                            ),
                          ),
                          Text(comment['content'],
                              style: const TextStyle(fontSize: 16)),
                          Text(DateFormat('dd MMMM yyyy')
                              .format(comment['date'])),
                        ]),
                  ]))
            ]),
      ),
      if (comment['user_ID'] == user.userID)
        Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  deleteComment(comment['comment_ID']);
                  onDeleteComment();
                },
                icon: const Icon(
                  Icons.delete_outline_outlined,
                  color: Colors.black,
                )))
    ]);
  }
}
