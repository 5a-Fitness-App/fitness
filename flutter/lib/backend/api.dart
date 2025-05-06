import 'package:fitness_app/backend/services/db_service.dart';
import 'dart:convert';

// GET A LIST OF THE USER'S FRIENDS' WORKOUTS
Future<List<Map<String, dynamic>>> getFriendsWorkouts(int userID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''SELECT 
            w.workout_ID,
            fu.user_ID,
            fu.user_name,
            fu.user_profile_photo,
            w.workout_caption,
            w.workout_date_time,
            COUNT(DISTINCT c.comment_ID) AS total_comments, 
            COUNT(DISTINCT l.user_ID) AS total_likes 
          FROM 
            friends f
          JOIN users fu ON f.friend_ID = fu.user_ID
          JOIN workouts w ON f.friend_ID = w.user_ID
          JOIN likes l ON w.workout_ID = l.workout_ID
          JOIN comments c ON w.workout_ID = c.workout_ID
          WHERE 
            f.user_ID = @user_ID AND
            w.workout_public = true
          GROUP BY
            fu.user_ID,
            w.workout_ID
          ORDER BY 
            w.workout_date_time DESC;''', {'user_ID': userID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'workout_ID': row[0],
              'user_ID': row[1],
              'user_name': row[2],
              'user_profile_photo': utf8.decode(row[3].bytes),
              'workout_caption': row[4],
              'workout_date_time': row[5],
              'total_comments': row[6],
              'total_likes': row[7]
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
Future<List<Map<String, dynamic>>> getUserWorkouts(int userID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''SELECT 
            w.workout_ID,
            u.user_name,
            u.user_profile_photo,
            w.workout_caption,
            w.workout_date_time,
            w.workout_public,
            COUNT(DISTINCT c.comment_ID) AS total_comments, 
            COUNT(DISTINCT l.user_ID) AS total_likes 
          FROM 
            users u 
          JOIN workouts w ON u.user_ID = w.user_ID
            LEFT JOIN likes l ON w.workout_ID = l.workout_ID
          LEFT JOIN comments c ON w.workout_ID = c.workout_ID
          WHERE 
            u.user_ID = @user_ID
          GROUP BY
            u.user_ID,
            w.workout_ID
          ORDER BY 
            w.workout_date_time DESC;''', {'user_ID': userID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'workout_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes),
              'workout_caption': row[3],
              'workout_date_time': row[4],
              'workout_public': row[5],
              'total_comments': row[6],
              'total_likes': row[7]
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

// GET THE DETAILS OF A SELECTED WORKOUT
Future<Map<String, dynamic>> getWorkoutDetails(int workoutID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''
      SELECT
        w.workout_ID,
        u.user_ID,
        u.user_name,
        u.user_profile_photo,
        w.workout_caption,
        w.workout_date_time,
        w.workout_public,
        COUNT(DISTINCT c.comment_ID) AS total_comments, 
        COUNT(DISTINCT l.user_ID) AS total_likes 
        FROM
          workouts w
           JOIN users u ON w.user_ID = u.user_ID
          LEFT JOIN likes l ON w.workout_ID = l.workout_ID
          LEFT JOIN comments c ON w.workout_ID = c.workout_ID
        WHERE 
          w.workout_ID = @workout_ID
        GROUP BY
          u.user_ID,
          w.workout_ID;
      ''', {'workout_ID': workoutID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'workout_ID': row[0],
              'user_ID': row[1],
              'user_name': row[2],
              'user_profile_photo': utf8.decode(row[3].bytes),
              'workout_caption': row[4],
              'workout_date_time': row[5],
              'workout_public': row[6],
              'total_comments': row[7],
              'total_likes': row[8]
            })
        .toList();

    return queryRows[0];
  } catch (e) {
    print('error: $e');
    return {};
    //TODO: change this error handling
  }
}

Future<bool> hasUserLikedWorkout(int userID, int workoutID) async {
  try {
    final like = await dbService.readQuery('''
      SELECT user_ID
        FROM likes WHERE workout_id = @workout_ID AND user_id = @user_ID LIMIT 1;
        ''', {'user_ID': userID, 'workout_ID': workoutID});

    return like.isNotEmpty;
  } catch (e) {
    print('error');
    return false;
  }
}

Future<void> unlikeWorkout(int userID, int workoutID) async {
  try {
    await dbService.deleteQuery('''
        DELETE FROM likes WHERE workout_id = @workout_ID AND user_id = @user_ID;''',
        {'user_ID': userID, 'workout_ID': workoutID});
  } catch (e) {
    print('error: $e');
  }
}

Future<void> likeWorkout(int userID, int workoutID) async {
  try {
    await dbService.deleteQuery('''
        INSERT INTO likes (user_ID, workout_ID, date_liked) VALUES
        (@user_ID, @workout_ID, CURRENT_DATE);
      ''', {'user_ID': userID, 'workout_ID': workoutID});
  } catch (e) {
    print('error: $e');
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

// GET THE COMMENTS OF A SELECTED WORKOUT
Future<List<Map<String, dynamic>>> getWorkoutComments(int workoutID) async {
  try {
    List<List<dynamic>> query = await dbService.readQuery('''
        SELECT
          u.user_ID,
          u.user_name,
          u.user_profile_photo,
          c.comment_ID,
          c.content,
          c.date_commented
        FROM 
          comments c
          JOIN users u ON c.user_ID = u.user_ID
        WHERE  
          c.workout_ID = @workout_ID
      ''', {'workout_ID': workoutID});

    List<Map<String, dynamic>> queryRows = query
        .map((row) => {
              'user_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes),
              'comment_ID': row[3],
              'content': row[4],
              'date': row[5]
            })
        .toList();

    return queryRows;
  } catch (e) {
    return [
      {'error': e}
    ];
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

// CREATE A NEW WORKOUT
Future<String?> addWorkout(int userID, String workoutCaption,
    bool workoutPublic, List<Map<String, dynamic>> activities) async {
  try {
    int workoutID = await dbService.insertAndReturnId('''
        INSERT INTO workouts (user_ID, workout_caption, workout_date_time, workout_public)
        VALUES
        (@user_ID, @workout_caption, CURRENT_DATE, @workout_public)
        RETURNING workout_ID;
      ''', {
      'user_ID': userID,
      'workout_caption': workoutCaption,
      'workout_public': workoutPublic,
    });

    for (Map<String, dynamic> activity in activities) {
      List<List<dynamic>> query = await dbService.readQuery('''
          SELECT exercise_ID FROM exercises WHERE exercise_name = @exercise_name
        ''', {'exercise_name': activity['exercise_name']});

      if (query.isEmpty) {
        return 'Exercise not found: ${activity['exercise_name']}';
      }
      int exerciseID = query[0][0];

      await dbService.insertQuery('''
          INSERT INTO activities (workout_ID, exercise_ID, activity_notes, activity_metrics)
          VALUES
          (@workout_ID, @exercise_ID, @notes, @metrics);
        ''', {
        'workout_ID': workoutID,
        'exercise_ID': exerciseID,
        'notes': activity['notes'],
        'metrics': jsonEncode(activity['metrics'])
      });
    }

    return null;
  } catch (e) {
    print(e);
    return 'error: $e';
  }
}

// DELETE A WORKOUT
Future<String?> deleteWorkout(int workoutID) async {
  try {
    await dbService.deleteQuery('''
        DELETE FROM workouts WHERE workout_ID = @workout_ID
      ''', {'workout_ID': workoutID});

    return null;
  } catch (e) {
    print(e);
    return 'error: $e';
  }
}

Future<Map<String, dynamic>> getProfileDetails(int userID) async {
  try {
    List<List<dynamic>> results = await dbService.readQuery(
      '''SELECT 
              user_ID,
              user_name,
              user_profile_photo,
              user_bio,
              user_weight,
              user_weight_unit
              FROM users 
              WHERE user_ID = @user_ID;''',
      {'user_ID': userID},
    );

    List<Map<String, dynamic>> user = results
        .map((row) => {
              'user_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes),
              'user_bio': row[3],
              'user_weight': double.parse(row[4]),
              'user_unit': row[5],
            })
        .toList();

    // print(user[0]);
    return user[0];
  } catch (e) {
    print(e);
    return {};
  }
}

Future<String?> addComment(int workoutID, int userID, String content) async {
  try {
    await dbService.insertQuery('''
        INSERT INTO comments (user_ID, workout_ID, content, date_commented) 
        VALUES
        (@user_ID, @workout_ID, @content, CURRENT_DATE )
      ''', {
      'user_ID': userID,
      'workout_ID': workoutID,
      'content': content,
    });

    return null;
  } catch (e) {
    print('comment error $e');
    return 'error: $e';
  }
}

Future<String?> deleteComment(int commentID) async {
  try {
    await dbService.deleteQuery('''
        DELETE FROM comments WHERE comment_ID = @comment_ID
      ''', {'comment_ID': commentID});

    return null;
  } catch (e) {
    return 'error: $e';
  }
}

Future<List<Map<String, dynamic>>> getFriends(int userID) async {
  try {
    List<List<dynamic>> results = await dbService.readQuery('''
        SELECT
          fu.user_ID,
          fu.user_name,
          fu.user_profile_photo
        FROM 
           friends f
          JOIN users fu ON f.friend_ID = fu.user_ID
        WHERE 
          f.user_ID = @user_ID;
     ''', {'user_ID': userID});
    List<Map<String, dynamic>> friendList = results
        .map((row) => {
              'user_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes)
            })
        .toList();
    print(friendList);
    return friendList;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<List<Map<String, dynamic>>> getFriendRequests(int userID) async {
  try {
    List<List<dynamic>> results = await dbService.readQuery('''
        SELECT
          u.user_ID,
          u.user_name,
          u.user_profile_photo
        FROM 
           friend_requests fr
          JOIN users u ON fr.sender_ID = u.user_ID
        WHERE 
          fr.receiver_ID = @user_ID;
     ''', {'user_ID': userID});
    List<Map<String, dynamic>> friendRequestList = results
        .map((row) => {
              'user_ID': row[0],
              'user_name': row[1],
              'user_profile_photo': utf8.decode(row[2].bytes)
            })
        .toList();

    return friendRequestList;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<void> acceptFriendRequest(int receiverID, int senderID) async {
  try {
    await dbService.insertQuery('''
        INSERT INTO friends (user_ID, friend_ID) VALUES (@receiver_ID, @sender_ID), (@sender_ID, @receiver_ID);
      ''', {'receiver_ID': receiverID, 'sender_ID': senderID});

    await dbService.deleteQuery('''
        DELETE FROM friend_requests WHERE receiver_ID = @receiver_ID AND sender_ID = @sender_ID; 
      ''', {'receiver_ID': receiverID, 'sender_ID': senderID});
  } catch (e) {
    print(e);
  }
}

Future<void> declineFriendRequest(int receiverID, int senderID) async {
  try {
    await dbService.deleteQuery('''
        DELETE FROM friend_requests WHERE receiver_ID = @receiver_ID AND sender_ID = @sender_ID; 
      ''', {'receiver_ID': receiverID, 'sender_ID': senderID});
  } catch (e) {
    print(e);
  }
}

Future<void> deleteFriend(int userID, int friendID) async {
  try {
    await dbService.deleteQuery('''
        DELETE FROM friends WHERE (user_ID = @user_ID AND friend_ID = @friend_ID) OR (user_ID = @friend_ID AND friend_ID = @user_ID); 
      ''', {'user_ID': userID, 'friend_ID': friendID});
  } catch (e) {
    print(e);
  }
}

Future<void> toggleWorkoutPublic(int workoutID) async {
  try {
    List<List<dynamic>> results = await dbService.readQuery('''
        SELECT
          workout_public
        FROM 
          workouts
        WHERE 
          workout_ID = @workout_ID
        LIMIT 1;
     ''', {'workout_ID': workoutID});

    bool workoutPublic = results
        .map((row) => {'workout_public': row[0]})
        .toList()[0]['workout_public'];

    print('wokrout public stats : $workoutPublic');

    await dbService.updateQuery('''
        UPDATE workouts SET workout_public = @workout_public WHERE workout_id = @workout_id
      ''', {'workout_public': !workoutPublic, 'workout_id': workoutID});

    print('wokrout public stats changed to  : ${!workoutPublic}');
  } catch (e) {
    print(e);
  }
}

Future<void> deleteAccount(int userID) async {
  try {
    await dbService.deleteQuery('''
            DELETE FROM users CASCADE WHERE user_ID = @user_ID;
        ''', {'user_ID': userID});
  } catch (e) {
    print('error deleting account: $e');
  }
}

// GET THE PERCENTAGES FOR ACTIVITIES PER EXERCISE TARGET
// Future<List<Map<String, dynamic>>> getTargetPercentages(int userID) async {
//   try {
//     List<List<dynamic>> query = await dbService.readQuery('''
//         SELECT
//           e.exercise_target,
//           COUNT(w.workout_ID) FILTER (WHERE w.user_ID = @user_ID) AS activity_count,
//           ROUND(
//               COUNT(w.workout_ID) FILTER (WHERE w.user_ID = @user_ID) * 100.0
//               / NULLIF(SUM(COUNT(w.workout_ID) FILTER (WHERE w.user_ID = @user_ID)) OVER (), 0),
//               2
//           ) AS percentage
//         FROM exercises e
//         LEFT JOIN activities a ON e.exercise_ID = a.exercise_ID
//         LEFT JOIN workouts w ON a.workout_ID = w.workout_ID
//         GROUP BY e.exercise_target
//         ORDER BY percentage DESC NULLS LAST;
//       ''', {'user_ID': userID});

//       List<Map<String, dynamic>> queryRows = query
//         .map((row) => {'user_name': row[0], 'content': row[1], 'date': row[2]})
//         .toList();
//   } catch (e) {
//     return
//   }
// }
