import 'package:fitness_app/functional_backend/services/db_service.dart';
import 'dart:convert';

// GET A LIST OF THE USER'S FRIENDS' WORKOUTS
Future<List<Map<String, dynamic>>> getFriendsWorkouts(int userID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''SELECT 
            w.workout_ID,
            fu.user_name,
            fu.user_profile_photo,
            w.workout_caption,
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

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'workout_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes),
              'workout_caption': row[3],
              'workout_date_time': row[4],
            })
        .toList();

    return queryRows;
  } catch (e) {
    // Handle database errors or unexpected errors
    return [
      {'error': 'Error during post retrieval: $e'}
    ];
    // return 'An unexpected error occurred.';
  }
}

//GET A LIST OF THE USER'S WORKOUTS
Future<List<Map<String, dynamic>>> getUserWorkout(int userID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''SELECT 
            w.workout_ID,
            u.user_name,
            u.user_profile_photo,
            w.workout_caption,
            w.workout_date_time,
            w.workout_public
          FROM 
            users u 
          JOIN workouts w ON u.user_ID = w.user_ID
          WHERE 
            u.user_ID = @user_ID
          ORDER BY 
            w.workout_date_time DESC;''', {'user_ID': userID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'workout_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes),
              'workout_caption': row[3],
              'workout_date_time': row[4],
              'workout_public': row[5]
            })
        .toList();

    print(queryRows);
    return queryRows;
  } catch (e) {
    // Handle database errors or unexpected errors
    return [
      {'error': 'Error during post retrieval: $e'}
    ];
    // return 'An unexpected error occurred.';
  }
}

// GET THE DETAILS OF A SELECTED WORKOUT
Future<Map<String, dynamic>> getWorkoutDetails(int workoutID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''
      SELECT
        w.workout_ID,
        u.user_name,
        u.user_profile_photo,
        w.workout_caption,
        w.workout_date_time
        FROM
          workouts w
          JOIN users u ON w.user_ID = u.user_ID
        WHERE 
          w.workout_ID = @workout_ID;
      ''', {'workout_ID': workoutID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'workout_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes),
              'workout_caption': row[3],
              'workout_date_time': row[4],
            })
        .toList();

    return queryRows[0];
  } catch (e) {
    print('error: $e');
    return {};
    //TODO: change this error handling
  }
}

// GET THE ACTIVITIES FOR A SELECTED WORKOUT
Future<List<Map<String, dynamic>>> getWorkoutActivities(int workoutID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''
          SELECT
            e.exercise_name,
            e.exercise_target,
            a.activity_notes,
            a.activity_metrics
          FROM
            workouts w
            JOIN activities a ON w.workout_ID = a.workout_ID
            JOIN exercises e ON a.exercise_ID = e.exercise_ID
          WHERE 
            a.workout_ID = @workout_ID;
        ''', {'workout_ID': workoutID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'exercise_name': utf8.decode(row[0].bytes),
              'exercise_target': utf8.decode(row[1].bytes),
              'notes': row[2],
              'metrics': row[3],
            })
        .toList();

    return queryRows;
  } catch (e) {
    print('error: $e');
    return [];
    //TODO: change this error handling
  }
}

// GET THE USER'S FRIEND COUNT
Future<int> getFriendCount(int userID) async {
  List<List<dynamic>> query = await dbService.readQuery('''
        SELECT
          COUNT(f.friend_ID) AS friend_count
        FROM 
          users u 
          JOIN friends f ON u.user_ID = f.user_ID
        WHERE
          u.user_ID = @user_ID;
      ''', {'user_ID': userID});

  List<Map<String, dynamic>> friendCount =
      query.map((row) => {'friend_count': row[0]}).toList();

  return friendCount[0]['friend_count'];
}

// REGISTER A NEW USER
Future<String?> register(String username, String profilePhoto, DateTime dob,
    double weight, String weightUnits, String email, String password) async {
  try {
    await dbService.insertQuery(
        '''INSERT INTO users (user_name, user_profile_photo, user_dob, user_weight, user_weight_unit, users_account_creation_date, user_email, user_password) VALUES
        (@user_name, @user_profile_photo, @dob, @weight, @weight_units, CURRENT_DATE, @email, @password);''',
        {
          'user_name': username,
          'user_profile_photo': profilePhoto,
          'dob': dob,
          'weight': weight,
          'weight_units': weightUnits,
          'email': email,
          'password': password
        });

    return null;
  } catch (e) {
    print(e);
    return 'There was an error registering your account';
  }
}
