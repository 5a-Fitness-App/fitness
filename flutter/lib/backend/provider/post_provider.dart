import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:fitness_app/backend/provider/workout_draft.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/backend/services/db_service.dart';

final friendsWorkoutsProvider = StateProvider<int>((ref) => 1);

final friendsWorkoutsNotifier =
    StateNotifierProvider<WorkoutsNotifier, FriendsWorkouts>((ref) {
  return WorkoutsNotifier(ref);
});

class Comment {
  int commentID;
  User commenter;
  String content;
  String date;

  Comment(
      {required this.commentID,
      required this.commenter,
      required this.content,
      required this.date});
}

class Workout {
  int? workoutID;
  String? workoutTitle;
  String? workoutUserName;
  // String? workoutDateTime;
  List<Comment>? comments;
  List<ActivityField>? activities;

  Workout(
      {required this.workoutID,
      required this.workoutUserName,
      required this.workoutTitle,
      this.comments,
      this.activities});

  Workout copyWith(
      {int? workoutID,
      String? workoutUserName,
      String? workoutTitle,
      List<Comment>? comments,
      List<ActivityField>? activities}) {
    return Workout(
        workoutID: workoutID ?? this.workoutID,
        workoutUserName: workoutUserName ?? this.workoutUserName,
        workoutTitle: workoutTitle ?? this.workoutTitle,
        comments: comments ?? this.comments,
        activities: activities ?? this.activities);
  }
}

class FriendsWorkouts {
  final List<Workout> workouts;

  FriendsWorkouts({required this.workouts});

  FriendsWorkouts copyWith({List<Workout>? workouts}) {
    return FriendsWorkouts(workouts: workouts ?? this.workouts);
  }
}

class WorkoutsNotifier extends StateNotifier<FriendsWorkouts> {
  final Ref ref;
  WorkoutsNotifier(this.ref) : super(FriendsWorkouts(workouts: []));

  Future<void> getFriendsWorkouts() async {
    final user = ref.watch(userNotifier);
    final userID = user.userID;

    try {
      List<List<dynamic>> workoutsResults = await dbService.readQuery('''SELECT 
            w.workout_ID,
            fu.user_name,
            w.workout_title
          FROM 
            friends f
          JOIN users fu ON f.friend_id = fu.user_ID
          JOIN workouts w ON fu.user_ID = w.user_ID
          WHERE 
            f.user_ID = @user_id
          ORDER BY 
            w.workout_date_time DESC;''', {'user_id': userID});

      // '''SELECT w.workout_ID, w.user_ID, u.user_name, w.workout_title, w.workout_date_time, w.workout_duration, w.workout_calories_burnt
      //           FROM workouts w
      //           JOIN friends f ON (w.user_ID = f.friend_ID OR w.user_ID = f.user_ID)
      //           JOIN users u ON w.user_ID = u.user_ID
      //           WHERE u.user_ID = @user_id
      //           ORDER BY w.workout_date_time DESC;'''

      List<Map<String, dynamic>> workouts = workoutsResults
          .map((row) => {
                'workout_ID': row[0],
                'user_name': row[1],
                'workout_title': row[2],
              })
          .toList();

      List<Workout> workoutList = [];

      for (Map<String, dynamic> workout in workouts) {
        workoutList.add(Workout(
            workoutID: workout['workout_ID'],
            workoutUserName: workout['user_name'],
            workoutTitle: workout['workout_title']));
      }

      state = state.copyWith(workouts: workoutList);
      // return null;
    } catch (e) {
      // Handle database errors or unexpected errors
      print('Error during post retrieval: $e');
      // return 'An unexpected error occurred.';
    }
  }
}
