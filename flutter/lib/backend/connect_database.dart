import 'package:postgres/postgres.dart';

final connection = PostgreSQLConnection(
  'localhost',
  5432,
  'test2',
  username: 'postgres',
  password: 'abc123',
);

// CREATE (Insert a new user)
Future<void> createUser(String name, String dob, int weight, String email,
    int phone, String password) async {
  await connection.query(
    '''INSERT INTO users (user_name, user_dob, user_weight, user_email, user_phone_number, user_password) 
       VALUES (@name, @dob, @weight, @email, @phone, crypt(@password, gen_salt('bf'::text)))''',
    substitutionValues: {
      'name': name,
      'dob': dob,
      'weight': weight,
      'email': email,
      'phone': phone,
      'password': password,
    },
  );
  print('User created successfully ✅');
}

// READ (Get all users)
Future<void> getUsers() async {
  List<List<dynamic>> results = await connection.query('SELECT * FROM users');

  for (final row in results) {
    print('ID: ${row[0]}, Name: ${row[1]}, Email: ${row[4]}');
  }
}

// READ (Get user by ID)
Future<void> getUserById(int userId) async {
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM users WHERE user_ID = @userId',
    substitutionValues: {'userId': userId},
  );

  if (results.isEmpty) {
    print('User not f children ound ❌');
  } else {
    final row = results.first;
    print('ID: ${row[0]}, Name: ${row[1]}, Email: ${row[4]}');
  }
}

// UPDATE (Modify user details)
Future<void> updateUser(
    int userId, String name, int weight, String email, int phone) async {
  int affectedRows = await connection.execute(
    '''UPDATE users SET user_name = @name, user_weight = @weight, 
       user_email = @email, user_phone_number = @phone WHERE user_ID = @userId''',
    substitutionValues: {
      'userId': userId,
      'name': name,
      'weight': weight,
      'email': email,
      'phone': phone,
    },
  );

  if (affectedRows > 0) {
    print('User updated successfully ✅');
  } else {
    print('User not found ❌');
  }
}

// DELETE (Remove user)
Future<void> deleteUser(int userId) async {
  int affectedRows = await connection.execute(
    'DELETE FROM users WHERE user_ID = @userId',
    substitutionValues: {'userId': userId},
  );

  if (affectedRows > 0) {
    print('User deleted successfully ✅');
  } else {
    print('User not found ❌');
  }
}

// CREATE (Insert a new workout post)
Future<int> createWorkout(int userId, String title, int duration,
    int caloriesBurnt, List<Map<String, dynamic>> activities) async {
  return await connection.transaction((ctx) async {
    // 1️⃣ Insert workout and get its ID
    var result = await ctx.query(
      '''
      INSERT INTO workouts (user_id, workout_title, workout_duration, workout_calories_burnt) 
      VALUES (@userId, @title, @duration, @caloriesBurnt) RETURNING workout_ID
      ''',
      substitutionValues: {
        'userId': userId,
        'title': title,
        'duration': duration,
        'caloriesBurnt': caloriesBurnt,
      },
    );

    int workoutId = result[0][0]; // Get newly created workout ID

    // 2️⃣ Insert activities for this workout
    for (var activity in activities) {
      await ctx.query(
        '''
        INSERT INTO activities (workout_ID, exercise_ID, activity_name, activity_type, activity_distance, activity_elevation) 
        VALUES (@workoutId, @exerciseId, @activityName, @activityType, @activityDistance, @activityElevation)
        ''',
        substitutionValues: {
          'workoutId': workoutId,
          'exerciseId': activity['exerciseId'],
          'activityName': activity['activityName'],
          'activityType': activity['activityType'],
          'activityDistance':
              activity['activityDistance'] ?? 0, // Default to 0 if null
          'activityElevation':
              activity['activityElevation'] ?? 0, // Default to 0 if null
        },
      );
    }

    print('Workout created successfully with multiple activities ✅');
    return workoutId; // ✅ Ensure the workout ID is returned
  });
}

// READ (Get all workout posts)
// READ (Get all workout posts with like and comment counts)
Future<List<Map<String, dynamic>>> getWorkoutsWithDetails() async {
  var workouts = await connection.mappedResultsQuery('''
    SELECT 
        w.workout_ID,
        w.user_ID,
        u.user_name,
        w.workout_title,
        w.workout_date_time,
        w.workout_duration,
        w.workout_calories_burnt,
        COALESCE(l.like_count, 0) AS total_likes
    FROM workouts w
    JOIN users u ON w.user_ID = u.user_ID
    LEFT JOIN (
        SELECT workout_ID, COUNT(*) AS like_count FROM likes GROUP BY workout_ID
    ) l ON w.workout_ID = l.workout_ID
    ORDER BY w.workout_date_time DESC;
    ''');

  List<Map<String, dynamic>> fullWorkouts = [];

  for (var workout in workouts) {
    int workoutId = workout['w']?['workout_ID'];

    // Get Activities for this Workout
    var activities = await connection.mappedResultsQuery(
      '''
      SELECT a.activity_ID, a.exercise_ID, a.activity_name, a.activity_type, a.activity_distance, a.activity_elevation
      FROM activities a
      WHERE a.workout_ID = @workoutId
      ''',
      substitutionValues: {'workoutId': workoutId},
    );

    // Get Comments for this Workout
    var comments = await connection.mappedResultsQuery(
      '''
      SELECT c.comment_ID, c.user_ID, u.user_name, c.content, c.date_commented
      FROM comments c
      JOIN users u ON c.user_ID = u.user_ID
      WHERE c.workout_ID = @workoutId
      ORDER BY c.date_commented ASC;
      ''',
      substitutionValues: {'workoutId': workoutId},
    );

    // Add everything to the final list
    fullWorkouts.add({
      'workout_ID': workoutId,
      'user_ID': workout['w.user_ID'],
      'user_name': workout['u.user_name'],
      'workout_title': workout['w.workout_title'],
      'workout_date_time': workout['w.workout_date_time'],
      'workout_duration': workout['w.workout_duration'],
      'workout_calories_burnt': workout['w.workout_calories_burnt'],
      'total_likes': workout['total_likes'],
      'activities': activities,
      'comments': comments,
    });
  }

  return fullWorkouts;
}

