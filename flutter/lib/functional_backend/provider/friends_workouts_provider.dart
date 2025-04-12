import 'package:fitness_app/functional_backend/provider/user_provider.dart';
import 'package:fitness_app/functional_backend/models/workout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/services/db_service.dart';

final friendsWorkoutsProvider = StateProvider<int>((ref) => 1);

final friendsWorkoutsNotifier =
    StateNotifierProvider<WorkoutsNotifier, FriendsWorkouts>((ref) {
  return WorkoutsNotifier(ref);
});

// TODO: merge to user model
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
            w.workout_title,
            w.workout_date_time
          FROM 
            friends f
          JOIN users fu ON f.friend_ID = fu.user_ID
          JOIN workouts w ON f.friend_ID = w.user_ID
          WHERE 
            f.user_ID = @user_id AND
            w.workout_public = true
          ORDER BY 
            w.workout_date_time DESC;''', {'user_id': userID});

      print(workoutsResults);

      List<Map<String, dynamic>> workouts = workoutsResults
          .map((row) => {
                'workout_ID': row[0],
                'user_name': row[1],
                'workout_title': row[2],
                'workout_date_time': row[3]
              })
          .toList();

      List<Workout> workoutList = [];

      for (Map<String, dynamic> workout in workouts) {
        workoutList.add(Workout(
            workoutID: workout['workout_ID'],
            workoutUserName: workout['user_name'],
            workoutTitle: workout['workout_title'],
            workoutDateTime: workout['workout_date_time']));
      }

      print(workoutList);

      state = state.copyWith(workouts: workoutList);
      // return null;
    } catch (e) {
      // Handle database errors or unexpected errors
      print('Error during post retrieval: $e');
      // return 'An unexpected error occurred.';
    }
  }
}
