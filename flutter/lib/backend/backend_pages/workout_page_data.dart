import 'connect_database.dart';

int user_id = 1;
String workoutListQuery = '''
SELECT 
    a.activity_ID,
    a.workout_ID,
    w.user_ID,
    a.activity_name,
    a.activity_type,
    a.activity_distance,
    a.activity_elevation,
    w.workout_date_time,
    w.workout_title,
    u.user_name AS workout_user_name,
    e.exercise_name  -- Adding exercise name to the query
FROM 
    activities a
JOIN 
    workouts w ON a.workout_ID = w.workout_ID
JOIN 
    users u ON w.user_ID = u.user_ID
JOIN 
    exercises e ON a.exercise_ID = e.exercise_ID  -- Join with exercises table to get exercise name
WHERE 
    w.user_ID IN (
        SELECT friend_ID 
        FROM friends 
        WHERE user_ID = $user_id
    )
    AND w.workout_date_time >= CURRENT_DATE - INTERVAL '20 days'
ORDER BY 
    w.workout_date_time DESC;
''';

String workoutQuerryAll = '''SELECT 
    a.activity_ID,
    a.workout_ID,
    w.user_ID,
    a.activity_name,
    a.activity_type,
    a.activity_distance,
    a.activity_elevation,
    w.workout_date_time,
    w.workout_title,
    u.user_name AS workout_user_name,
    e.exercise_name  -- Adding exercise name to the query
FROM 
    activities a
JOIN 
    workouts w ON a.workout_ID = w.workout_ID
JOIN 
    users u ON w.user_ID = u.user_ID
JOIN 
    exercises e ON a.exercise_ID = e.exercise_ID  -- Join with exercises table to get exercise name
WHERE 
    w.user_ID IN (
        SELECT friend_ID 
        FROM friends 
        WHERE user_ID = $user_id
    )
ORDER BY 
    w.workout_date_time DESC;
''';

Map<String, dynamic> workoutData = {
  'user_id': 2,
  'workoutTitle': 'Test 1',
  'workoutDateTime':
      DateTime.now().toIso8601String().split('.').first.replaceFirst('T', ' '),
  'public': false,
};
String createWorkout = '''
INSERT INTO workouts (user_ID, workout_title, workout_date_time, workout_public)
VALUES (@user_id, @workoutTitle, @workoutDateTime, @public)
RETURNING workout_ID;
''';

String getWorkout_IDForUser = '''SELECT workout_ID
FROM workouts
WHERE user_ID = $user_id;''';

int workout_id = 1;
String activityQuery = '''
SELECT 
    a.activity_ID,
    a.workout_ID,
    w.user_ID,
    a.activity_name,
    a.activity_type,
    a.activity_distance,
    a.activity_elevation,
    w.workout_date_time,
    w.workout_title,
    u.user_name AS workout_user_name,
    e.exercise_name
FROM 
    activities a
JOIN 
    workouts w ON a.workout_ID = w.workout_ID
JOIN 
    users u ON w.user_ID = u.user_ID
JOIN 
    exercises e ON a.exercise_ID = e.exercise_ID
WHERE 
    w.user_ID = $user_id
    AND a.workout_ID = $workout_id
ORDER BY 
    a.activity_ID;
''';

String insertActivity = '''
INSERT INTO activities (
  workout_ID, exercise_ID, activity_name, activity_type, activity_notes,
  activity_reps, activity_time, activity_weight_metric, activity_incline,
  activity_distance_metric, activity_distance, activity_elevation
)
VALUES (
  @workoutId, @exerciseId, '@activityName', '@activityType', '@notes',
  @reps, '@activityTime', '@weightMetric', @incline,
  '@distanceMetric', @distance, @elevation
);
''';

Map<String, dynamic> activityData = {
  'workoutId': 0,
  'exerciseId': 0,
  'activityName': 'Squats',
  'activityType': 'strength',
  'notes': '',
  'reps': 0,
  'activityTime':
      DateTime.now().toIso8601String().split('.').first.replaceFirst('T', ' '),
  'weightMetric': 'kg',
  'incline': 0,
  'distanceMetric': 'km',
  'distance': 0,
  'elevation': 0,
};

Future<void> main() async {
  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    await readQuery(activityQuery);
    // await insertQuery(createWorkout, workoutData);
  } catch (e) {
    print('Error connecting to PostgreSQL ❌: $e');
  } finally {
    await connection.close();
    print('Connection closed 🔒');
  }
}
