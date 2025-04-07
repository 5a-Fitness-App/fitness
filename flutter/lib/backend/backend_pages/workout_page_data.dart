import 'dart:ffi';

import 'connect_database.dart';

int user_id = 2;
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
String workoutTitle = "";
int dateTime = 000000000000; // hour, minute, year, month, day
bool public = false;
String createWorkout = '''INSERT INTO workouts (user_ID, workout_title, workout_date_time, workout_public)
VALUES ($user_id, $workoutTitle, $dateTime, $public)
RETURNING workout_ID;''';

int workoutId = 42; // This comes from the RETURNING workout_ID;
int exerciseId = 1; // ID from the exercises table
String activityName = "Squats";
String activityType = "strength"; // Must match ENUM type
String notes = "3 sets of 10 reps";
int reps = 10;
String activityTime = "2025-04-07 08:15:00"; // timestamp format
String weightMetric = "kg"; // Must match ENUM
int incline = 0;
String distanceMetric = "km";
int distance = 0;
int elevation = 0;

String insertActivity = '''
INSERT INTO activities (
  workout_ID, exercise_ID, activity_name, activity_type, activity_notes,
  activity_reps, activity_time, activity_weight_metric, activity_incline,
  activity_distance_metric, activity_distance, activity_elevation
)
VALUES (
  $workoutId, $exerciseId, '$activityName', '$activityType', '$notes',
  $reps, '$activityTime', '$weightMetric', $incline,
  '$distanceMetric', $distance, $elevation
);
''';


Future<void> main() async {
  try {
    await connection.open();
    print('Connected to PostgreSQL ✅');

    await readQuery(workoutListQuery);
    await insertQuery(, dictionary)
  } catch (e) {
    print('Error connecting to PostgreSQL ❌: $e');
  } finally {
    await connection.close();
    print('Connection closed 🔒');
  }
}
