import 'package:fitness_app/functional_backend/api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class MyWorkoutPage extends ConsumerStatefulWidget {
  final int workoutID;

  const MyWorkoutPage({super.key, required this.workoutID});

  @override
  MyWorkoutPageState createState() => MyWorkoutPageState();
}

class MyWorkoutPageState extends ConsumerState<MyWorkoutPage> {
  late Future<List<Map<String, dynamic>>> activities;
  late Future<Map<String, dynamic>> workoutDetails;

  @override
  void initState() {
    super.initState();
    activities = getWorkoutActivities(widget.workoutID);
    workoutDetails = getWorkoutDetails(widget.workoutID);
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
            child: Column(children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 5, left: 3, right: 5),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_horiz)),
                  ],
                ),
              ),
              FutureBuilder<Map<String, dynamic>>(
                  future: workoutDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No activities found.'));
                    } else {
                      return Column(children: [
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
                                      child: Flex(
                                          direction: Axis.vertical,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          spacing: 5,
                                          children: [
                                        Flex(
                                            direction: Axis.horizontal,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            spacing: 5,
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
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: activities,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No activities found.'));
                    } else {
                      List<Map<String, dynamic>> activities = snapshot.data!;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            for (Map<String, dynamic> activity in activities)
                              ActivityWidget(activity: activity)
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 30, top: 10),
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide.none,
                        left: BorderSide.none,
                        right: BorderSide.none,
                        top: BorderSide(
                            color: Color.fromARGB(255, 230, 230, 230)))),
                child: const Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text('something')],
                ),
              )
            ])));
  }
}

class ActivityWidget extends ConsumerWidget {
  final Map<String, dynamic> activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(children: [
      const SizedBox(height: 20),
      Container(
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
                Text(activity['notes']),
              ]))
    ]);
  }
}
