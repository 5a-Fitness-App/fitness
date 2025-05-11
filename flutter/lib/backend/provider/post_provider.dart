import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fitness_app/backend/models/post.dart';

import 'package:fitness_app/backend/models/user.dart';
import 'package:fitness_app/backend/provider/user_provider.dart';
import 'package:fitness_app/backend/api.dart';

// Provider for tracking post IDs (initialized to 1)
final postProvider = StateProvider<int>((ref) => 1);

// StateNotifierProvider for managing post state
final postNotifier = StateNotifierProvider<PostNotifier, Posts>((ref) {
  return PostNotifier(ref);
});

// StateNotifier class for handling post operations
class PostNotifier extends StateNotifier<Posts> {
  final Ref ref; // Reference to provider container

  // Initialize with empty user and friends workout lists
  PostNotifier(this.ref) : super(Posts(userWorkouts: [], friendsWorkouts: []));

  // Loads the current user's workouts from the backend
  Future<void> loadUserWorkouts() async {
    // Get current user info
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    // Ensure there is a user logged in
    if (userID != null) {
      // Fetch user's workouts from API
      List<Map<String, dynamic>> userWorkouts = await getUserWorkouts(userID);

      // List to store workouts with like status
      List<Map<String, dynamic>> workouts = [];

      // Check whether the user has liked each workout
      for (Map<String, dynamic> workout in userWorkouts) {
        workout['hasLiked'] =
            await hasUserLikedWorkout(userID, workout['workout_ID']);
        workouts.add(workout);
      }

      // Update state with new workout data
      state = state.copyWith(userWorkouts: workouts);
    }
  }

  // Loads friends' workouts from the backend
  Future<void> loadFriendsWorkouts() async {
    // Get current user info
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    // Ensure there is a user logged in
    if (userID != null) {
      // Fetch friends' workouts from API
      List<Map<String, dynamic>> friendsWorkouts =
          await getFriendsWorkouts(userID);

      // List to store workouts with like status
      List<Map<String, dynamic>> workouts = [];

      // Check whether the user has liked each workout
      for (Map<String, dynamic> workout in friendsWorkouts) {
        workout['hasLiked'] =
            await hasUserLikedWorkout(userID, workout['workout_ID']);
        workouts.add(workout);
      }

      // Update state with new workout data
      state = state.copyWith(friendsWorkouts: workouts);
    }
  }

  // Handles liking a workout post
  Future<void> likeWorkoutPost(int workoutID) async {
    // Get current user info
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      // Send like to API
      likeWorkout(userID, workoutID);

      // Refresh both workout lists to update UI
      loadFriendsWorkouts();
      loadUserWorkouts();
    }
  }

  // Handles unliking a workout post
  Future<void> unlikeWorkoutPost(int workoutID) async {
    // Get current user info
    User user = ref.watch(userNotifier);
    int? userID = user.userID;

    if (userID != null) {
      // Send unlike to API
      unlikeWorkout(userID, workoutID);

      // Refresh both workout lists to update UI
      loadFriendsWorkouts();
      loadUserWorkouts();
    }
  }
}