// READ (Get a specific workout post by ID)
Future<void> getWorkoutById(int workoutId) async {
  List<List<dynamic>> results = await connection.query(
    'SELECT * FROM workouts WHERE workout_ID = @workoutId',
    substitutionValues: {'workoutId': workoutId},
  );

  if (results.isEmpty) {
    print('Workout not found ❌');
  } else {
    final row = results.first;
    print(
        'Workout ID: ${row[0]}, User ID: ${row[1]}, Title: ${row[2]}, Duration: ${row[3]} mins, Calories Burnt: ${row[4]}');
  }
}

// UPDATE (Modify workout post details)
Future<void> updateWorkout(
    int workoutId, String title, int duration, int calories) async {
  int affectedRows = await connection.execute(
    '''UPDATE workouts SET workout_title = @title, workout_duration = @duration, 
       workout_calories_burnt = @calories WHERE workout_ID = @workoutId''',
    substitutionValues: {
      'workoutId': workoutId,
      'title': title,
      'duration': duration,
      'calories': calories,
    },
  );

  if (affectedRows > 0) {
    print('Workout updated successfully ✅');
  } else {
    print('Workout not found ❌');
  }
}

// DELETE (Remove a workout post)
Future<void> deleteWorkout(int workoutId) async {
  int affectedRows = await connection.execute(
    'DELETE FROM workouts WHERE workout_ID = @workoutId',
    substitutionValues: {'workoutId': workoutId},
  );

  if (affectedRows > 0) {
    print('Workout deleted successfully ✅');
  } else {
    print('Workout not found ❌');
  }
}

// CREATE (Add a comment to a workout)
Future<void> addComment(int userId, int workoutId, String content) async {
  await connection.query(
    '''
    INSERT INTO comments (user_ID, workout_ID, content) 
    VALUES (@userId, @workoutId, @content)
    ''',
    substitutionValues: {
      'userId': userId,
      'workoutId': workoutId,
      'content': content,
    },
  );

  print('Comment added successfully ✅');
}

// READ (Get all comments for a workout)
Future<void> getWorkoutComments(int workoutId) async {
  List<List<dynamic>> results = await connection.query(
    '''
    SELECT c.comment_ID, u.user_name, c.content, c.date_commented
    FROM comments c
    JOIN users u ON c.user_ID = u.user_ID
    WHERE c.workout_ID = @workoutId
    ORDER BY c.date_commented DESC
    ''',
    substitutionValues: {
      'workoutId': workoutId,
    },
  );

  if (results.isEmpty) {
    print('No comments found for this workout ❌');
  } else {
    for (final row in results) {
      print('''
      Comment ID: ${row[0]}
      User: ${row[1]}
      Comment: ${row[2]}
      Date: ${row[3]}
      --------------------------
      ''');
    }
  }
}

Future<void> main() async {
  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    //await createUser('Alice Smith', '1995-07-22', 68, 'alice.smith@example.com', 9876543210, 'SecurePass!123');
    //await getUsers();
    //await getUserById(1);
    //await updateUser(1, 'Alice Updated', 70, 'alice.updated@example.com', 1234567890);
    // await deleteUser(2);

    // int workoutId = await createWorkout(
    //     1, // User ID
    //     "Morning Routine",
    //     60, // Duration in minutes
    //     400, // Calories burnt
    //     [
    //       {
    //         "exerciseId": 2,
    //         "activityName": "Treadmill Run",
    //         "activityType": "cardio",
    //         "activityDistance": 5,
    //         "activityElevation": 10
    //       },
    //       {
    //         "exerciseId": 3,
    //         "activityName": "Push-ups",
    //         "activityType": "strength"
    //       }
    //     ]);

    // print("New Workout ID: $workoutId");
    // getWorkoutsWithDetails();
    // await getWorkouts();

    // await getWorkoutById(1);
    // await updateWorkout(1, 'Evening Jog', 45, 450);
    // await deleteWorkout(1);

    //await getWorkoutComments(1);
  } catch (e) {
    print('Error connecting to PostgreSQL ❌: $e');
  } finally {
    await connection.close();
    print('Connection closed 🔒');
  }
}

// TODO : get friends' posts, order by date posted
// TODO: get own workouts, order by date posted
// TODO: insert new workout and activities
// TODO: count achievements
// TODO: count login streak
// TODO: get user profile information
