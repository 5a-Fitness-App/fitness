import '../connect_database.dart';

workoutListQuery =
'''
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
    w.workout_duration,
    w.workout_calories_burnt,
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
    AND w.workout_date_time >= CURRENT_DATE - INTERVAL '3 days'
ORDER BY 
    w.workout_date_time DESC;
''';

readQuery(workoutListQuery);
