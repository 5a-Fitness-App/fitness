import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_app/backend/models/post.dart';

import 'package:fitness_app/backend/models/user.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:fitness_app/backend/api.dart';

final postProvider = StateProvider<int>((ref) => 1);

final postNotifier = StateNotifierProvider<PostNotifier, Posts>((ref) {
  return PostNotifier(ref);
});

class PostNotifier extends StateNotifier<Posts> {
  final Ref ref;

  PostNotifier(this.ref) : super(Posts(userWorkouts: [], friendsWorkouts: []));

  Future<void> loadUserWorkouts() async {
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      List<Map<String, dynamic>> userWorkouts = await getUserWorkouts(userID);

      List<Map<String, dynamic>> workouts = [];
      for (Map<String, dynamic> workout in userWorkouts) {
        workout['hasLiked'] =
            await hasUserLikedWorkout(userID, workout['workout_ID']);
        workouts.add(workout);
      }

      state = state.copyWith(userWorkouts: workouts);
    }
  }

  Future<void> loadFriendsWorkouts() async {
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      List<Map<String, dynamic>> friendsWorkouts =
          await getFriendsWorkouts(userID);

      List<Map<String, dynamic>> workouts = [];

      for (Map<String, dynamic> workout in friendsWorkouts) {
        workout['hasLiked'] =
            await hasUserLikedWorkout(userID, workout['workout_ID']);
        workouts.add(workout);
      }

      state = state.copyWith(friendsWorkouts: workouts);
    }
  }

  Future<void> likeWorkoutPost(int workoutID) async {
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      likeWorkout(userID, workoutID);
      loadFriendsWorkouts();
      loadUserWorkouts();
    }
  }

  Future<void> unlikeWorkoutPost(int workoutID) async {
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      unlikeWorkout(userID, workoutID);
      loadFriendsWorkouts();
      loadUserWorkouts();
    }
  }
}
