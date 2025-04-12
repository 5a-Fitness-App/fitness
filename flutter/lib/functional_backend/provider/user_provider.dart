import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitness_app/functional_backend/services/db_service.dart';
import 'package:fitness_app/functional_backend/models/workout.dart';
import 'package:fitness_app/functional_backend/models/user.dart';
import 'dart:convert';

final userProvider = StateProvider<int>((ref) => 1);

final userNotifier = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
      : super(
            User(accountCreationDate: DateTime.now(), userDOB: DateTime.now()));

  Future<String?> login(String email, String password) async {
    try {
      List<List<dynamic>> passwordResults = await dbService.readQuery(
        'SELECT user_password FROM users WHERE user_email = @email',
        {'email': email},
      );

      if (passwordResults.isEmpty) {
        // If no user found, return error message
        return 'Email or password is incorrect';
      } else {
        String userPassword = passwordResults[0][0];

        if (password == userPassword) {
          // If passwords match, return null (successful login)
          List<List<dynamic>> results = await dbService.readQuery(
            '''SELECT 
              user_ID,
              user_name,
              user_profile_photo,
              user_bio,
              user_dob,
              user_weight,
              user_units,
              users_account_creation_date,
              user_email
              FROM users 
              WHERE user_email = @email''',
            {'email': email},
          );

          List<Map<String, dynamic>> user = results
              .map((row) => {
                    'user_ID': row[0],
                    'user_name': row[1],
                    'user_profile_photo': row[2],
                    'user_bio': row[3],
                    'user_dob': row[4],
                    'user_weight': row[5],
                    'user_units': row[6],
                    'users_account_creation_date': row[7],
                    'user_email': row[8]
                  })
              .toList();

          print(utf8.decode(user[0]['user_profile_photo'].bytes));

          state = state.copyWith(
              userID: user[0]['user_ID'],
              userName: user[0]['user_name'],
              userProfilePhoto:
                  utf8.decode(user[0]['user_profile_photo'].bytes),
              userBio: user[0]['user_bio'],
              userDOB: user[0]['user_dob'],
              userWeight: user[0]['user_weight'],
              userUnits: utf8.decode(user[0]['user_units'].bytes),
              accountCreationDate: user[0]['users_account_creation_date'],
              userEmail: user[0]['user_email']);
          getUserWorkout();
          getFriendsWorkouts();
          getFriendCount();
          return null;
        } else {
          // If passwords don't match, return an error message
          return 'Email or password is incorrect';
        }
      }
    } catch (e) {
      // Handle database errors or unexpected errors
      print('Error during login: $e');
      return 'An unexpected error occurred.';
    }
  }

  Future<void> getUserWorkout() async {
    final userID = state.userID;

    try {
      List<List<dynamic>> workoutsResults = await dbService.readQuery('''SELECT 
            w.workout_ID,
            u.user_name,
            w.workout_title,
            w.workout_date_time,
            w.workout_public,
            ARRAY(
              SELECT a.activity_ID 
              FROM activities a
              WHERE a.workout_ID = w.workout_ID
            ) AS workout_activities
          FROM 
            users u 
          JOIN workouts w ON u.user_ID = w.user_ID
          WHERE 
            u.user_ID = @user_ID
          ORDER BY 
            w.workout_date_time DESC;''', {'user_ID': userID});

      List<Map<String, dynamic>> workouts = workoutsResults
          .map((row) => {
                'workout_ID': row[0],
                'user_name': row[1],
                'workout_title': row[2],
                'workout_date_time': row[3],
                'workout_public': row[4],
                'workout_activities': row[5]
              })
          .toList();

      List<Workout> workoutList = [];

      for (Map<String, dynamic> workout in workouts) {
        workoutList.add(Workout(
            workoutID: workout['workout_ID'],
            workoutUserName: workout['user_name'],
            workoutTitle: workout['workout_title'],
            workoutDateTime: workout['workout_date_time'],
            workoutPublic: workout['workout_public'],
            activities: workout['workout_activities']));
      }

      print(workoutList);

      state = state.copyWith(userWorkouts: workoutList);
      // return null;
    } catch (e) {
      // Handle database errors or unexpected errors
      print('Error during post retrieval: $e');
      // return 'An unexpected error occurred.';
    }
  }

  Future<void> getFriendsWorkouts() async {
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
            w.workout_date_time DESC;''', {'user_id': state.userID});

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

      state = state.copyWith(friendsWorkouts: workoutList);
      // return null;
    } catch (e) {
      // Handle database errors or unexpected errors
      print('Error during post retrieval: $e');
      // return 'An unexpected error occurred.';
    }
  }

  Future<void> getFriendCount() async {
    List<List<dynamic>> query = await dbService.readQuery('''
        SELECT
          COUNT(f.friend_ID) AS friend_count
        FROM 
          users u 
          JOIN friends f ON u.user_ID = f.user_ID
        WHERE
          u.user_ID = @user_ID;
      ''', {'user_ID': state.userID});

    List<Map<String, dynamic>> friendCount =
        query.map((row) => {'friend_count': row[0]}).toList();

    state = state.copyWith(friendCount: friendCount[0]['friend_count']);
  }

  void logOut() {
    state = state.copyWith(
        userID: null, userName: null, userEmail: '', userWorkouts: []);
  }

  void register(String email, String username, String password) {
    // TODO: move this function to somewhere more appropriate
    // TODO: build register() function
  }
}
